function varargout = gui_segmentsingle(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_segmentsingle_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_segmentsingle_OutputFcn, ...
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


% --- Executes just before gui_segmentsingle is made visible.
function gui_segmentsingle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_segmentsingle (see VARARGIN)

% Choose default command line output for gui_segmentsingle
handles.output = hObject;
set(handles.BinarizeCB,'value',1)
%my variables
handles.lastPath = '';
handles.FullPath = '';
handles.pathname = '';
handles.filename = '';
handles.SaveFolder = '';
handles.SaveDir = '';

% Run config file
FAZSEG_config

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_segmentsingle wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_segmentsingle_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BinarizeCB.
function BinarizeCB_Callback(hObject, eventdata, handles)
% hObject    handle to BinarizeCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BinarizeCB



function FilePathTxt_Callback(hObject, eventdata, handles)
% hObject    handle to FilePathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilePathTxt as text
%        str2double(get(hObject,'String')) returns contents of FilePathTxt as a double


% --- Executes during object creation, after setting all properties.
function FilePathTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilePathTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseBtn_Click.
function BrowseBtn_Click_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseBtn_Click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% If this is the first time running the function this session,
% Initialize lastPath to 0

%{
if isempty(lastPath) 
    lastPath = 0;
end
% First time calling 'uigetfile', use the pwd
if lastPath == 0
    [filename,pathname] = uigetfile({'*.png;*.tif','*.png *.tif'},'choose OCTA images');

% All subsequent calls, use the path to the last selected file
else
    [filename, pathname] = uigetfile({'*.png;*.tif','OCTA Images *.png *.tif'},'choose OCTA images',lastPath);
end
% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if pathname ~= 0
    lastPath = pathname;
end

if pathname == 0
    return
end
%}
[handles.filename,handles.pathname] = uigetfile({'*.png;*.tif','*.png *.tif'},'choose OCTA images');
handles.FullPath = fullfile(handles.pathname,handles.filename);
handles.SaveFolder = strcat(handles.filename,' Filtered');

handles.SaveDir = fullfile(handles.pathname,handles.SaveFolder);
if ~exist(handles.SaveDir,'dir')
    mkdir(handles.SaveDir);
end

set(handles.FilePathTxt, 'string', handles.FullPath)
guidata(hObject,handles)

% --- Executes on button press in BatchCB.
function BatchCB_Callback(hObject, eventdata, handles)
% hObject    handle to BatchCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BatchCB


% --- Executes on button press in ProcessBtn_Click.
function ProcessBtn_Click_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessBtn_Click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%

% Get option values
binarizeVal = get(handles.BinarizeCB, 'Value');
isCCL = get(handles.Checkbox_CCL, 'Value');
isSaveouput = get(handles.Checkbox_Saveouput, 'Value');

% Variable Declaration
conversion_factor = 0.0055;
FAZpixel = 0;
FAZarea = 0;
Vessel_pixel = 0;
VAD = 0;
VLD = 0;

% Read image
I = imread(handles.FullPath);
I = rgb2gray(I);
OriginalImage = I;
ID=double(I(:,:,1));

% Preprocess the input a little bit
I = imcomplement(I);
Ip = single(I);
thr = prctile(Ip(Ip(:)>0),1) * 0.9;
Ip(Ip<=thr) = thr;
Ip = Ip - min(Ip(:));
Ip = Ip ./ max(Ip(:));    

% Vesselness Enhancement
V1 = vesselness2D(Ip, 0.5:0.5:2.5, [1;1], 2, false);

% Image has to be scaled up before other steps
Img = double(round(255*V1));

% CCL
if isCCL == 1
    fprintf('Connected Labelling...\n');
    startTH = 24; endTH = 3; thInterval = 3;
    bgValue = 3;
    for th = startTH:-thInterval:endTH
        Img = CCL(Img, th, bgValue, 8, 20, 50);
    end
    fprintf('Done.\n');
end

% Locate the initial point
gTH = 30;
[cX, cY] = autoLocateInitialPoint(Img, gTH);

% FAZ Segmentation by Level Set
show=1;
phi = LevelSet(Img, cX, cY, show);

% Calculate FAZ Area (mm2)
signMatrix=sign(phi);
ipositif=sum(signMatrix(:)==1);
inegatif=sum(signMatrix(:)==-1);
FAZpixel = inegatif;
FAZarea = FAZpixel*conversion_factor*conversion_factor

% Show segmentaqtion result
figure;
imshow(phi);
title(sprintf('FAZ Area: %.2f mm^2', FAZarea));

% Vessel density and skeleton
if binarizeVal == 1
    GImg = Img;
    [width, height]=size(GImg);
    BW = CustomBinarize(GImg);
    
    % Calculate essel Area Density (VAD)
    ctr = sum(BW(:) == 255);
    Vessel_pixel = ctr;
    ScanArea_pixel = width*height;
    ScanArea = ScanArea_pixel*conversion_factor*conversion_factor;
    VAD = 100*Vessel_pixel/(ScanArea_pixel-FAZpixel);
    
    % Show VAD
    figure; imshow(BW)    
    title(sprintf('Vessel Area Density: %.2f %%', VAD))
    
    % Create Skeleton image
    SkelImg = bwmorph(BW,'skel',Inf);
    %imshowpair(GImg,SkelImg,'montage')
    
    % Convert branch length from pixel to mm
    totalLength = sum(SkelImg(:) == 1);
    Lengthmm = totalLength*conversion_factor;
    
    % Calculate vessel length density
    VLD = Lengthmm/(ScanArea - FAZarea);
    
    % Show skeleton
    figure; imshow(SkelImg);
    title(sprintf('Vessel Length Density: %.2f', VLD));
end

% Saving ouput
if isSaveouput
    % Vesselness enhancement
    SavePath = fullfile(handles.SaveDir,handles.filename);
    imwrite(V1,SavePath,'PNG');

    % Segmentation results
    [filepath,name,ext] = fileparts(SavePath);
    SavePath1 = fullfile(handles.SaveDir,strcat(name,' FAZpixel - ',int2str(FAZpixel),'.png'));
    imwrite(phi,SavePath1,'PNG');

%     SavePath2 = fullfile(handles.SaveDir,strcat(name,' full result.png'));
end
%saveas(gcf, SavePath2);


% --- Executes on button press in Brwn_Btn.
function Brwn_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to Brwn_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.filename,handles.pathname] = uigetfile({'*.png;*.tif','*.png *.tif'},'choose OCTA images');
handles.FullPath = fullfile(handles.pathname,handles.filename);
handles.SaveFolder = strcat(handles.filename,' Filtered');

handles.SaveDir = fullfile(handles.pathname,handles.SaveFolder);
isSave = get(handles.Checkbox_Saveouput, 'Value');

if ~exist(handles.SaveDir,'dir') && isSave
    mkdir(handles.SaveDir);
end

set(handles.FilePathTxt, 'string', handles.FullPath)
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function BinarizeCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinarizeCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Checkbox_Saveouput.
function Checkbox_Saveouput_Callback(hObject, eventdata, handles)
% hObject    handle to Checkbox_Saveouput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Checkbox_Saveouput


% --- Executes on button press in Checkbox_CCL.
function Checkbox_CCL_Callback(hObject, eventdata, handles)
% hObject    handle to Checkbox_CCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Checkbox_CCL
