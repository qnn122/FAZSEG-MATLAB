function varargout = gui_computearea(varargin)
% GUI_COMPUTEAREA MATLAB code for gui_computearea.fig
%      GUI_COMPUTEAREA, by itself, creates a new GUI_COMPUTEAREA or raises the existing
%      singleton*.
%
%      H = GUI_COMPUTEAREA returns the handle to a new GUI_COMPUTEAREA or the handle to
%      the existing singleton*.
%
%      GUI_COMPUTEAREA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COMPUTEAREA.M with the given input arguments.
%
%      GUI_COMPUTEAREA('Property','Value',...) creates a new GUI_COMPUTEAREA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_computearea_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_computearea_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_computearea

% Last Modified by GUIDE v2.5 11-Jul-2018 13:58:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_computearea_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_computearea_OutputFcn, ...
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


% --- Executes just before gui_computearea is made visible.
function gui_computearea_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_computearea (see VARARGIN)

% Choose default command line output for gui_computearea
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_computearea wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_computearea_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_path_Callback(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_path as text
%        str2double(get(hObject,'String')) returns contents of edit_path as a double


% --- Executes during object creation, after setting all properties.
function edit_path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_browse.
function push_browse_Callback(hObject, eventdata, handles)
% hObject    handle to push_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get path
handles.path = uigetdir; %gets directory

% Update edit text
set(handles.edit_path, 'String', handles.path)

% Save data
guidata(hObject, handles)


% --- Executes on button press in push_compute.
function push_compute_Callback(hObject, eventdata, handles)
% hObject    handle to push_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.path = get(handles.edit_path, 'String');
imset = getDataFromPath(handles.path);

% Calc Area
convfact = str2double(get(handles.edit_convertfactor, 'String'));
[FAZpixel, FAZarea] = calcFAZArea(imset, 'convfact', convfact, 'ispixel', 1);
area = table(FAZpixel, FAZarea);

% Display data
gui_disptable(area);

% Sending result to workspace
assignin('base', 'Results', area);

fprintf('FAZ Area: %.3f %s %.3f\n', mean(FAZarea), char(177), std(FAZarea));% Save data

% Update data
handles.area = area;
guidata(hObject, handles)


% Return set of image from path
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



function edit_convertfactor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_convertfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_convertfactor as text
%        str2double(get(hObject,'String')) returns contents of edit_convertfactor as a double


% --- Executes during object creation, after setting all properties.
function edit_convertfactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_convertfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
