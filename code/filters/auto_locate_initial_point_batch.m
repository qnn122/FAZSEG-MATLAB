%Auto located the initial point
close all
clear
pathname = uigetdir; %gets directory
files = dir(fullfile(pathname,'*png'));
%files = dir(fullfile(pathname,'**/*.tif'));
n = length(files);

for k = 1:n

[pathstr,name,ext] = fileparts(files(k).name);
directory = fullfile(pathname,files(k).name);
I = imread(directory);

grayImg = I;
[width, height] = size(grayImg);
gTH = 50;

maxDistance = 0;
centrePXH = 0;
centrePYH = 0;
for row=1:width
    p = 0; curDistance = 0;
    for col=1:height
          if grayImg(row, col) > gTH     
              curDistance = col - p;         
              
              if curDistance > maxDistance
                  maxDistance = curDistance;
                  centrePXH = row;
                  centrePYH = p + curDistance/2;
              end
              p = col;
          end
      end
end
x1 = centrePXH; y1 = centrePYH-maxDistance/2;
x2 = centrePXH; y2 = centrePYH+maxDistance/2;
figure('units','normalized','outerposition',[0 0 1 1])
imshow(grayImg);
line([x1,x2],[y1,y2]);

maxDistance = 0;
centrePXV = 0;
centrePYV = 0;
for col=1:height
    p = 0; curDistance = 0;
    for row=1:width
          if grayImg(row, col) > gTH
              curDistance = row - p;         
              
              if curDistance > maxDistance
                  maxDistance = curDistance;
                  centrePXV = p + curDistance/2;
                  centrePYV = col;
              end
              p = row;
          end
      end
end
x1 = centrePXV; y1 = centrePYV-maxDistance/2;
x2 = centrePXV; y2 = centrePYV+maxDistance/2;
line([x1,x2],[y1,y2]);

end