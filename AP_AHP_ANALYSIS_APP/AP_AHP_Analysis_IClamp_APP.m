function AP_AHP_Analysis_IClamp_APP

% This script is the GUI version my AP_AHP_Iclamp analysis program - for
%  burst batch detection. Takes in one or more spontaneous current clamp files, does
%  batch-analysis and gives their burst and properties of AP that occur as
%  singlets (i.e. not part of a burst). Summary data is also exported in an
%  excel file.

% NOTE: MAKE SURE TO DELETE ALL FILES FROM 'tempdata' FOLDER AFTER EACH
%USE!!!!!!
% EXCEL SUMMARY FILE IS SAVED IN 'summaryTable_Iclamp.xlsx', IN THE SAME DIRECTORY AS THIS SCRIPT!!! 

% Don't touch the analysis mode. Also the trace viewer is still under
% construction, so please refer to the popup figures for the graphs.


%note to self:
%make it able to switch between analysis modes


% Created by: Sayaka (Saya) Minegishi
% Contact: minegishis@brandeis.edu
% Last modified: May 5 2024

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clf
close all


currentFolder = pwd;
addpath('analysis_scripts_iclamp/')  
savepath
mkdir tempdata %make a new folder to store the data files selected
    
%% define general structure
fig = uifigure;
fig.Name = "AP_AHP_Analysis_IClamp_APP";

%define grids
g = uigridlayout(fig, [2,2]);
g.RowHeight = {22,22,'1x'};
g.ColumnWidth = {150,'1x'}; %

%add panel
p = uipanel(fig);
p.Title = 'Input Information';
%add second panel
p2 = uipanel(fig);
p2.Title = 'Analyzed Output'; %title of graph
panelHeight = 400; % Adjust as needed

% Set the positions of the panels
p.Position = [10, 10, 200, panelHeight];
p2.Position = [210, 10, 200, panelHeight];

%% add components

% Range drop-down for selecting analysis mode
dd2 = uidropdown(p);
dd2.Items = {'Select analysis mode', 'Single File Evoked', 'Batch Analysis Evoked','Single File Spontaneous', 'Batch Analysis Spontaneous'};
dd2.Position = [10, p.Position(4)-50, 160, 22]; % Adjust position and size of the dropdown within the panel

%select file
lbl_selectfile = uilabel(p);
lbl_selectfile.Text = "Select Files:";
lbl_selectfile.FontSize = 12;
lbl_selectfile.Position = [10, p.Position(4)-100, 160, 22]; % Adjust position and size of the dropdown within the panel

% text box for selecting file
fileEditField = uieditfield(p, 'text');
fileEditField.Position = [10, p.Position(4)-120, 150, 22]; % Adjust position and size of the edit field within the panel
fileEditField.Editable = 'off'; % Prevent manual editing of the field

browseButton = uibutton(p, 'push');
browseButton.Text = 'Browse';
browseButton.Position = [170, p.Position(4)-120, 60, 22]; % Adjust position and size of the button within the panel
browseButton.ButtonPushedFcn = @(btn,event) browseButtonCallback(fileEditField);


% Axes
ax = uiaxes(p);
ax.Position = [10, p.Position(4)-250, 180, 100]; % Adjust position and size of the axes below the label
title(ax, 'Trace Viewer'); %TODO: specify file name. make it be different for each trace

% lbl_inst = uilabel(p);
% lbl_inst.Position = [10, p.Position(4)-250, 180, 100];
% lbl_inst.Text = 'GUI ver. of my ap_ahp analysis program. Takes in one or more spontaneous current clamp files, does batch-analysis and gives their burst and properties of AP that occur as singlets (i.e. not part of a burst). Summary data is also exported in an excel file.';
% lbl_inst.WordWrap = 'on';
%% analysis results (p2)
% label
lbl = uilabel(p2);
lbl.Text = "Analysis Results";
lbl.FontSize = 15;
lbl.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl.Position = [10, p2.Position(4)-30, 180, 22]; % Adjust position to be at the top middle of p2

