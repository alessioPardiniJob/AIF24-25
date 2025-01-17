# README

## Overview

### Project Title
**The Hyperview Challenge: Improving Soil Parameter Estimation from Hyperspectral Images using Machine Learning**

### Course and Academic Context
This repository hosts the project developed as part of the AIF 24-25 course within the Artificial Intelligence track of the Computer Science Master's program at the University of Pisa. The work is based on a thesis titled "The Hyperview Challenge: proposta di un modello di Machine Learning per migliorare lo stato dell’arte nella stima dei parametri del suolo da immagini iperspettrali."

### Goal of the Project
The primary goal of this project is to enhance the estimation of soil parameters from hyperspectral images by:
1. Analyzing the influence of different parameter configurations in the genetic sampler. The genetic sampler is particularly important as it leverages evolutionary strategies to explore complex and high-dimensional parameter spaces effectively.
2. Comparing the genetic sampler's performance with other samplers provided by Optuna, such as TPE and CMA-ES, to evaluate its advantages in specific optimization contexts.
3. Evaluating the efficiency and effectiveness of a Random Forest model using hyperparameters optimized through various Optuna sampling processes.

---

## Features
- **Machine Learning Optimization**: Implements advanced hyperparameter optimization strategies using Optuna.
- **Open-Source Compatibility**: Fully reliant on open-source tools for maximum accessibility.
- **Self-Contained Execution**: Designed to be easily downloaded and run without additional setup complexities.

---

## Repository Structure
```
project-root/
|— data/               # Contains all data files used in the project
|   — raw/            # Raw hyperspectral data as received from sources
|   — processed/      # Preprocessed datasets ready for analysis
|— notebooks/          # Jupyter notebooks for development and experimentation
|   — exploratory/    # Contains notebooks for data exploration and visualization
|   — optimization/   # Notebooks for performing hyperparameter tuning
|— src/                # Source code for the project
|   — models/         # Implementation of machine learning models
|   — samplers/       # Custom genetic sampler and Optuna integration scripts
|— results/            # Stores outputs and logs from experiments
|   — logs/           # Detailed logs of training and optimization processes
|   — comparisons/    # Performance metrics and visualizations for different samplers
|— tests/              # Automated tests to ensure code reliability
|   — unit/           # Unit tests for individual components
|   — integration/    # Tests for the interaction between different parts of the pipeline
|— docs/               # Additional documentation and external references
— README.md            # Project overview (this file)
— requirements.txt     # Python dependencies
— LICENSE              # License information
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

## Installation
### Prerequisites
1. Ensure Python 3.9 is installed (open-source).
2. Install pip, the Python package manager.
3. For Windows users: Install and configure Windows Subsystem for Linux (WSL2) to create a Linux-based development environment.

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/hyperview-challenge.git
   cd hyperview-challenge
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Verify the installation:
   ```bash
   python -m unittest discover tests
   ```

---

## Usage
### Data Preparation
1. Place raw hyperspectral data in the `data/raw/` directory.
2. Run preprocessing scripts to generate processed datasets in `data/processed/`. Use the following command for a self-contained execution:
   ```bash
   python src/preprocessing.py --input data/raw/ --output data/processed/
   ```
   Ensure all dependencies are installed from `requirements.txt` to streamline the process for easy setup.
   Example command:
   ```bash
   python src/preprocessing.py --input data/raw/ --output data/processed/
   ```

### Model Training and Optimization
1. Navigate to `notebooks/optimization/`.
2. Run the optimization notebooks to:
   - Configure and execute the genetic sampler.
   - Compare its performance with other Optuna samplers.
3. Results will be saved in the `results/` folder.

### Performance Analysis
1. Use the notebooks in `results/comparisons/` to visualize and interpret performance metrics.

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

## Authors and Acknowledgments
- **Author**: [Your Name], under the supervision of [Advisor’s Name].
- **Acknowledgments**: Special thanks to the AIF 24-25 faculty at the University of Pisa for their guidance and support.

---

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Contact
For any inquiries or questions, please contact [Your Email].

