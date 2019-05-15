close all
clear
CurrentDir = pwd;
[filename,pathname] = uigetfile({'*.jpg;*.png;*.tif','OCTA Images *.jpg *.png *.tif'},'choose OCTA images',CurrentDir);

if pathname == 0
    return
end
FullPath = fullfile(pathname,filename);
grayImg = imread(FullPath);

[width, height] = size(grayImg);
totalGrayValue = sum(sum(grayImg));
gTH = totalGrayValue/width/height;
gTH = 10;

subplot(1,2,1)
imshow(grayImg)

subplot(1,2,2)
for row=1:width
    maxDistance = 0;
    centrePXH = 0;
    centrePYH = 0;

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
     
    x1 = centrePXH; y1 = centrePYH-maxDistance/2;
    x2 = centrePXH; y2 = centrePYH+maxDistance/2;
    %line([x1,x2],[y1,y2]);
    line([y1,y2],[x1,x2]);
end

%{
maxDistance = 0;
centrePXV = 0;
centrePYV = 0;
for col=1:height
    p1 = 0; p2 = 0; curDistance = 0;
    for row=1:width
          if grayImg(row, col) > gTH
              p2 = row;              
              curDistance = p2 - p1;         
              
              if curDistance > maxDistance
                  maxDistance = curDistance;
                  centrePXV = p1 + curDistance/2;
                  centrePYV = col;
              end
              p1 = p2;
          else
              p2 = row;
          end
      end
end

cX = fix((centrePXH + centrePXV)/2);
cY = fix((centrePYH + centrePYV)/2);
x1 = centrePXH;
x2 = centrePXV;
y1 = centrePYH;
y2 = centrePYV;

imshow(grayImg);
line([x1,x2],[y1,y2]);
%}