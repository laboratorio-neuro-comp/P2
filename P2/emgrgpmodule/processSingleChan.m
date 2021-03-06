function [handles] = processSingleChan(handles)
% Runs the automatic processing steps of a single channel signal.

% TODO Remove handles dependency on this step

% Open eeglab:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Reading data file
ints_table = ler_arq_ints(get(handles.editTable, 'String'));

listset = { };
handles.listset = listset;

% Creating a CSV file to save the parameters
if get(handles.radioEMG, 'Value')
    emgParamFile = strcat(get(handles.editOutput, 'String'), filesep, 'EMG_Parameters_', date, '.csv');
    fileID = fopen(emgParamFile, 'w');
    fprintf(fileID, '%s;%s;%s;%s;%s;%s;%s;%s\n', ...
                    'Subject', ...
                    'Condition', ...
                    'Mean', ...
                    'Std Deviation', ...
                    'Variance', ...
                    'RMS', ...
                    'Normalized RMS', ...
                    'Power');
elseif get(handles.radioEDA, 'Value')
    edaParamFile = strcat(get(handles.editOutput, 'String'), filesep, 'EDA_Parameters_', date, '.csv');
    fileID = fopen(edaParamFile, 'w');
    fprintf(fileID, '%s;%s;%s;%s;%s;%s;%s\n', ...
                    'Subject', ...
                    'Condition', ...
                    'Mean', ...
                    'Std Deviation', ...
                    'Variance', ...
                    'SCL', ...
                    'SCR');
end

for n = 1:size(ints_table)
    % Prapring some parameters
    int1 = ints_table{n, 7};
    int2 = ints_table{n, 8};
    samplingRate = ints_table{n, 9};
    blockrange = floor([int1/samplingRate int2/samplingRate]);

    % Loading data
    if get(handles.radioASCII, 'Value')
        arqascii = ints_table{n, 10};
        EEG = pop_importdata('data', arqascii,...
                             'dataformat', 'ascii',...
                             'srate', samplingRate);
    elseif get(handles.radioEDF, 'Value')
        arqedf = ints_table{n, 10};
        EEG = pop_biosig(arqedf, 'rmeventchan', 'off');
    end

    % Preparing sets' file
    if (get(handles.radioEDA, 'Value'))
        arqset = [ ints_table{n, 1} '-' ...
                   ints_table{n, 3} '-EDA-' ...
                   ints_table{n, 2} '.set' ];
    elseif (get(handles.radioEMG, 'Value'))
        arqset = [ ints_table{n, 1} '-' ...
                   ints_table{n, 3} '-EMG-' ...
                   ints_table{n, 2} '.set' ];
    end
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, n,...
                                         'setname', arqset,...
                                         'overwrite', 'on');

    % Selecting data to keep
    h = msgbox('Cutting dataset...');
    EEG = eeg_checkset(EEG);
    if get(handles.radioEDF, 'Value')
        if get(handles.radioEDA, 'Value')
            EEG = pop_select(EEG, 'time', blockrange, 'channel', {'EMG-RGP'});
        elseif get(handles.radioEMG, 'Value')
            EEG = pop_select(EEG, 'time', blockrange, 'channel', {'EMG-RGP'});
        end
    elseif get(handles.radioASCII, 'Value')
        EEG = pop_select(EEG, 'time', blockrange);
    end
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, n);
    try
        close(h);
    end

    % Storing data
    h = msgbox('Saving dataset...');
    [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, n);
    [arqsetpath, arqsetname, arqsetext] = fileparts(arqset);
    EEG = pop_saveset(EEG, 'filename', strcat(arqsetname, arqsetext), ...
                           'filepath', get(handles.editOutput, 'String'));
    try
        close(h);
    end

    h = msgbox('Exporting dataset...');
    exportASCII = strcat(get(handles.editOutput, 'String'), filesep, arqsetname, '.ascii');
    EEG = pop_export(EEG, exportASCII, 'elec', 'off');
    try
        close(h);
    end

    % BUG Is the output data being saved?
    % Calculating and saving the parameters
    h = msgbox('Calculating parameters...');
    if get(handles.radioEMG, 'Value')
        emgASCII = load(exportASCII);
        % Because of the way EEGLab exports the file, one has to ask for the 2nd line
        emgASCII = emgASCII(2,:);
        [emgm, emgsd, emgvar, emgrms, emgrmsN, powtotal] = emgfunc(emgASCII);
        temp = fmap(@replace_dot, {emgm, emgsd, emgvar, emgrms, emgrmsN, powtotal});
        % temp{1, 2, 3, 4, 5, 6} = {emgm, emgsd, emgvar, emgrms, emgrmsN, powtotal}
        fprintf(fileID, '%s;%s;%s;%s;%s;%s;%s;%s\n', ...
                        ints_table{n, 1}, ...
                        ints_table{n, 2}, ...
                        temp{1}, ...
                        temp{2}, ...
                        temp{3}, ...
                        temp{4}, ...
                        temp{5}, ...
                        temp{6});
    elseif get(handles.radioEDA, 'Value')
        edaASCII = load(exportASCII);
        edaASCII = edaASCII(2,:);
        [rgpm, rgpsd, rgpvar, scl, scr] = rgpfunc(edaASCII);
        temp = fmap(@replace_dot, {rgpm, rgpsd, rgpvar, scl, scr});
        % temp{1, 2, 3, 4, 5} = {rgpm, rgpsd, rgpvar, scl, scr}
        fprintf(fileID, '%s;%s;%s;%s;%s;%s;%s\n', ...
                        ints_table{n, 1}, ...
                        ints_table{n, 2}, ...
                        temp{1}, ...
                        temp{2}, ...
                        temp{3}, ...
                        temp{4}, ...
                        temp{5});
    end
    try
        close(h);
    end

    % Adding file to the processed list
    listset{n} = arqset;
    set(handles.listFiles, 'String', listset);
end
fclose(fileID);

h = msgbox('DONE!')
