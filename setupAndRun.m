%% AI-based Gender Detection System - MATLAB Implementation
% Complete setup and quick start script
% Run this script first to set up and launch the project

%% Clear workspace
clear all;
close all;
clc;

fprintf('╔════════════════════════════════════════════════════════════╗\n');
fprintf('║   AI-based Gender Identification using Facial Features   ║\n');
fprintf('║              MATLAB Implementation v1.0                   ║\n');
fprintf('╚════════════════════════════════════════════════════════════╝\n\n');

%% Step 1: Check Requirements
fprintf('Step 1: Checking MATLAB requirements...\n');
fprintf('─────────────────────────────────────────\n');
checkRequirements();
fprintf('\n');

%% Step 2: Prepare Dataset
fprintf('Step 2: Preparing dataset...\n');
fprintf('─────────────────────────────────────────\n');
prepareDataset();
fprintf('\n');

%% Step 3: Launch GUI
fprintf('Step 3: Launching GUI...\n');
fprintf('─────────────────────────────────────────\n');
fprintf('Opening Gender Detection GUI...\n\n');

% Add current folder to path
addpath(pwd);

% Launch the GUI
GenderDetectionGUI();

fprintf('\n╔════════════════════════════════════════════════════════════╗\n');
fprintf('║                   Quick Usage Guide                       ║\n');
fprintf('╠════════════════════════════════════════════════════════════╣\n');
fprintf('║  1. TRAINING:                                             ║\n');
fprintf('║     • Click "Training Process" to train new model         ║\n');
fprintf('║     • OR click "Load Network" to load existing model      ║\n');
fprintf('║                                                            ║\n');
fprintf('║  2. TESTING:                                              ║\n');
fprintf('║     • Click "Browse Test Image" to select an image        ║\n');
fprintf('║     • Click "Testing Process" to classify gender          ║\n');
fprintf('║                                                            ║\n');
fprintf('║  3. PERFORMANCE:                                          ║\n');
fprintf('║     • Click "Performance Analysis" to evaluate model      ║\n');
fprintf('╚════════════════════════════════════════════════════════════╝\n\n');