%display table for burst analysis
uit = uitable(p2, "Position",[10, p2.Position(4)-180, 180, 100]);
uit.FontSize = 10;
lbl_uit = uilabel(p2);
lbl_uit.Text = "Burst properties in each cell";
lbl_uit.FontSize = 13;
lbl_uit.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl_uit.Position = [10, p2.Position(4)-80, 180, 22]; % Adjust position to be at the top middle of p2


%display table for singlet analysis
uit2 = uitable(p2, "Position", [10, p2.Position(4)-300, 180, 100]);
uit2.FontSize = 10;
lbl_uit2 = uilabel(p2);
lbl_uit2.Text = "Singlet AP properties in each cell";
lbl_uit2.FontSize = 13;
lbl_uit2.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl_uit2.Position = [10, p2.Position(4)-200, 180, 22]; % Adjust position to be at the top middle of p2

%files not working

uit3 = uitable(p2, "Position", [10, p2.Position(4)-340, 180, 20]);
uit3.FontSize = 10;

lbl_fnw = uilabel(p2);
lbl_fnw.Text = "Files not working: ";
lbl_fnw.FontSize = 12;
lbl_fnw.Position = [10, p2.Position(4)-320, 180, 22]; % Adjust position to be at the top middle of p2


lbl_countworked = uilabel(p2);
lbl_countworked.Visible = 'off'; %make it invisible
lbl_countworked.FontSize = 12;
lbl_countworked.Position = [10, p2.Position(4)-380, 180, 22];

%to analyze
analyzeButton = uibutton(p, 'push');
analyzeButton.Text = 'Analyze';
analyzeButton.Position = [10, p.Position(4)-150, 60, 22]; % Adjust position and size of the button within the panel
analyzeButton.ButtonPushedFcn = @(btn,event) analyzeButtonCallback(ax, uit, uit2, uit3, lbl_countworked, currentFolder); %TODO: Change this



% label with creator info
lbl_creator = uilabel(p);
lbl_creator.Text = "Created by Sayaka (Saya) Minegishi | minegishis@brandeis.edu | May 2024";
lbl_creator.FontSize = 11;
lbl_creator.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl_creator.VerticalAlignment = 'bottom'; % Align text to the bottom vertically
lbl_creator.Position = [10, 10, 180, 22]; % Adjust position to be at the bottom of p
lbl_creator.WordWrap = 'on';


end


