# 🎭 AI-Based Gender Classification in MATLAB

> **Real-time gender classification using AlexNet transfer learning with an interactive GUI**

![MATLAB](https://img.shields.io/badge/MATLAB-R2020a+-orange.svg)
![Deep Learning](https://img.shields.io/badge/AlexNet-Transfer%20Learning-blue.svg)
![Accuracy](https://img.shields.io/badge/Accuracy-100%25-success.svg)

Built with MATLAB's Deep Learning Toolbox. Achieves **100% accuracy** on balanced datasets using transfer learning from pre-trained AlexNet. No model file included - train your own in minutes!

---

## 🚀 Quick Demo

### Training Interface
<div align="center">
<img src="Ui Images/Training.jpeg" alt="Training Interface" width="800">

*One-click training with real-time accuracy/loss visualization and sample image display*
</div>

### Performance Analysis & Results
<div align="center">
<table>
<tr>
<td><img src="Ui Images/analysis_1.jpeg" alt="100% Accuracy" width="400"></td>
<td><img src="Ui Images/analysis_4.jpeg" alt="Metrics" width="400"></td>
</tr>
</table>

*Comprehensive evaluation: Confusion Matrix, ROC Curve (AUC=1.0), Training Metrics*

<img src="Ui Images/analysis_5.jpeg" alt="Full Interface" width="800">

*Complete three-panel workflow: Training → Testing → Performance Analysis*
</div>

---

## ⚡ Quick Start (3 Steps)

```matlab
% 1. Run automatic setup and launch GUI
run_project

% 2. In the GUI: Click "Training Process" to train the model (~5-10 min)

% 3. Click "Browse Test Image" → "Testing Process" to classify
```

**That's it!** The system handles everything: dataset validation, model training, and GUI setup.

---

## 📋 Requirements

| Component | Version | Required |
|-----------|---------|----------|
| **MATLAB** | R2020a+ | ✅ Yes |
| **Deep Learning Toolbox** | Latest | ✅ Yes |
| **Computer Vision Toolbox** | Latest | ✅ Yes |
| **Image Processing Toolbox** | Latest | ✅ Yes |
| **Statistics Toolbox** | Latest | ✅ Yes |
| **AlexNet Model** | Latest | ✅ Yes |
| **Parallel Computing Toolbox** | Latest | ⚡ Optional (GPU) |
| **NVIDIA GPU (CUDA)** | Compute 3.5+ | ⚡ Optional (5-10x faster) |

### Installing AlexNet (Critical!)

AlexNet is a **separate download** from Deep Learning Toolbox:

```matlab
% Method 1: Trigger auto-install
alexnet

% Method 2: Manual install
% Home → Add-Ons → Get Add-Ons → Search "AlexNet" → Install
```

Verify installation:
```matlab
checkRequirements  % Runs full system check
```

---

## 📁 Dataset Setup

Create this folder structure with your face images:

```
project/
├── dataset/           ← Training images (80%)
│   ├── male/          (500+ JPG images recommended)
│   └── female/        (500+ JPG images recommended)
└── test/              ← Testing images (20%)
    ├── male/          (50+ JPG images)
    └── female/        (50+ JPG images)
```

**Dataset Guidelines:**
- **Format:** JPG/PNG (JPG preferred)
- **Size:** Minimum 227×227px (AlexNet input)
- **Content:** Clear frontal faces, one person per image
- **Balance:** Equal male/female counts for best results

**Auto-create test split:**
```matlab
createTestDatasetSplit  % Randomly splits dataset/ → test/
```

### 🐍 Optional: Python Face Extraction Tool

If you have raw images/videos, use the included Python tool to extract and classify faces:

```bash
cd "AI_Gender_Detection_System"
pip install -r requirements.txt
python datasetPrepration.py  # Extracts faces using MTCNN + DeepFace
```

See [`AI_Gender_Detection_System/README.md`](AI_Gender_Detection_System/README.md) for details.

---

## 🎯 Complete Usage Guide

### 1️⃣ Launch the System

```matlab
run_project  % Automatic setup + GUI launch
```

Or manually:
```matlab
GenderDetectionGUI  % Direct GUI launch
```

### 2️⃣ Train the Model

**In GUI Left Panel (Training Process):**

1. Click **"Training Process"** button
2. Watch real-time training:
   - Accuracy curve (should reach ~95%+)
   - Loss curve (should decrease steadily)
   - Sample training images
3. Wait ~5-10 minutes (depends on dataset size & GPU)
4. Model auto-saves as `trained_model.mat`

**Training Parameters (in `trainGenderClassifier.m`):**
```matlab
Learning Rate:   0.0001
Epochs:          10
Batch Size:      32
Optimizer:       Adam
L2 Regularization: 0.0001
```

**Load Existing Model:**
- Click **"Load Network"** → Select `trained_model.mat`

> ⚠️ **Note:** `trained_model.mat` is NOT included in this repo (file too large for Git). You must train your own model - it only takes 5-10 minutes!

### 3️⃣ Test/Classify Images

**In GUI Center Panel (Testing Process):**

1. Click **"Browse Test Image"** → Select a face image
2. Click **"Testing Process"**
3. View results:
   - **Test Image:** Original upload
   - **Face Detection:** Detected face region
   - **ROI Region:** Cropped face
   - **Preprocessed:** Resized 227×227 for AlexNet
   - **Classification Result:** MALE or FEMALE with confidence score

### 4️⃣ Evaluate Performance

**In GUI Right Panel (Performance Analysis):**

1. Click **"Performance Analysis"** button
2. System evaluates on entire `test/` folder
3. View comprehensive metrics:
   - **Confusion Matrix:** True/False Positives & Negatives
   - **ROC Curve:** AUC score (1.0 = perfect)
   - **Model Accuracy:** Overall % and error rate
   - **Training Loss:** Convergence visualization

**Expected Results:**
- Accuracy: **95-100%** on balanced datasets
- AUC: **>0.95** (1.0 = perfect binary classifier)
- Training Time: **5-10 min** (CPU) / **1-2 min** (GPU)

---

## 🎓 How It Works (Transfer Learning)

```
Pre-trained AlexNet (ImageNet: 1.2M images, 1000 classes)
         ↓
    [Conv Layers 1-5] ← Frozen (extract low-level features)
         ↓
    [FC Layers 6-7]   ← Fine-tuned on your dataset
         ↓
    [FC Layer 8]      ← NEW: 2 classes (Male/Female)
         ↓
      Softmax → [Male, Female] probabilities
```

**Why Transfer Learning?**
- ✅ Requires minimal training data (500+ images vs. millions)
- ✅ Trains fast (minutes vs. days)
- ✅ Achieves high accuracy (95-100%)
- ✅ Pre-learned features (edges, textures, shapes)

---

## ⚡ GPU Acceleration (Optional)

**Enable GPU for 5-10x faster training:**

1. **Check GPU availability:**
```matlab
gpuDevice  % Shows GPU info
canUseGPU  % Returns true/false
```

2. **Install CUDA + cuDNN:**
   - [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) (match your MATLAB version)
   - [cuDNN Library](https://developer.nvidia.com/cudnn)

3. **GPU auto-detected in training** (if Parallel Computing Toolbox installed)

**Performance:**
- CPU (i5/i7): ~5-10 min training
- GPU (GTX 1050+): ~1-2 min training

---

## 🛠️ Project Files

| File | Purpose |
|------|---------|
| `run_project.m` | 🚀 **START HERE** - Auto setup + GUI |
| `GenderDetectionGUI.m` | Main application GUI |
| `trainGenderClassifier.m` | AlexNet training logic |
| `classifyGender.m` | Single image classification |
| `evaluateModel.m` | Performance metrics |
| `checkRequirements.m` | Verify MATLAB setup |
| `plotConfusionMatrix.m` | Confusion matrix viz |
| `plotROCCurve.m` | ROC curve plotting |
| `trained_model.mat` | **YOU CREATE THIS** (not in repo) |

---

## 🐛 Troubleshooting

<details>
<summary><b>❌ "AlexNet not found"</b></summary>

AlexNet is a separate install:
```matlab
alexnet  % Auto-install
% OR: Home → Add-Ons → Search "AlexNet" → Install
```
</details>

<details>
<summary><b>❌ "Toolbox not installed"</b></summary>

```matlab
checkRequirements  % See what's missing
```
Install from: Home → Add-Ons → Get Add-Ons
</details>

<details>
<summary><b>❌ "Out of memory"</b></summary>

Reduce batch size in `trainGenderClassifier.m`:
```matlab
'MiniBatchSize', 16  % Change from 32 to 16
```
</details>

<details>
<summary><b>❌ "Dataset folder not found"</b></summary>

Create `dataset/male/` and `dataset/female/` folders with face images.
</details>

<details>
<summary><b>⚡ GPU not detected</b></summary>

```matlab
gpuDevice  % Check if GPU seen
```
Install CUDA Toolkit + cuDNN. Or train on CPU (still works, just slower).
</details>

---

## 📊 Performance Metrics Explained

| Metric | What It Means | Target |
|--------|---------------|--------|
| **Accuracy** | % correctly classified | >95% |
| **Precision** | Of predicted males, % actually male | >90% |
| **Recall** | Of actual males, % correctly identified | >90% |
| **F1-Score** | Balance of precision & recall | >0.90 |
| **AUC** | Area under ROC curve | >0.95 |
| **Confusion Matrix** | True/False Positive/Negative counts | Diagonal high |

---

## 🎯 Tips for Best Results

1. **Balanced Dataset:** Equal male/female images (500+ each)
2. **Quality Images:** Clear, frontal faces with good lighting
3. **Consistent Size:** All images >227×227px
4. **No Duplicates:** Avoid identical/very similar images in train & test
5. **Diverse Dataset:** Various ages, ethnicities, expressions
6. **GPU Training:** 5-10x faster if available

---

## 📄 License

MIT License - Free to use, modify, and distribute.

---

## 🤝 Contributing

Issues and pull requests welcome! This project demonstrates:
- ✅ MATLAB Deep Learning Toolbox
- ✅ Transfer learning with pre-trained CNNs
- ✅ GUI development in MATLAB
- ✅ Computer vision preprocessing
- ✅ Model evaluation & visualization

---

## 🎓 Citation

```bibtex
@software{ai_gender_classification_matlab,
  title={AI-Based Gender Classification using AlexNet Transfer Learning},
  author={Khushi Kushwaha},
  year={2026},
  language={MATLAB},
  note={Deep Learning Toolbox implementation}
}
```

---

<div align="center">

### ⭐ Star this repo if it helped you!

**Built with ❤️ using MATLAB Deep Learning Toolbox**

[Report Bug](../../issues) · [Request Feature](../../issues) · [Documentation](../../wiki)

</div>
