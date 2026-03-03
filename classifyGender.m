function [gender, score, faceImg, roiImg, processedImg] = classifyGender(testImage, trainedNet)
% Classify gender from test image using trained network
% Inputs:
%   testImage - Input image (RGB or grayscale)
%   trainedNet - Trained classification network
% Outputs:
%   gender - Predicted gender ('Male' or 'Female')
%   score - Prediction confidence score
%   faceImg - Image with detected face boundary
%   roiImg - Cropped face region
%   processedImg - Preprocessed face image

    %% Initialize outputs
    gender = '';
    score = 0;
    faceImg = [];
    roiImg = [];
    processedImg = [];
    
    %% Check if Computer Vision Toolbox is available
    if ~license('test', 'video_and_image_blockset') && ~license('test', 'vision')
        errordlg({'Computer Vision Toolbox is required but not installed!', '', ...
                 'Please install it from MATLAB Add-On Explorer:', ...
                 '1. Home → Add-Ons → Get Add-Ons', ...
                 '2. Search for "Computer Vision Toolbox"', ...
                 '3. Click Install'}, 'Toolbox Required', 'error');
        warning('Computer Vision Toolbox not found!');
        return;
    end
    
    try
        %% Convert to RGB if grayscale
        if size(testImage, 3) == 1
            testImage = cat(3, testImage, testImage, testImage);
        end
        
        %% Detect face using Viola-Jones algorithm with multiple attempts
        % Try different detection models for better accuracy
        detectors = {'FrontalFaceCART', 'FrontalFaceLBP'};
        bbox = [];
        
        % First pass: Standard detection
        for i = 1:length(detectors)
            try
                faceDetector = vision.CascadeObjectDetector(detectors{i}, ...
                    'ScaleFactor', 1.05, 'MergeThreshold', 4, 'MinSize', [30 30]);
                
                % Detect faces
                bbox = step(faceDetector, testImage);
                
                if ~isempty(bbox)
                    break;  % Face detected, stop trying
                end
            catch ME
                warning('Face detector failed: %s', ME.message);
                continue;
            end
        end
        
        % Second pass: More relaxed parameters
        if isempty(bbox)
            try
                faceDetector = vision.CascadeObjectDetector('FrontalFaceCART', ...
                    'ScaleFactor', 1.1, 'MergeThreshold', 2, 'MinSize', [20 20]);
                bbox = step(faceDetector, testImage);
            catch
                % Detection failed
            end
        end
        
        % Third pass: Try with enhanced contrast
        if isempty(bbox)
            try
                % Try with enhanced contrast using Image Processing Toolbox
                enhancedImg = imadjust(rgb2gray(testImage));
                enhancedImg = cat(3, enhancedImg, enhancedImg, enhancedImg);
                
                faceDetector = vision.CascadeObjectDetector('FrontalFaceCART', ...
                    'ScaleFactor', 1.2, 'MergeThreshold', 2, 'MinSize', [20 20]);
                bbox = step(faceDetector, enhancedImg);
            catch
                % Toolbox not available or detection failed
            end
        end
        
        % Fallback: use center region if no face detected
        if isempty(bbox)
            warning('No face detected! Using center region as fallback.');
            [h, w, ~] = size(testImage);
            faceW = round(w * 0.6);
            faceH = round(h * 0.7);
            startX = round((w - faceW) / 2);
            startY = round((h - faceH) / 2.5);  % Shift up slightly for better face centering
            bbox = [max(1,startX), max(1,startY), faceW, faceH];
        end
        
        % Use the first detected face (largest)
        if size(bbox, 1) > 1
            % Select largest face
            areas = bbox(:,3) .* bbox(:,4);
            [~, idx] = max(areas);
            bbox = bbox(idx, :);
        end
        
        %% Draw bounding box on face
        try
            faceImg = insertShape(testImage, 'Rectangle', bbox, 'LineWidth', 3, 'Color', 'blue');
        catch
            % Vision toolbox not available - draw manually
            faceImg = drawRectangleManual(testImage, bbox);
        end
        
        %% Extract ROI (Region of Interest)
        roiImg = imcrop(testImage, bbox);
        
        %% Preprocess the face image
        % Resize to AlexNet input size
        inputSize = [227 227];
        processedImg = imresize(roiImg, inputSize);
        
        % Ensure RGB format (match training preprocessing)
        if size(processedImg, 3) == 1
            % Convert grayscale to RGB
            processedImg = cat(3, processedImg, processedImg, processedImg);
        end
        
        %% Classify gender
        [label, scores] = classify(trainedNet, processedImg);
        
        gender = char(label);
        score = max(scores);
        confidence = score * 100;
        
        % Debug output - show scores for both classes
        fprintf('Classification Scores:\n');
        fprintf('  Female: %.2f%%\n', scores(1) * 100);
        fprintf('  Male: %.2f%%\n', scores(2) * 100);
        fprintf('Predicted: %s (%.2f%% confidence)\n\n', gender, confidence);
        
        % Make sure gender starts with capital letter
        if strcmpi(gender, 'male')
            gender = 'Male';
        elseif strcmpi(gender, 'female')
            gender = 'Female';
        end
        
    catch ME
        warning('Classification failed: %s', ME.message);
        disp(ME.message);
    end
end

function imgWithRect = drawRectangleManual(img, bbox)
    % Manual rectangle drawing fallback
    imgWithRect = img;
    x = max(1, round(bbox(1)));
    y = max(1, round(bbox(2)));
    w = round(bbox(3));
    h = round(bbox(4));
    
    % Ensure within bounds
    x = min(x, size(img,2));
    y = min(y, size(img,1));
    w = min(w, size(img,2) - x + 1);
    h = min(h, size(img,1) - y + 1);
    
    lineWidth = 3;
    blue = cat(3, uint8(0), uint8(0), uint8(255));
    
    % Draw blue rectangle
    for i = 1:lineWidth
        % Top line
        if y+i-1 <= size(img,1)
            imgWithRect(y+i-1, x:min(x+w-1,size(img,2)), :) = repmat(blue, 1, min(x+w-1,size(img,2))-x+1);
        end
        % Bottom line
        if y+h-i+1 >= 1 && y+h-i+1 <= size(img,1)
            imgWithRect(y+h-i+1, x:min(x+w-1,size(img,2)), :) = repmat(blue, 1, min(x+w-1,size(img,2))-x+1);
        end
        % Left line
        if x+i-1 <= size(img,2)
            imgWithRect(y:min(y+h-1,size(img,1)), x+i-1, :) = repmat(blue, min(y+h-1,size(img,1))-y+1, 1);
        end
        % Right line
        if x+w-i+1 >= 1 && x+w-i+1 <= size(img,2)
            imgWithRect(y:min(y+h-1,size(img,1)), x+w-i+1, :) = repmat(blue, min(y+h-1,size(img,1))-y+1, 1);
        end
    end
end
