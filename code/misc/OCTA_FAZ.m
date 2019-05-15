%% Enhancement of the 2D retinal vasculature
clear;
close all;
%variables:
conversion_factor = 0.0055;
FAZpixel = 0;
FAZarea = 0;
Vessel_pixel = 0;
VAD = 0;
VLD = 0;

CurrentDir = pwd;
[filename,pathname] = uigetfile({'*.jpg;*.png;*.tif','OCTA Images *.jpg *.png *.tif'},'choose OCTA images',CurrentDir);

if pathname == 0
    return
end
FullPath = fullfile(pathname,filename);
%SaveFolder = strcat(filename,' Filtered');
[pathstr,name,ext] = fileparts(FullPath);
SaveDir = fullfile(pathname, name);


%SaveDir = fullfile(pathname,SaveFolder);
if ~exist(SaveDir,'dir')
    mkdir(SaveDir);
end

I = imread(FullPath);
OriginalImage = I;
ID=double(I(:,:,1));

figure('units','normalized','outerposition',[0 0 1 1])
%subplot(1,3,1)
figure(1)
imshow(I)

%I = rgb2gray(I);
I = imcomplement(I);
% preprocess the input a little bit
Ip = single(I);
thr = prctile(Ip(Ip(:)>0),1) * 0.9;
Ip(Ip<=thr) = thr;
Ip = Ip - min(Ip(:));
Ip = Ip ./ max(Ip(:));    

V1 = vesselness2D(Ip, 0.5:0.5:2.5, [1;1], 2, false);

%subplot(1,3,2)
figure(2)
imshow(V1)
%imagesc(V1,[0, 255]);

SavePath = fullfile(SaveDir,strcat(name,' Filtered.png'));
imwrite(V1,SavePath,'PNG');

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Call level set function
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Apply level set 2 times
%- First time: use default ccl value to identify the faz and calculate the
%average FAZ gray value
%- Second time: use the average FAZ gray value as the start threshold and 
%redo the process
SImg=imread(SavePath);
SImg=double(SImg(:,:,1));
Img = SImg;

%+++++++++++++++++++First time
%figure(1)
%subplot(1,3,3)
%figure(3)
%{
startTH = 12; endTH = 3; thInterval = 3;
bgValue = 3;
for th = startTH:-thInterval:endTH
    Img = CCL(Img, th, bgValue, 5, 10, 50);
end
%imshow(Img)
imagesc(Img,[0, 255]);
axis off; axis equal;
colormap(gray)
%}

%locate the initial point
%gTH = 50;
%[cX, cY] = autoLocateInitialPoint(Img, gTH);

gTH = 15;
[cX, cY] = autoLocateInitialPoint(imread(FullPath), gTH);
hold on
th = 0:pi/50:2*pi;
r = 10;
xunit = r * cos(th) + cX;
yunit = r * sin(th) + cY;
h = plot(xunit, yunit);
hold off

figure(4)
%phi = LevelSet(Img, cX, cY, filename);
phi = LevelSet(Img, cY, cX, filename);
%+++++++++++++++++++Second time
%{
figure(2)
%ID = double(I(:,:,1));
avgGrayValue = avgGrayValue(SImg, phi);
startTH = avgGrayValue*5-10; endTH = 3; thInterval = 3;
bgValue = 3;
for th = startTH:-thInterval:endTH
    Img = CCL(SImg, th, bgValue, 8, 50);
end


[cX, cY] = autoLocateInitialPoint(Img, gTH);
phi = LevelSet(Img, cX, cY, filename);
%}
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Calculate FAZ area
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
signMatrix=sign(phi);
ipositif=sum(signMatrix(:)==1);
inegatif=sum(signMatrix(:)==-1);

FAZpixel = inegatif
FAZarea = FAZpixel*conversion_factor*conversion_factor

%Save FAZ detection result
[filepath,name,ext] = fileparts(SavePath);
%SavePath1 = fullfile(SaveDir,strcat(name,' FAZpixel: ', int2str(FAZpixel),'.png'));
SavePath1 = fullfile(SaveDir,strcat(name,' FAZpixel - ',int2str(FAZpixel),'.png'));
imwrite(phi,SavePath1,'PNG');

SavePath2 = fullfile(SaveDir,strcat(name,' full result.png'));
saveas(gcf, SavePath2);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Create binary image
%{
GImg = Img;

figure(2);
[width, height]=size(GImg);

sumVal=sum(GImg);         % sum of all columns
total=sum(sumVal);     % total sum
avg=total/(width*height);
level = avg;

%{
level = avgGrayValue(SImg, phi);
level = avgGrayValue(ID, phi);
level = 50;
%}
%BW = imbinarize(GImg,level);
%Use custom binarize
BW = CustomBinarize(GImg);
imshowpair(GImg,BW,'montage')
title('Custom Binarize')

figure(4);
BW1 = imbinarize(GImg,level);
imshowpair(GImg,BW1,'montage')
title('Default Binarize')
%Calculate vessel density percent
ctr = sum(BW(:) == 1);
Vessel_pixel = ctr;
ScanArea_pixel = width*height;
ScanArea = ScanArea_pixel*conversion_factor*conversion_factor;

VAD = 100*Vessel_pixel/(ScanArea_pixel-FAZpixel);
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Create Skeleton image
figure(3);
SkelImg = bwmorph(BW,'skel',Inf);
imshowpair(GImg,SkelImg,'montage')
totalLength = sum(SkelImg(:) == 1);
%convert branch length from pixel to mm
Lengthmm = totalLength*conversion_factor;
%vessel length density
VLD = Lengthmm/(ScanArea - FAZarea);
%}
%{
%sharpen test
figure(4);
H = padarray(2,[2 2]) - fspecial('gaussian' ,[5 5],2); % create unsharp mask
sharpened = imfilter(GImg,H);  % create a sharpened version of the image using that mask

imshow([GImg sharpened]); %showing input & output images
%}