function varargout = gui_startup(varargin)
% GUI_STARTUP MATLAB code for gui_startup.fig
%      GUI_STARTUP, by itself, creates a new GUI_STARTUP or raises the existing
%      singleton*.
%
%      H = GUI_STARTUP returns the handle to a new GUI_STARTUP or the handle to
%      the existing singleton*.
%
%      GUI_STARTUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_STARTUP.M with the given input arguments.
%
%      GUI_STARTUP('Property','Value',...) creates a new GUI_STARTUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_startup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_startup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_startup

% Last Modified by GUIDE v2.5 09-Jul-2018 22:26:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_startup_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_startup_OutputFcn, ...
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


% --- Executes just before gui_startup is made visible.
function gui_startup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_startup (see VARARGIN)

% Choose default command line output for gui_startup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_startup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_startup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_eval_Callback(hObject, eventdata, handles)
% hObject    handle to menu_eval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_eval_compsimi_Callback(hObject, eventdata, handles)
% hObject    handle to menu_eval_compsimi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_runcompare


% --------------------------------------------------------------------
function menu_seg_single_Callback(hObject, eventdata, handles)
% hObject    handle to menu_seg_single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_segmentsingle

% --------------------------------------------------------------------
function menu_seg_set_Callback(hObject, eventdata, handles)
% hObject    handle to menu_seg_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_compute_Callback(hObject, eventdata, handles)
% hObject    handle to menu_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_compute_FAZ_Callback(hObject, eventdata, handles)
% hObject    handle to menu_compute_FAZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_compute_FAZ_area_Callback(hObject, eventdata, handles)
% hObject    handle to menu_compute_FAZ_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_computearea
