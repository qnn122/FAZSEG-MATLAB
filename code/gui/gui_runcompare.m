function varargout = gui_runcompare(varargin)
% GUI_RUNCOMPARE MATLAB code for gui_runcompare.fig
%      GUI_RUNCOMPARE, by itself, creates a new GUI_RUNCOMPARE or raises the existing
%      singleton*.
%
%      H = GUI_RUNCOMPARE returns the handle to a new GUI_RUNCOMPARE or the handle to
%      the existing singleton*.
%
%      GUI_RUNCOMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RUNCOMPARE.M with the given input arguments.
%
%      GUI_RUNCOMPARE('Property','Value',...) creates a new GUI_RUNCOMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_runcompare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_runcompare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_runcompare

% Last Modified by GUIDE v2.5 12-Jul-2018 21:19:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_runcompare_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_runcompare_OutputFcn, ...
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


% --- Executes just before gui_runcompare is made visible.
function gui_runcompare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_runcompare (see VARARGIN)

% Choose default command line output for gui_runcompare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_runcompare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_runcompare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_refpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_refpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_refpath as text
%        str2double(get(hObject,'String')) returns contents of edit_refpath as a double


% --- Executes during object creation, after setting all properties.
function edit_refpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_refpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_refpath.
function push_refpath_Callback(hObject, eventdata, handles)
% hObject    handle to push_refpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get path
handles.refpath = uigetdir; %gets directory

% Update edit text
set(handles.edit_refpath, 'String', handles.refpath)

% Save data
guidata(hObject, handles)


function edit_tarpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tarpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tarpath as text
%        str2double(get(hObject,'String')) returns contents of edit_tarpath as a double


% --- Executes during object creation, after setting all properties.
function edit_tarpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tarpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_tarpath.
function push_tarpath_Callback(hObject, eventdata, handles)
% hObject    handle to push_tarpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get path
handles.tarpath = uigetdir; %gets directory

% Update edit text
set(handles.edit_tarpath, 'String', handles.tarpath)

% Save data
guidata(hObject, handles)

% --- Executes on button press in push_run.
function push_run_Callback(hObject, eventdata, handles)
% hObject    handle to push_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Ref = getDataFromPath(handles.refpath);
Tar = getDataFromPath(handles.tarpath);

% Compare
coef = similaritycompare(Ref, Tar, 'isprint', 1, 'isshow', 1);
data = coef{:,:};

% Display table
hfig = figure('Name', 'Comparison Result', ...
            'Units', 'normalized', 'Position',[0.45 0.2 0.35 0.65]);
uitable(hfig,'Data', data, 'ColumnWidth',{50}, ...
        'ColumnName', coef.Properties.VariableNames, ...
        'Units', 'normalized', 'Position',[0.05 0.05 0.9 0.9]);

% Sending result to workspace
assignin('base', 'Results', coef);

% Save data
handles.Ref = Ref;
handles.Tar = Tar;
handles.coef = coef;
guidata(hObject, handles)


function data = getDataFromPath(pathname)
files = dir(fullfile(pathname,'*png'));
N = length(files);

data = [];

% Loading
for k = 1:N
    % Get file name
    [pathstr,name,ext] = fileparts(files(k).name);
    fprintf('Loading %s\n', name);
    directory = fullfile(pathname,files(k).name);
    
    % Read and store image into data
    I = imread(directory);
    data = cat(3, data, I);
end



function edit_singlecompare_Callback(hObject, eventdata, handles)
% hObject    handle to edit_singlecompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_singlecompare as text
%        str2double(get(hObject,'String')) returns contents of edit_singlecompare as a double


% --- Executes during object creation, after setting all properties.
function edit_singlecompare_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_singlecompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_singlecompare.
function push_singlecompare_Callback(hObject, eventdata, handles)
% hObject    handle to push_singlecompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imno = str2double(get(handles.edit_singlecompare, 'String'));
if ~isnan(imno)
    ref = handles.Ref(:, :, imno);
    tar = handles.Tar(:, :, imno);
    coef = similaritycompareSingle(ref, tar, 'isshow', 1)
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_singlecompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_singlecompare as text
%        str2double(get(hObject,'String')) returns contents of edit_singlecompare as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_singlecompare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
