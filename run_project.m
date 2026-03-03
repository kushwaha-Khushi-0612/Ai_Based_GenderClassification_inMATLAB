% Quick Start Script for Gender Detection System
% Double-click this file in MATLAB or type 'run_project' in command window

clear all;
close all;
clc;

% Display banner
disp('═══════════════════════════════════════════════════════════════');
disp('     AI-BASED GENDER IDENTIFICATION USING FACIAL FEATURES      ');
disp('                    MATLAB Implementation                       ');
disp('═══════════════════════════════════════════════════════════════');
disp(' ');

% Check if in correct directory
if ~exist('GenderDetectionGUI.m', 'file')
    error('Please navigate to the project folder first!');
end

% Check if test dataset exists, create if needed
if ~exist(fullfile(pwd, 'test', 'male'), 'dir') || isempty(dir(fullfile(pwd, 'test', 'male', '*.jpg')))
    fprintf('Test dataset not found. Creating test split...\n');
    createTestDatasetSplit();
    fprintf('\n');
end

% Launch the main setup
setupAndRun;
