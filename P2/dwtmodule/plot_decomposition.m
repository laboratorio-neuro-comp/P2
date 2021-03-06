function [handles] = plot_decomposition(handles)
% plot many DWT transformed signals

% # get correct decompositions
decomposition = handles.approximations;
if isequal(get_yielding(handles), 'Details')
    decomposition = handles.details;
end

% # hide all plots
for index = 1:length(handles.plots)
    set(handles.plots(index), 'Visible', 'off');
end

% # set parameters
fs = str2num(handles.constants.get('fs'));
phi = (1 + sqrt(5)) / 2;
moo = 0.1;
panelplot_dimensions = get(handles.PanelPlot, 'Position');
width = panelplot_dimensions(3);
height = panelplot_dimensions(4);
no_squares = 1 + length(decomposition);
g = 0;
h = (height * ((1-moo) ^ 2)) / no_squares;
w = phi * width * (1-moo);
x = moo;

if no_squares > 1
    g = (height * moo * (1-moo)) / (no_squares-1);
end

% # resize and draw plots
% first plot
axes(handles.plots(1));
set(handles.plots(1), 'Position', [x, ... % x coordinate
                                   height - (h+g), ... % y coordinate
                                   w, ... % width
                                   h]); % height
standard_plot(handles.signal, fs);
% next plots
what = 2;
while what <= no_squares
    p = handles.plots(what);
    set(p, 'Visible', 'on');
    set(p, 'Position', [x, ... % x
                        height - what*(h+g), ... % y
                        w, ... % width
                        h]); % height
    axes(p);
    standard_plot(decomposition{what-1}, fs);
    what = what + 1;
end
