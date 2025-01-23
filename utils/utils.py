# Importazioni standard
import os
import sys
import time
import gc
import multiprocessing as mp
from glob import glob

# Importazioni di terze parti
import numpy as np  # Assicurati che numpy sia importato qui
import pandas as pd
from tqdm import tqdm
import pywt
import psutil
import optuna
from optuna.samplers import (
    NSGAIISampler,
    TPESampler,
    RandomSampler,
)
from optuna.samplers.nsgaii import SPXCrossover, UNDXCrossover, SBXCrossover
from sklearn.model_selection import KFold
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error


def load_data(directory: str, gt_file_path: str, is_train=True, augment_constant: int = 0, DEBUG: bool = False, LABEL_MAXS = None):
    """Load each cube, reduce its dimensionality and append to array.

    Args:
        directory (str): Directory to either train or test set
        gt_file_path (str): File path for the ground truth labels (expected CVS file)
        is_train (boolean): Binary flag for setting loader for Train (TRUE) or Test (FALSE)
        augment_constant (int): number of augmentation steps to randomly crop from the larger agricultural fields
    Returns:
        [type]: Tuple of lists composed of raw field (data , mask) pairs,
                and if exists: (augmented data, augmented mask) pairs, and ground truth labels
    """
    
    datalist = []
    masklist = []
    aug_datalist = []
    aug_masklist = []
    aug_labellist = []

    if is_train:
        labels = load_gt(gt_file_path, LABEL_MAXS)

    all_files = np.array(
        sorted(
            glob(os.path.join(directory, "*.npz")),
            key=lambda x: int(os.path.basename(x).replace(".npz", "")),
        )
    )

    if DEBUG:
        all_files = all_files[:10]
        if is_train:
            labels = labels[:10]

    for idx, file_name in tqdm(enumerate(all_files),total=len(all_files), desc="Loading {} data .."
                               .format("training" if is_train else "test")):
       # We load the data into memory as provided in the example notebook of the challenge
        with np.load(file_name) as npz:
            mask = npz["mask"]
            data = npz["data"]
            datalist.append(data)
            masklist.append(mask)
            
    # for training data we make pre-augmentation by adding some randomly cropped samples
    if is_train: 
        for i in range(augment_constant):
            for idx, file_name in tqdm(enumerate(all_files),total=len(all_files), desc="Loading augmentation {} ..".format(i+1)):
                # print(file_name)
                with np.load(file_name) as npz:
                    flag = True
                    mask = npz["mask"]
                    data = npz["data"]
                    ma = np.max(data, keepdims=True)
                    sh = data.shape[1:]
                    for i in range(10): 
                        # Repeating 11x11 cropping 10 times does not mean we use all croppings:
                        # as seen in the Flag=False below at the end of the loop, 
                        # when we reach at the good crop (not coinciding to the masked area) we stop searching 
                        
                        # Randomly cropping the fields with 11x11 size, 
                        # and adding some noise to the cropped samples 
                        edge = 11  
                        x = np.random.randint(sh[0] + 1 - edge)
                        y = np.random.randint(sh[1] + 1 - edge)
                        
                        # get crops having meaningful pixels, not zeros
                        if np.sum(mask[0, x : (x + edge), y : (y + edge)]) > 120: 
                            aug_data = (data[:, x : (x + edge), y : (y + edge)]
                                        + np.random.uniform(-0.01, 0.01, (150, edge, edge)) * ma)
                            aug_mask = mask[:, x : (x + edge), y : (y + edge)] | np.random.randint(0, 1, (150, edge, edge))
                            
                            flag = False #break the loop when you have a meaningful crop
                            break

                    # After having  11x11 croped sample, get another crop considering 
                    # the minimum edge length: (min_edge,min_edge)
                    if flag: 
                        max_edge = np.max(sh)
                        min_edge = np.min(sh)  # AUGMENT BY SHAPE
                        edge = min_edge  # np.random.randint(16, min_edge)
                        x = np.random.randint(sh[0] + 1 - edge)
                        y = np.random.randint(sh[1] + 1 - edge)
                        aug_data = (data[:, x : (x + edge), y : (y + edge)]
                                    + np.random.uniform(-0.001, 0.001, (150, edge, edge)) * ma)
                        aug_mask = mask[:, x : (x + edge), y : (y + edge)] | np.random.randint(0, 1, (150, edge, edge))

                    aug_datalist.append(aug_data)
                    aug_masklist.append(aug_mask)
                    aug_labellist.append(
                        labels[idx, :]
                        + labels[idx, :] * np.random.uniform(-0.001, 0.001, 4)
                    )

    # do pre-augmentation only for training data
    if is_train: 
        return (datalist,
                masklist,
                labels,
                aug_datalist,
                aug_masklist,
                np.array(aug_labellist))
    else:
        return datalist, masklist


def load_gt(file_path: str, LABEL_MAXS = None):
    """Load labels for train set from the ground truth file.
    Args:
        file_path (str): Path to the ground truth .csv file.
    Returns:
        [type]: 2D numpy array with soil properties levels
    """
    gt_file = pd.read_csv(file_path)
    labels = gt_file[["P", "K", "Mg", "pH"]].values / LABEL_MAXS  # normalize ground-truth between 0-1
    
    return labels



