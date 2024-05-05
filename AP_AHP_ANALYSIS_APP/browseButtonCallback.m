function browseButtonCallback(fileEditField)
    [filename, pathname] = uigetfile('*.abf*', 'Select a file');
    if isequal(filename,0) || isequal(pathname,0)
        disp('User pressed cancel');
    else
        filePath = fullfile(pathname, filename);
        fileEditField.Value = filePath;
    end
end
