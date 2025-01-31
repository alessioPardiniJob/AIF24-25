# README

## Overview

### Project Title
**Analyzing Genetic Sampler Configurations and Performance Against TPE and RandomSampler for Optimizing Random Forest Models in Hyperspectral Soil Analysis**

### Course and Academic Context
This repository hosts the project developed as part of the AIF 24-25 course of the Master's Degree in Computer Science curriculume Artificial Intelligence at the University of Pisa. The work is inspired by a piece of code built for my thesis entitled "The Hyperview Challenge: proposal of a Machine Learning model to improve the state of the art in estimating soil parameters from hyperspectral images" based on the [Hyperview Challenge](#https://platform.ai4eo.eu/seeing-beyond-the-visible-permanent). This project aims to perform efficiency and effectiveness analyses of the Optuna genetic sampler, thus connecting with the topic of the course "Genetic Algorithms"

### Goal of the Project
In this project, we aim to systematically compare various Optuna samplers—focusing on the NSGAIISampler (genetic algorithm-based), while also evaluating the Tree-structured Parzen Estimator (TPE) and Random samplers. The study is centered on optimizing hyperparameters of a Random Forest regressor to predict soil parameters such as P2O5, K, Mg, and pH. To ensure robust analysis, we examine both **efficiency** (CPU time, memory usage) and **effectiveness** (mean squared error improvements) through rigorous 5-fold cross-validation on both augmented and baseline datasets. Additionally, performance metrics are tracked per sampler configuration, providing insights into their practical trade-offs for real-world applications.

---

## Repository Structure
```
project-root/
├── data/                     # Directory that stores all datasets and data files used in the project (populated during setup.sh/setupColab.sh execution)
│   ├── test_data/            # Subdirectory containing test data files, such as .npz files
│   ├── train_data/           # Subdirectory for training data and related files
│   │   ├── train_data/       # Subdirectory with .npz files for training data
│   │   ├── train_gt.csv      # CSV file with ground truth data for training
│   │   ├── wavelenght.csv    # CSV file containing wavelength-related data
├── notebook/                 # Directory for Jupyter notebooks used in the project
│   ├── PardiniAIF24-25.ipynb # Main notebook file for analysis and experimentation
├── scripts/                  # Directory for scripts related to setup
│   ├── setup.sh              # Shell script for environment setup (Unix-like)
│   ├── setupColab.sh         # Shell script for environment setup (Google Colab)
├── utils/                    # Utility modules 
│   ├── __init__.py           # Initialization file for the utils module
│   ├── utils.py              # Python script containing utility functions
├── requirements.txt          # File specifying all Python dependencies needed for the project
├── README.md                 # Markdown file with project overview, setup instructions, and usage
├── LICENSE                   # File containing the license details for the project

```

---
# How to Execute Online (Recommended)

To run the project online using **Google Colab**, simply click the link below and execute the initial setup cells.

[**Open in Google Colab**]([https://colab.research.google.com/](https://colab.research.google.com/github/alessioPardiniJob/AIF24-25/blob/main/notebook/PardiniAIF24-25.ipynb))

### Steps:
1. Open the notebook in Colab.
2. Run the initial setup cells to install dependencies and download required data.
3. Proceed with executing the rest of the notebook.

That's it! 🚀

---

# How to Execute Locally

Below are the recommended steps to execute the project in a **Windows** or **Unix-like** (Linux, macOS) environment. The goal is to set up a virtual environment, install the required dependencies, and run the code/notebook consistently across both operating systems.

---
## 1. Basic Requirements

| Requirement          | Description                                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------------------|
| **Python 3.9+**     | Ensure that Python 3.9+ is installed on your system.                                                   |
| **pip**             | Python's package manager, which is required to install project dependencies.                                   |
| **WSL2 (Windows only)** | If using Windows, install and configure WSL2 with a Linux distribution to enable a Unix-like environment. |

---

## 2. Clone the Repository

Run the following commands to clone the repository and navigate into its directory:

```bash
git clone https://github.com/alessioPardiniJob/AIF24-25
cd AIF24-25
```

---

## 3. Configure the Development Environment

A setup script is provided in the `scripts/` directory to simplify the environment configuration.

### 3.1. Unix-like Systems (Linux/macOS/WSL2)

Since Windows users are required to use WSL2 with a Linux distribution, the same setup instructions apply to all Unix-like environments:

1. Navigate to the `scripts` directory:
   ```bash
   cd scripts
   ```

2. Make the `setup.sh` script executable and run it:
   ```bash
   chmod +x setup.sh
   source setup.sh
   ```

3. Upon successful execution, a completion message will be displayed.

> **Note**: To reactivate the virtual environment in the future:
> ```bash
> source env/bin/activate
> ```

Since WSL2 provides a Linux-like environment, running these commands ensures proper dependency installation and development setup, avoiding inconsistencies with native Windows execution.


---

## 4. How to Run the Notebook

After completing the setup, the virtual environment will be active and all dependencies will be installed. You can now proceed with running the notebook.

### 4.1. Run the Notebook

```bash
jupyter notebook
```

- In your browser, open the corresponding notebook file (`.ipynb`) and execute the cells.

> **Reminder**: Ensure the virtual environment is activated before running any commands. It is recommended to position yourself in the notebook folder before running the following command (e.g., cd ../notebook).
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

