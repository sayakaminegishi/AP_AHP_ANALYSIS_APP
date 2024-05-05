function AP_AHP_Analysis_IClamp_APP
% This script makes an app with GUI for my AP_AHP_Iclamp analysis 
% Created by: Sayaka (Saya) Minegishi
% Contact: minegishis@brandeis.edu
% Last modified: May 4 2024

%todo: 
%add save as button with name of excel file for output

%% define general structure
fig = uifigure;
fig.Name = "AP_AHP_Analysis_IClamp_APP";

%define grids
g = uigridlayout(fig, [2,2]);
g.RowHeight = {22,22,'1x'};
g.ColumnWidth = {150,'1x'};

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


lbl_selectfile = uilabel(p);
lbl_selectfile.Text = "Select File:";
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

analyzeButton = uibutton(p, 'push');
analyzeButton.Text = 'Analyze';
analyzeButton.Position = [10, p.Position(4)-150, 60, 22]; % Adjust position and size of the button within the panel
analyzeButton.ButtonPushedFcn = @(btn,event) browseButtonCallback(fileEditField); %TODO: Change this


% Axes
ax = uiaxes(p);
ax.Position = [10, p.Position(4)-250, 180, 100]; % Adjust position and size of the axes below the label
title(ax, 'Trace Viewer');

%% analysis results (p2)
% label
lbl = uilabel(p2);
lbl.Text = "Analysis Results";
lbl.FontSize = 15;
lbl.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl.Position = [10, p2.Position(4)-30, 180, 22]; % Adjust position to be at the top middle of p2

table_handle = uitable('Position', [220, p.Position(4)-250, 180, 100] );
table_as_cell = num2cell(ResultMatrix); %TODO: fill in with resulting table
set(table_handle, 'Data', table_as_cell);

% label with creator info
lbl_creator = uilabel(p);
lbl_creator.Text = "Created by Sayaka (Saya) Minegishi | minegishis@brandeis.edu";
lbl_creator.FontSize = 11;
lbl_creator.HorizontalAlignment = 'center'; % Align text to the center horizontally
lbl_creator.VerticalAlignment = 'bottom'; % Align text to the bottom vertically
lbl_creator.Position = [10, 10, 180, 22]; % Adjust position to be at the bottom of p
lbl_creator.WordWrap = 'on';
end