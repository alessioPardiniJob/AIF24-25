# README

## Overview

### Project Title
**Analyzing Genetic Sampler Configurations and Performance Against TPE and CMA-ES for Optimizing Random Forest Models in Hyperspectral Soil Analysis**

### Course and Academic Context
This repository hosts the project developed as part of the AIF 24-25 course of the Master's Degree in Computer Science curriculume Artificial Intelligence at the University of Pisa. The work is inspired by a piece of code built for my thesis entitled "The Hyperview Challenge: proposal of a Machine Learning model to improve the state of the art in estimating soil parameters from hyperspectral images" and aims to perform efficiency and effectiveness analyses of the Optuna genetic sampler, thus connecting with the topic of the course "Genetic Algorithms"

### Goal of the Project
The main objective of this project is to analyze the impact of different parameter configurations in the genetic sampler, comparing its performance with other sampling methods provided by Optuna, such as TPE and CMA-ES. For this purpose, the effectiveness and efficiency of a Random Forest model optimized using hyperparameters generated by each sampling method are evaluated. Cross-validation is employed to measure the model's performance. The model will be trained using data provided by the challenge "The Hyperview: Seeing Beyond the Visible," which was the focus of my undergraduate thesis. For more details about the challenge, you can refer to [the official challenge link](https://platform.ai4eo.eu/seeing-beyond-the-visible-permanent).

---

## Repository Structure
```
project-root/
├── data/                     # Directory that stores all datasets and data files used in the project
│   ├── test_data/            # Subdirectory containing test data files, such as .npz files
│   ├── train_data/           # Subdirectory for training data and related files
│   │   ├── train_data/       # Subdirectory with .npz files for training data
│   │   ├── train_gt.csv      # CSV file with ground truth data for training
│   │   ├── wavelenght.csv    # CSV file containing wavelength-related data
├── notebook/                 # Directory for Jupyter notebooks used in the project
│   ├── PardiniAIF24-25.ipynb # Main notebook file for analysis and experimentation
├── scripts/                  # Directory for scripts related to setup or utilities
│   ├── setup.sh              # Shell script for environment setup (Unix-like)
│   ├── setup.bat             # Batch script for environment setup (Windows)
├── utils/                    # Utility modules and helper scripts
│   ├── __init__.py           # Initialization file for the utils module
│   ├── utils.py              # Python script containing utility functions
├── requirements.txt          # File specifying all Python dependencies needed for the project
├── Makefile                  # Makefile with build automation commands and environment setup
├── README.md                 # Markdown file with project overview, setup instructions, and usage
├── LICENSE                   # File containing the license details for the project

```

---

## Technologies Used
- **Programming Language**: Python 3.9
- **Libraries and Frameworks**:
  - Optuna (v2.10.0): Hyperparameter optimization
  - Scikit-learn (v0.24.2): Machine learning framework for Random Forest
  - Pandas (v1.3.3) & NumPy (v1.21.2): Data manipulation and analysis
  - Matplotlib (v3.4.3) & Seaborn (v0.11.2): Data visualization
- **Environment**:
  - Jupyter Notebooks
  - Git for version control

---

# How to Execute

Below are the recommended steps to execute the project in a **Windows** or **Unix-like** (Linux, macOS) environment. The goal is to set up a virtual environment, install the required dependencies, and run the code/notebook consistently across both operating systems.

---

## 1. Basic Requirements

| Requirement          | Description                                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------------------|
| **Python 3.9+**     | Ensure that Python 3.9 or later is installed on your system.                                                   |
| **pip**             | Python's package manager, which is required to install project dependencies.                                   |
| *(Optional)* WSL2   | *(Windows only)* You can optionally use [WSL2](https://learn.microsoft.com/windows/wsl/install) for a Linux-like environment. |

---

## 2. Clone the Repository

Run the following commands to clone the repository and navigate into its directory:

```bash
git clone https://github.com/your-repo/hyperview-challenge.git
cd hyperview-challenge
```

*(Replace the URL with the actual repository link.)*

---

## 3. Configure the Development Environment

Two scripts are provided in the `scripts/` directory to simplify the setup process:

| Script                | Operating System                  |
|-----------------------|------------------------------------|
| **setup.bat**         | For Windows systems               |
| **setup.sh**          | For Unix-like systems (Linux/macOS) |

Both scripts:
- Check for the presence of Python and pip.
- Create a virtual environment (in the `env` directory).
- Activate the virtual environment.
- Install dependencies from `requirements.txt`.

### 3.1. Windows

1. Navigate to the `scripts` directory:
   ```bash
   cd scripts
   ```

2. Run the `setup.bat` script using Command Prompt, PowerShell, or by double-clicking it:
   ```bash
   setup.bat
   ```

3. Upon successful execution, a completion message will be displayed.

> **Note**: To reactivate the virtual environment in the future:
> ```bash
> env\Scripts\activate
> ```

### 3.2. Unix-like (Linux/macOS)

1. Navigate to the `scripts` directory:
   ```bash
   cd scripts
   ```

2. Make the `setup.sh` script executable and run it:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Upon successful execution, a completion message will be displayed.

> **Note**: To reactivate the virtual environment in the future:
> ```bash
> source env/bin/activate
> ```

---

## 4. How to Run the Code/Notebook

After completing the setup, the virtual environment will be active and all dependencies will be installed. You can now proceed with running the code or notebooks.

### 4.1. Run the Notebook

If a Jupyter notebook is available, run the following command to start the Jupyter server:

```bash
jupyter notebook
```

- In your browser, open the corresponding notebook file (`.ipynb`) and execute the cells.

### 4.2. Run a Python Script

If you need to execute a Python script (e.g., `exp.py`), use the following command:

```bash
python notebook/exp.py
```

- The script will handle tasks such as data loading, preprocessing, and optimization, and will save the final results to an output file (e.g., `final_results.txt`).

> **Reminder**: Ensure the virtual environment is activated before running any commands.

---

## 5. Verify the Installation (Optional)

If you have automated tests (e.g., in the `tests/` folder), you can run them to verify that everything is working as expected:

```bash
python -m unittest discover tests
```

---

## 6. Troubleshooting Common Issues

| Issue                                | Solution                                                                                         |
|-------------------------------------|-------------------------------------------------------------------------------------------------|
| **Modules Not Found**               | Ensure the virtual environment is activated before running commands. Verify `pip install -r requirements.txt`. |
| **Incorrect File Paths**            | Ensure the `data/` directory (and subfolders) is correctly placed and paths in the code/notebook are accurate. |
| **Permission Denied (Unix)**        | If `setup.sh` is not executable, run `chmod +x setup.sh` and retry.                             |

---

---


## Contribution Guidelines
### Reporting Issues
If you encounter any issues or have suggestions for improvement, please create an issue in the repository. Before opening a new issue, check the existing issues to ensure your concern hasn't already been addressed.

### Pull Requests
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit your changes and push the branch:
   ```bash
   git push origin feature/your-feature
   ```
4. Open a pull request with a detailed description.

---

## Authors
- **Author**: Alessio Pardini.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Contact
For any inquiries or questions, please contact [alessiopardinijob@gmail.com].

