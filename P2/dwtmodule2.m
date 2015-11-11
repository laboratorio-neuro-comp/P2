function varargout = dwtmodule2(varargin)
% DWTMODULE2 M-file for dwtmodule2.fig
%      DWTMODULE2, by itself, creates a new DWTMODULE2 or raises the existing
%      singleton*.
%
%      H = DWTMODULE2 returns the handle to a new DWTMODULE2 or the handle to
%      the existing singleton*.
%
%      DWTMODULE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DWTMODULE2.M with the given input arguments.
%
%      DWTMODULE2('Property','Value',...) creates a new DWTMODULE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dwtmodule2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dwtmodule2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dwtmodule2

% Last Modified by GUIDE v2.5 10-Nov-2015 09:25:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dwtmodule2_OpeningFcn, ...
                   'gui_OutputFcn',  @dwtmodule2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before dwtmodule2 is made visible.
function dwtmodule2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dwtmodule2 (see VARARGIN)

% Choose default command line output for dwtmodule2
handles.output = hObject;
handles.signals = {};
handles.signalnames = {};
handles.wavelets = [];

% Update handles structure
guidata(hObject, handles);

% ---------------------------------------------------------------------
function [step] = get_step(signal)
global fs
step = 0:1/fs:(length(signal) - 1)/fs;

function context_plot(signal)
plot(get_step(signal), signal);

% --- Outputs from this function are returned to the command line.
function varargout = dwtmodule2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function AddMenuItem_Callback(hObject, eventdata, handles)
global fa fb fc fs
[signalname, signalpath] = uigetfile('*.ascii', 'Choose the data file');

if ~isequal(signalname, 0)
	signal = (load(strcat(signalpath, signalname)) + fa)*fb - fc;
	signalname = signalname(1:length(signalname)-6);

	handles.signalnames{length(handles.signalnames)+1} = signalname;
	handles.signals{length(handles.signals)+1} = signal;
	set(handles.textSignalName, 'String', signalname);
	if isequal(length(handles.signals), 1)
		context_plot(signal);
	end
end

guidata(hObject, handles);

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close DWT module?'],...
                     ['Close DWT module...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
	               get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PopupWaveletKind.
function PopupWaveletKind_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns PopupWaveletKind contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopupWaveletKind

% ## Available wavelets ##
% + Haar
% + Daubechies
%   - db1, db2, db3, ..., db10
% + Symlets
%   - 2, 3, ..., 8
% + Coiflets
%   - 1, 2, ..., 5
% + Biorthogonal
%   - 1.1, 1.3, 1.5, 2.2, 2.4, 2.6, 2.8, 3.1, 3.3, 3.5, 3.7, 3.9, 4.4, 5.5, 6.8
% + R_Biorthigonal
%   - 1.1, 1.3, 1.5, 2.2, 2.4, 2.6, 2.8, 3.1, 3.3, 3.5, 3.7, 3.9, 4.4, 5.5, 6.8

contents = cellstr(get(hObject, 'String'));
wavelet = contents{get(hObject, 'Value')};

switch wavelet
case 'Haar'
	set(handles.PopupWaveletVar, 'String', {'Std'});
case 'Daubechies'
	set(handles.PopupWaveletVar, 'String', ...
	   {'db1' 'db2' 'db3' 'db4' 'db5' 'db6' 'db7' 'db8' 'db9' 'db10'});
case 'Symlets'
	set(handles.PopupWaveletVar, 'String', ...
	   {'2' '3' '4' '5' '6' '7' '8'});
case 'Coiflets'
	set(handles.PopupWaveletVar, 'String', ...
	   {'1' '2' '3' '4' '5'});
case 'Biorthogonal'
	set(handles.PopupWaveletVar, 'String', ...
	   {'1.1' '1.3' '1.5' '2.2' '2.4' '2.6' '2.8' ...
		'3.1' '3.3' '3.5' '3.7' '3.9' '4.4' '5.5' '6.8'});
case 'R Biorthogonal'
	set(handles.PopupWaveletVar, 'String', ...
	   {'1.1' '1.3' '1.5' '2.2' '2.4' '2.6' '2.8' ...
		'3.1' '3.3' '3.5' '3.7' '3.9' '4.4' '5.5' '6.8'});
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PopupWaveletKind_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
	               get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PopupWaveletVar.
function PopupWaveletVar_Callback(hObject, eventdata, handles)
% hObject    handle to PopupWaveletVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PopupWaveletVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopupWaveletVar


% --- Executes during object creation, after setting all properties.
function PopupWaveletVar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
	               get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PopupWaveletLevel.
function PopupWaveletLevel_Callback(hObject, eventdata, handles)
% hObject    handle to PopupWaveletLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PopupWaveletLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopupWaveletLevel


% --- Executes during object creation, after setting all properties.
function PopupWaveletLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
	               get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ---------------------------------------------------------------------
function [wavecode] = get_choosen_wavelet(family, kind)
% Wavelet Families | Wavelets
%
% Daubechies: 'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% Coiflets: 'coif1', ... , 'coif5'
% Symlets: 'sym2', ... , 'sym8', ... ,'sym45'
% Fejer-Korovkin filters: 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% Discrete Meyer: 'dmey'
% Biorthogonal: 'bior1.1', 'bior1.3', 'bior1.5'
% 				'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 				'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 				'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% Reverse Biorthogonal: 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 						'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 						'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 						'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'

wavecode = 'haar';

switch family
case 'Daubechies'
	wavecode = 'db' + kind;
case 'Coiflets'
	wavecode = 'coif' + kind;
case 'Biorthogonal'
	wavecode = 'bior' + kind;
case 'R Biorthogonal'
	wavecode = 'rbio' + kind;
end

function ButtonCalculate_Callback(hObject, eventdata, handles)
contents = get(handles.PopupWaveletKind, 'string');
signal = handles.signals{1};
level = get(handles.PopupWaveletLevel, 'Value');
wavelet_family = get(handles.PopupWaveletKind, 'Value');
wavelet_kind = get(handles.PopupWaveletVar, 'Value');
wavelet = get_choosen_wavelet(wavelet_family, wavelet_kind);
[decomposition bookkeeping] = wavedec(signal, level, wavelet);
plot(decomposition);

% --------------------------------------------------------------------
function VisualizeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to VisualizeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
