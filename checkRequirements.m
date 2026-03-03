function checkRequirements()
% Check if required MATLAB toolboxes are installed
% This function verifies all dependencies before running the project

    fprintf('=== Checking MATLAB Requirements ===\n\n');
    
    required = {
        'Deep Learning Toolbox', 'nnet'
        'Computer Vision Toolbox', 'vision'
        'Image Processing Toolbox', 'images'
        'Statistics and Machine Learning Toolbox', 'stats'
    };
    
    allInstalled = true;
    
    for i = 1:size(required, 1)
        toolboxName = required{i, 1};
        toolboxCode = required{i, 2};
        
        % Special check for Computer Vision Toolbox (can be either code)
        if strcmp(toolboxCode, 'vision')
            installed = license('test', 'vision') || license('test', 'video_and_image_blockset');
        else
            installed = license('test', toolboxCode);
        end
        
        if installed
            fprintf('✓ %s - INSTALLED\n', toolboxName);
        else
            fprintf('✗ %s - NOT FOUND\n', toolboxName);
            fprintf('  → Install from: Home → Add-Ons → Get Add-Ons\n');
            allInstalled = false;
        end
    end
    
    fprintf('\n');
    
    if allInstalled
        fprintf('=== All required toolboxes are installed! ===\n');
        fprintf('\nChecking AlexNet availability...\n');
        
        try
            net = alexnet;
            fprintf('✓ AlexNet is available and loaded successfully!\n');
        catch
            fprintf('✗ AlexNet not found!\n\n');
            fprintf('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
            fprintf('  INSTALLATION REQUIRED:\n');
            fprintf('  Deep Learning Toolbox Model for AlexNet Network\n');
            fprintf('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n');
            fprintf('To install AlexNet:\n');
            fprintf('  1. Click: Home → Add-Ons → Get Add-Ons\n');
            fprintf('  2. Search: "AlexNet"\n');
            fprintf('  3. Find: "Deep Learning Toolbox Model for AlexNet Network"\n');
            fprintf('  4. Click: Install\n\n');
            fprintf('Or run this command:\n');
            fprintf('  >> alexnet\n');
            fprintf('  (This will prompt automatic installation)\n\n');
            
            % Try to open Add-On Explorer
            fprintf('Opening Add-On Explorer...\n');
            try
                matlab.addons.supportpackage.internal.explorer.showSupportPackages('deeplearning', 'alexnet');
            catch
                fprintf('Please manually open Add-On Explorer.\n');
            end
            
            allInstalled = false;
        end
        
        if allInstalled
            fprintf('\n=== System Ready! ===\n');
            fprintf('You can now run: GenderDetectionGUI\n');
        end
    else
        fprintf('=== Missing Required Components! ===\n');
        fprintf('Please install the missing toolboxes/models from MATLAB Add-On Explorer.\n');
    end
end
