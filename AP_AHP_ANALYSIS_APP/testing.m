% [filename,pathname] = uigetfile('*.abf',...
%         'Select One or More Files', ...
%         'MultiSelect', 'on') %prompt user to select multiple files
%   sourceFile = fullfile(pathname, filename)


fig = uifigure;
tg = uitabgroup(fig,"SelectionChangedFcn",@displaySelection);
t1 = uitab(tg,"Title","Data");
t2 = uitab(tg,"Title","Plots");

function displaySelection(src,event)
    t = event.NewValue;
    title = t.Title;
    disp("Viewing the " + title + " tab")
end