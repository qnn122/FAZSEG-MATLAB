function imSet = imsetgen(varargin)
%% IMSETGEN
% Generate a multi-dimensional matrix containing a set of images in the
% seletecd folder
% 
% Optional:
%   folder  <str>: directory to selected folder
%   save    <str>: name of the .mat file containing image set 
%
% Example:
%   imsetgen('save', 'FAZsegAutoCCL.mat');

%% Checking things
%
p = inputParser;

%
defaultPathname = 0;
defaultSave = 0;

%
addParameter(p, 'pathname', defaultPathname, @isstr)
addParameter(p, 'save', defaultSave, @isstr)

%
parse(p, varargin{:})


%% Marker (VERY IMPORTANT)
pathname = uigetdir; %gets directory
files = dir(fullfile(pathname,'*png'));


%% Load data
numPatient = length(files);


for k=1:numPatient
    % Manual Segmetation
    [pathManual, filenameManual] = fileparts(files(k).name);
    im = imread(strcat(fullfile(pathname, filenameManual), '.png'));
      
    % Save data
    imSet(:,:,k) = im;
end


%%
filesavename = p.Results.save;
if ~isempty(filesavename)
    save(filesavename, 'imSet');
end


