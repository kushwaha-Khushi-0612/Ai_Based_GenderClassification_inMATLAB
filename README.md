# AI-Based Gender Classification in MATLAB

An AI-powered gender classification system using deep learning and facial features. This project implements transfer learning with AlexNet in MATLAB to classify gender from facial images with high accuracy.

![MATLAB](https://img.shields.io/badge/MATLAB-R2020a+-orange.svg)
![Deep Learning](https://img.shields.io/badge/Deep%20Learning-AlexNet-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📋 Table of Contents
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Dataset Structure](#dataset-structure)
- [Quick Start](#quick-start)
- [Usage Guide](#usage-guide)
- [Performance Analysis](#performance-analysis)
- [GPU Support](#gpu-support)
- [Python Preprocessing Tools](#python-preprocessing-tools)
- [Troubleshooting](#troubleshooting)

## ✨ Features

- **Transfer Learning with AlexNet**: Leverages pre-trained AlexNet model for robust feature extraction
- **Interactive GUI**: User-friendly interface for training, testing, and performance analysis
- **Real-time Classification**: Fast gender prediction from facial images
- **Performance Metrics**: Comprehensive evaluation with accuracy, confusion matrix, and ROC curves
- **GPU Acceleration**: Optional GPU support for faster training and inference
- **Automated Dataset Preparation**: Python tools for face extraction and dataset creation

## 🖥️ System Requirements

### MATLAB Requirements

#### Required MATLAB Version
- **MATLAB R2020a or later** (recommended: R2022a+)

#### Required MATLAB Toolboxes
The following toolboxes are **mandatory** for this project to run:

1. **Deep Learning Toolbox**
   - Core requirement for neural network training and inference
   - License code: `nnet`

2. **Computer Vision Toolbox**
   - Required for image processing and augmentation
   - License code: `vision`

3. **Image Processing Toolbox**
   - Essential for image manipulation and preprocessing
   - License code: `images`

4. **Statistics and Machine Learning Toolbox**
   - Required for data analysis and performance metrics
   - License code: `stats`

#### Required Pre-trained Model
- **Deep Learning Toolbox Model for AlexNet Network**
  - This is a separate installation from the Deep Learning Toolbox
  - Must be installed from MATLAB Add-On Explorer
  - Required for transfer learning

#### Optional (Recommended) Toolboxes

5. **Parallel Computing Toolbox** *(Optional but recommended)*
   - Enables GPU acceleration for training and inference
   - Significantly speeds up computation time
   - License code: `distcomp`
   - **GPU Support Requirements**:
     - CUDA-compatible NVIDIA GPU (Compute Capability 3.5+)
     - CUDA Toolkit (version compatible with your MATLAB version)
     - cuDNN library

### Hardware Requirements

#### Minimum Requirements
- **CPU**: Intel i5 / AMD Ryzen 5 or better
- **RAM**: 8 GB minimum
- **Storage**: 2 GB free space
- **Display**: 1280x720 minimum resolution

#### Recommended for GPU Acceleration
- **GPU**: NVIDIA GPU with 4GB+ VRAM (GTX 1050 Ti or better)
- **RAM**: 16 GB
- **Storage**: 5 GB free space (for dataset and models)

### Operating System
- Windows 10/11
- macOS 10.14+
- Linux (Ubuntu 18.04+)

## 📦 Installation

### Step 1: Install MATLAB Toolboxes

1. Open MATLAB
2. Go to **Home → Add-Ons → Get Add-Ons**
3. Search for and install each of the following:
   - Deep Learning Toolbox
   - Computer Vision Toolbox
   - Image Processing Toolbox
   - Statistics and Machine Learning Toolbox
   - Parallel Computing Toolbox *(optional, for GPU support)*

### Step 2: Install AlexNet Model

This is the most critical step - **AlexNet must be installed separately**:

#### Method 1: Automatic Installation (Recommended)
```matlab
% Run this in MATLAB Command Window
net = alexnet;
```
This will prompt automatic installation of AlexNet if not already installed.

#### Method 2: Manual Installation
1. Go to **Home → Add-Ons → Get Add-Ons**
2. Search for: **"Deep Learning Toolbox Model for AlexNet Network"**
3. Click **Install**
4. Wait for the installation to complete

### Step 3: Verify Installation

Run the requirements checker:
```matlab
checkRequirements
```

You should see:
```
✓ Deep Learning Toolbox - INSTALLED
✓ Computer Vision Toolbox - INSTALLED
✓ Image Processing Toolbox - INSTALLED
✓ Statistics and Machine Learning Toolbox - INSTALLED
✓ AlexNet is available and loaded successfully!

=== System Ready! ===
```

### Step 4: GPU Setup (Optional)

If you want to use GPU acceleration:

1. **Verify GPU Availability**:
   ```matlab
   gpuDevice
   ```

2. **Check CUDA/cuDNN installation**:
   ```matlab
   canUseGPU()
   ```

3. If GPU is not detected, install:
   - [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)
   - [cuDNN Library](https://developer.nvidia.com/cudnn)

## 📁 Dataset Structure

The project expects the following folder structure:

```
Ai_Based_GenderClassification_inMATLAB/
│
├── dataset/                      # Training dataset
│   ├── male/                     # Male face images
│   │   ├── male_001.jpg
│   │   ├── male_002.jpg
│   │   └── ...
│   └── female/                   # Female face images
│       ├── female_001.jpg
│       ├── female_002.jpg
│       └── ...
│
├── test/                         # Testing dataset
│   ├── male/                     # Male test images
│   └── female/                   # Female test images
│
├── trained_model.mat             # Saved trained model (generated)
│
└── *.m                           # MATLAB scripts
```

### Dataset Guidelines
- **Image Format**: JPG, PNG (JPG recommended)
- **Image Size**: Minimum 227x227 pixels (AlexNet input size)
- **Face Quality**: Clear, frontal faces work best
- **Recommended Training Images**: 500+ per class
- **Recommended Test Images**: 50+ per class

## 🚀 Quick Start

### Option 1: Complete Setup and Launch (Recommended)

Double-click or run in MATLAB:
```matlab
run_project
```

This will:
1. Check all requirements
2. Prepare the dataset
3. Launch the GUI automatically

### Option 2: Manual Launch

```matlab
% 1. Check requirements first
checkRequirements

% 2. Prepare dataset (if needed)
prepareDataset

% 3. Launch GUI
GenderDetectionGUI
```

### Option 3: Complete Setup Script

```matlab
setupAndRun
```

## 📖 Usage Guide

### Training the Model

1. **Launch the GUI**: Run `GenderDetectionGUI`

2. **Start Training**:
   - Click **"Training Process"** button
   - The system will:
     - Load AlexNet pre-trained model
     - Prepare your dataset (from `dataset/` folder)
     - Perform data augmentation
     - Fine-tune the network using transfer learning
     - Display training progress (accuracy and loss curves)
     - Save the trained model as `trained_model.mat`

3. **Training Parameters** (configurable in `trainGenderClassifier.m`):
   - Initial Learning Rate: 0.0001
   - Max Epochs: 10
   - Mini-batch Size: 32
   - Validation Frequency: 10
   - L2 Regularization: 0.0001

4. **Monitor Training**:
   - View real-time accuracy plot
   - View real-time loss plot
   - See sample training images
   - Read status updates

### Loading a Pre-trained Model

If you already have a trained model:
1. Click **"Load Network"** button
2. Select your `trained_model.mat` file
3. The model is ready for testing

### Testing/Classification

1. **Ensure Model is Loaded**:
   - Either train a new model OR load an existing one

2. **Select Test Image**:
   - Click **"Browse Test Image"**
   - Choose a face image (JPG/PNG)
   - The image will be displayed

3. **Classify**:
   - Click **"Testing Process"**
   - View the prediction: **MALE** or **FEMALE**
   - See the confidence score

### Performance Analysis

1. **Run Evaluation**:
   - Click **"Performance Analysis"** button
   - The system will:
     - Evaluate the model on test dataset (`test/` folder)
     - Generate confusion matrix
     - Plot ROC curve
     - Calculate accuracy metrics

2. **View Metrics**:
   - Overall Accuracy
   - Precision, Recall, F1-Score per class
   - Confusion Matrix visualization
   - ROC Curve and AUC

## 📊 Performance Analysis

The system provides comprehensive performance metrics:

### Confusion Matrix
- True Positives / True Negatives
- False Positives / False Negatives
- Per-class accuracy

### ROC Curve
- Receiver Operating Characteristic curve
- Area Under Curve (AUC) score
- Optimal threshold visualization

### Classification Metrics
- **Accuracy**: Overall classification accuracy
- **Precision**: Positive predictive value
- **Recall**: True positive rate (Sensitivity)
- **F1-Score**: Harmonic mean of precision and recall

## 🚀 GPU Support

### Enabling GPU Acceleration

GPU support is **automatic** if you have:
1. Parallel Computing Toolbox installed
2. CUDA-compatible NVIDIA GPU
3. Properly configured CUDA/cuDNN

### Verification

```matlab
% Check GPU availability
gpuDevice

% Expected output:
% CUDADevice with properties:
%   Name: 'NVIDIA GeForce ...'
%   Index: 1
%   ComputeCapability: '7.5'
%   ...
```

### Performance Benefits
- **Training Speed**: 5-10x faster with GPU
- **Inference Speed**: 3-5x faster with GPU
- **Batch Processing**: Handle larger mini-batches

### GPU Memory Requirements
- Minimum: 2 GB VRAM
- Recommended: 4 GB+ VRAM

## 🐍 Python Preprocessing Tools

Optional Python utilities for face extraction and dataset preparation.

### Purpose
- Extract faces from images/videos using MTCNN
- Classify faces by gender using DeepFace
- Automatically organize into male/female folders
- Create test dataset splits

### Python Setup (Optional)

1. **Activate Virtual Environment** (if exists):
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```

2. **Install Dependencies**:
   ```bash
   cd AI_Gender_Detection_System
   pip install -r requirements.txt
   ```

3. **Run Face Extraction**:
   ```bash
   python datasetPrepration.py
   ```

4. **Create Test Dataset**:
   ```bash
   python create_test_dataset.py
   ```

### Python Requirements
See `AI_Gender_Detection_System/requirements.txt` for:
- OpenCV (face detection)
- PyTorch + facenet-pytorch (MTCNN)
- TensorFlow + DeepFace (gender classification)

**Note**: Python tools are **optional** - the main MATLAB project works independently.

## 🔧 Troubleshooting

### Issue: "AlexNet not found"

**Solution**:
```matlab
% Run this to trigger automatic installation
alexnet
```
Or manually install from Add-On Explorer (see Installation Step 2).

### Issue: "Toolbox not installed"

**Solution**:
Run `checkRequirements` to see which toolboxes are missing, then install from Add-On Explorer.

### Issue: "GPU not detected"

**Diagnosis**:
```matlab
gpuDevice  % Should show GPU info
```

**Solutions**:
- Install/update NVIDIA GPU drivers
- Install CUDA Toolkit compatible with your MATLAB version
- Install cuDNN library
- Verify GPU is CUDA-compatible (Compute Capability 3.5+)

### Issue: "Out of memory during training"

**Solutions**:
1. Reduce mini-batch size in `trainGenderClassifier.m`:
   ```matlab
   options = trainingOptions('adam', ...
       'MiniBatchSize', 16, ...  % Reduce from 32
       ...
   ```

2. If using GPU, try CPU instead:
   ```matlab
   options = trainingOptions('adam', ...
       'ExecutionEnvironment', 'cpu', ...
       ...
   ```

### Issue: "Dataset folder not found"

**Solution**:
Ensure you have created:
```
dataset/
  ├── male/      (with male face images)
  └── female/    (with female face images)
```

### Issue: "Test images not found"

**Solution**:
```matlab
% Auto-create test split from dataset
createTestDatasetSplit
```

## 📝 Project Files

### Main MATLAB Scripts
- **`run_project.m`** - Quick start script (run this first!)
- **`setupAndRun.m`** - Complete setup with GUI launch
- **`GenderDetectionGUI.m`** - Main GUI application
- **`checkRequirements.m`** - Verify toolbox installation
- **`trainGenderClassifier.m`** - Model training logic
- **`classifyGender.m`** - Single image classification
- **`evaluateModel.m`** - Model performance evaluation
- **`prepareDataset.m`** - Dataset validation
- **`plotConfusionMatrix.m`** - Confusion matrix visualization
- **`plotROCCurve.m`** - ROC curve plotting
- **`displayAccuracyMetrics.m`** - Metrics display
- **`createTestDatasetSplit.m`** - Auto-create test dataset

### Python Scripts (Optional)
- **`AI_Gender_Detection_System/datasetPrepration.py`** - Face extraction
- **`AI_Gender_Detection_System/create_test_dataset.py`** - Test set creation
- **`AI_Gender_Detection_System/requirements.txt`** - Python dependencies

## 🎯 Key Features of AlexNet Transfer Learning

### Why AlexNet?
- **Pre-trained on ImageNet**: 1.2 million images, 1000 classes
- **Proven Architecture**: Winner of ImageNet 2012 competition
- **Good Feature Extraction**: 5 convolutional layers + 3 fully connected layers
- **Fast Training**: Transfer learning requires minimal epochs
- **MATLAB Support**: Native support in Deep Learning Toolbox

### Transfer Learning Process
1. **Load Pre-trained AlexNet**: Pre-trained weights from ImageNet
2. **Replace Final Layers**: Modify for 2-class classification (male/female)
3. **Freeze Early Layers**: Keep low-level feature extractors
4. **Fine-tune**: Train only final layers on gender dataset
5. **Result**: High accuracy with minimal training data

### Model Architecture
```
Input (227x227x3)
   ↓
Conv1-5 (Pre-trained features) ← Frozen
   ↓
FC6-FC7 (Pre-trained) ← Fine-tuned
   ↓
FC8 (New: 2 classes) ← Trained from scratch
   ↓
Softmax → Output: [Male, Female]
```

## 📄 License

This project is licensed under the MIT License.

## 👥 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📧 Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review MATLAB documentation for specific toolboxes
3. Open an issue on the project repository

## 🎓 Citation

If you use this project in your research, please cite:

```
AI-Based Gender Classification using AlexNet Transfer Learning
MATLAB Implementation, 2026
```

---

**Happy Classifying! 🎉**

*Built with ❤️ using MATLAB Deep Learning Toolbox*