% Callback function for Browse button
    function browseButtonCallback(fileEditField)
    [filename,pathname] = uigetfile('*.abf',...
        'Select One or More Files', ...
        'MultiSelect', 'on'); %prompt user to select multiple files
  
    %move selected data to folder temporarily
    currentFolder = pwd; %path to current folder
        pdest   = fullfile(currentFolder, filesep, 'tempdata');

    if isequal(filename,0) || isequal(pathname,0)
        disp('User pressed cancel');
    else
        if isa(filename, "char")  %if only one file
              str = string(filename);
              sourceFile = fullfile(pathname, filename);
                destFile   = fullfile(pdest, filename);  
                copyfile(sourceFile, destFile);

        else %if multiple files selected
            str = sprintf('%s; ', filename{:}); % Convert string vector to a single string with newline characters
 
            for k = 1:numel(filename)
                sourceFile = fullfile(pathname, filename{k});
                destFile   = fullfile(pdest, filename{k});  
                movefile(sourceFile, destFile);
       
            end
        end
        fileEditField.Value = str; %add file names to the text box
        
    end
    end

    % Callback function for Analyze button
    function analyzeButtonCallback(ax, uit, uit2, uit3, lbl_countworked, currentFolder)
   
    %tempdir = fullfile(currentFolder,filesep,'tempdata', filesep); %folder to load data
   
    tempDir = fullfile(currentFolder, 'tempdata', filesep); % Folder to load data

    % Start loading files
    filesNotWorking = []; % List of files with errors
    list = dir(fullfile(tempDir, '*.abf'));
    file_names = {list.name}; % List of all abf file names in the directory

    for i = 1:numel(file_names)
        file_names{i} = fullfile(tempDir, file_names{i});
    end

    

    filenameExcelDoc = fullfile(currentFolder, filesep, 'summaryTable_Iclamp.xlsx'); %default file name

    %table for summarizing burst properties
    myVarnamesBursts = {'cell name', 'threshold(mV)', 'average_ISI(ms)', 'AP_frequency(Hz)', 'total_AP_count_in_cell', 'count_of_bursts', 'count_of_singletAPs', 'average_burst_duration(ms)', 'freq_bursts(Hz)'};

    burstsTable= zeros(0,numel(myVarnamesBursts));
    burstsTableRow = zeros(0, numel(myVarnamesBursts));
    burstT= array2table(burstsTable, 'VariableNames', myVarnamesBursts); %stores info from all the sweeps in an abf file


    %table for summarizing average of singlet AP properties from each cell
    myVarnamesSing= {'threshold(mV)', 'duration(ms)', 'amplitude(mV)', 'AHP_amplitude(mV)', 'trough value (mV)', 'peak value(mV)',  'half_width(ms)', 'AHP_30_val(mV)', 'AHP_50_val(mV)', 'AHP_70_val(mV)', 'AHP_90_val(mV)', 'half_width_AHP(ms)', 'AHP_width_10to10%(ms)', 'AHP_width_30to30%(ms)', 'AHP_width_70to70%(ms)', 'AHP_width_90to90%(ms)'};

    %MAKE A TABLE WITH EMPTY VALUES BUT WITH HEADERS
    % Define headers
    headersSingT = {'spike_location(ms)', 'threshold(mV)', 'amplitude(mV)', 'AHP_amplitude(mV)', 'trough value (mV)', 'trough location(ms)', 'peak value(mV)', 'peak location(ms)', 'half_width(ms)', 'AHP_30_val(mV)', 'AHP_50_val(mV)', 'AHP_70_val(mV)', 'AHP_90_val(mV)', 'half_width_AHP(ms)', 'AHP_width_10to10%(ms)', 'AHP_width_30to30%(ms)', 'AHP_width_70to70%(ms)', 'AHP_width_90to90%(ms)', 'AHP_width_90to30%(ms)', 'AHP_width_10to90%(ms)'};
    variableTypes = {'double', 'double', 'double', 'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double',  'double' , 'double' , 'double' }; % Adjust the data types as needed

    % Create an empty table with headers
    singT = table('Size', [0, numel(headersSingT)], 'VariableNames', headersSingT, 'VariableTypes', variableTypes);
    singT(:,[1,7]) = []; %delete irrelevant columns for averaged data
    filesNotWorking = [];

    for n=1:size(file_names,2)
 
        filename = string(file_names{n});
        disp([int2str(n) '. Working on: ' filename])
        try
            [singletAnalysisRow, T] = CMA_burst_analysis_feb17(filename); %get burst and singlet analysis for thsi cell
            burstT = [burstT; T];
            singT = [singT; singletAnalysisRow];

        catch
            fprintf('Invalid data in iteration %s, skipped.\n', filename);
            filesNotWorking = [filesNotWorking;filename];
        end

    end

    %add cell name column to singT
    newcolumn = burstT(:,1); %first column of burstT
    singT = [newcolumn, singT];

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %update visual outputs
    %TODO: MODIFY THIS SO OUTPUTS WILL BE DISPLAYED
    %plot(ax, fig_marked)
    
    %OUTPUT TABLES
    uit.Data = burstT;
    uit2.Data = singT;
    uit3.Data = filesNotWorking;

    filesthatworkedcount = size(file_names,2) - size(filesNotWorking, 1);
    lbl_countworked.Text = string(filesthatworkedcount + " out of " + size(file_names,2) + " traces analyzed successfully.");
    lbl_countworked.Visible = 'on'; %make it visible

    writetable(burstT, filenameExcelDoc, 'Sheet', 1); %export summary table for bursts to excel
    writetable(singT, filenameExcelDoc, 'Sheet', 2); %export summary table for singlets to excel


    end



