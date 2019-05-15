filename = 'HP-001 OS 2017-10-31T074736 OCTA  07_DVC PARon v6.9.5.100.png_cropped-1.tif'
im = imread(filename);
imshow(im)

% Extract yellow border 
labim = rgb2lab(im);
border = labim(:,:,3);

% Get rid of the background
border = border>0.5;
[B,FAZ,N] = bwboundaries(border);

% Visualize every step
subplot(1, 3, 1), imshow(im);
subplot(1, 3, 2), imshow(border);
subplot(1, 3, 3), imshow(FAZ);

% Take information of the working folders
pathname = cd;
files = dir(fullfile(pathname, '*tif'));
n = length(files);

% Create destiny folder
saveFolder = 'FAZseg_Manual2';
SaveDir = fullfile(pathname, saveFolder);
if ~exist(SaveDir,'dir')
    mkdir(SaveDir);
end

% Extract Manual Segment
for k = 1:n
    [pathstr, filename,ext] = fileparts(files(k).name);
    im = imread(strcat(filename, ext));

    % Extract yellow border 
    labim = rgb2lab(im);
    border = labim(:,:,3);

    % Get rid of the background
    border = border>0.5;
    [B,FAZ,N] = bwboundaries(border);
    FAZ = imcomplement(FAZ);
    
    % Save
    SavePath = fullfile(SaveDir, strcat(filename, '_', saveFolder, '.png'));
    imwrite(FAZ, SavePath, 'PNG');
end