def preprocess(data_list, mask_list): 
    """Extract high-level features from the raw field data.

    Args:
        data_list: Directory to either train or test set
        mask_list: File path for the ground truth labels (expected CVS file)
    Returns:
        [type]: Tuple of lists composed of (features , field size) pairs for each field, 
                where field size will be used performance analysis.
    """
        
    def _shape_pad(data):
        # This sub-function makes padding to have square fields sizes.
        # Not mandatory but eliminates the risk of calculation error in singular value decomposition,
        # padding by warping also improves the performance slightly.
        max_edge = np.max(image.shape[1:])
        shape = (max_edge, max_edge)
        padded = np.pad(data,((0, 0), (0, (shape[0] - data.shape[1])), (0, (shape[1] - data.shape[2]))),"wrap")
        return padded
    
    filtering = SpectralCurveFiltering()
    w1 = pywt.Wavelet("sym3")
    w2 = pywt.Wavelet("dmey")

    processed_data = []
    average_edge = []

    for idx, (data, mask) in enumerate(
        tqdm(
            zip(data_list, mask_list),
            total=len(data_list),
            position=0,
            leave=True,
            desc="INFO: Preprocessing data ...",
        )
    ):
        data = data / 2210   # max-max=5419 mean-max=2210
        m = 1 - mask.astype(int)
        image = data * m

        average_edge.append((image.shape[1] + image.shape[2]) / 2)
        image = _shape_pad(image)

        s = np.linalg.svd(image, full_matrices=False, compute_uv=False)
        s0 = s[:, 0]  
        s1 = s[:, 1]  
        s2 = s[:, 2] 
        s3 = s[:, 3]  
        s4 = s[:, 4]   
        dXds1 = s0 / (s1 + np.finfo(float).eps)


        data = np.ma.MaskedArray(data, mask)
        arr = filtering(data)

        cA0, cD0 = pywt.dwt(arr, wavelet=w2, mode="constant")
        cAx, cDx = pywt.dwt(cA0[12:92], wavelet=w2, mode="constant")
        cAy, cDy = pywt.dwt(cAx[15:55], wavelet=w2, mode="constant")
        cAz, cDz = pywt.dwt(cAy[15:35], wavelet=w2, mode="constant")
        cAw2 = np.concatenate((cA0[12:92], cAx[15:55], cAy[15:35], cAz[15:25]), -1)
        cDw2 = np.concatenate((cD0[12:92], cDx[15:55], cDy[15:35], cDz[15:25]), -1)

        cA0, cD0 = pywt.dwt(arr, wavelet=w1, mode="constant")
        cAx, cDx = pywt.dwt(cA0[1:-1], wavelet=w1, mode="constant")
        cAy, cDy = pywt.dwt(cAx[1:-1], wavelet=w1, mode="constant")
        cAz, cDz = pywt.dwt(cAy[1:-1], wavelet=w1, mode="constant")
        cAw1 = np.concatenate((cA0, cAx, cAy, cAz), -1)
        cDw1 = np.concatenate((cD0, cDx, cDy, cDz), -1)

        dXdl = np.gradient(arr, axis=0)
        d2Xdl2 = np.gradient(dXdl, axis=0)
        d3Xdl3 = np.gradient(d2Xdl2, axis=0)


        fft = np.fft.fft(arr)
        real = np.real(fft)
        imag = np.imag(fft)
        ffts = np.fft.fft(s0)
        reals = np.real(ffts)
        imags = np.imag(ffts)

        # The best Feature combination for Random Forest based regression
        out_rf = np.concatenate(
            [
                arr,
                dXdl,
                d2Xdl2,
                d3Xdl3,
                dXds1,
                s0,
                s1,
                s2,
                s3,
                s4,
                real,
                imag,
                reals,
                imags,
                cAw1,
                cAw2,
            ],
            -1,
        )
        

        processed_data.append(out_rf)

    return np.array(processed_data), np.array(average_edge)



class SpectralCurveFiltering: # Default class provided by the challenge organizers
    """
    Create a histogram (a spectral curve) of a 3D cube, using the merge_function
    to aggregate all pixels within one band. The return array will have
    the shape of [CHANNELS_COUNT]
    """

    def __init__(self, merge_function=np.mean):
        self.merge_function = merge_function

    def __call__(self, sample: np.ndarray):
        return self.merge_function(sample, axis=(1, 2))
    


class BaselineRegressor:
    """
    Baseline regressor, which calculates the mean value of the target from the training
    data and returns it for each testing sample.
    """

    def __init__(self):
        self.mean = 0

    def fit(self, X_train: np.ndarray, y_train: np.ndarray):
        self.mean = np.mean(y_train, axis=0)
        self.classes_count = y_train.shape[1]
        return self

    def predict(self, X_test: np.ndarray):
        return np.full((len(X_test), self.classes_count), self.mean)