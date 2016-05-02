function varargout = recordmodule(varargin)
% RECORDMODULE M-file for recordmodule.fig
%      RECORDMODULE, by itself, creates a new RECORDMODULE or raises the existing
%      singleton*.
%
%      H = RECORDMODULE returns the handle to a new RECORDMODULE or the handle to
%      the existing singleton*.
%
%      RECORDMODULE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECORDMODULE.M with the given input arguments.
%
%      RECORDMODULE('Property','Value',...) creates a new RECORDMODULE or
%      raises the existing singleton*.  Starting from the left, property
%      value pairs are applied to the GUI before recordmodule_OpeningFunction
%      gets called.  An unrecognized property name or invalid value makes
%      property application stop.  All inputs are passed to
%      recordmodule_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help recordmodule

% Last Modified by GUIDE v2.5 02-May-2016 11:49:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recordmodule_OpeningFcn, ...
                   'gui_OutputFcn',  @recordmodule_OutputFcn, ...
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


% --- Executes just before recordmodule is made visible.
function recordmodule_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recordmodule (see VARARGIN)

% Choose default command line output for recordmodule
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Import needed folders
addpath(strcat(cd, '/util'));
addpath(strcat(cd, '/recordmodule'));

% UIWAIT makes recordmodule wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recordmodule_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupMode.
function popupMode_Callback(hObject, eventdata, handles)
% hObject    handle to popupMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: - `contents = get(hObject, 'String')` returns popupMode 
%          contents as cell array
%        - `contents{get(hObject, 'Value')}` returns selected item 
%          from popupMode


% --- Executes during object creation, after setting all properties.
function popupMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
color = 'white';
if ~ispc
    color = get(0, 'defaultUicontrolBackgroundColor');
end
set(hObject, 'BackgroundColor', color);


% --- Executes on button press in buttonRun. -------------------------
function buttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.buttonRun, 'String', 'Running...');
stuff = split_string(get(handles.editInput, 'String'), ';');
for i = 1:length(stuff)
    ConvertEDF2ASCII(stuff{i}, get(handles.checkMultiple, 'Value'));
end
set(handles.buttonRun, 'String', 'Run');
msgbox('Done! :)');

% --------------------------------------------------------------------
function quitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to quitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close module?'], ...
                     ['Closing module...'], ...
                     'Yes', 'No', 'Yes');
if strcmp(selection, 'No')
    return;
end
delete(handles.figure1)

% --------------------------------------------------------------------
function settingsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to settingsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function editMenu_Callback(hObject, eventdata, handles)
% hObject    handle to editMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkMultiple. ---------------------
function checkMultiple_Callback(hObject, eventdata, handles)
% hObject    handle to checkMultiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkMultiple


% --------------------------------------------------------------------
function editInput_Callback(hObject, eventdata, handles)
% hObject    handle to editInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: - get(hObject,'String') returns contents of editInput as text
%        - str2double(get(hObject,'String')) returns contents of editInput 
%          as a double


% --- Executes during object creation, after setting all properties. -
function editInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject, ...
        'BackgroundColor', ...
        'white');
else
    set(hObject, ...
        'BackgroundColor', ...
        get(0, 'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in buttonSearch.
function buttonSearch_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('MultiSelect', 'on');

if iscell(filename)
    set(handles.editInput, ...
        'String', ...
        join_strings(append_on_each_one(filename, ...
                                        pathname), ... 
                     ';'));
else
    set(handles.editInput, ...
        'String', ...
        strcat(pathname, ...
               filename));
end
