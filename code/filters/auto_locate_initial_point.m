%Auto located the initial point
close all
clear
CurrentDir = pwd;
[filename,pathname] = uigetfile({'*.jpg;*.png;*.tif','OCTA Images *.jpg *.png *.tif'},'choose OCTA images',CurrentDir);

if pathname == 0
    return
end
FullPath = fullfile(pathname,filename);
I = imread(FullPath);

%Img = imread('32.png');
%figure(1)
%imshow(Img);
%grayImg = rgb2gray(Img);
grayImg = I;
[width, height] = size(grayImg);

%{
avgGrayValue = 0;
for row=1:size(grayImg,1)
    for col=1:size(grayImg,2)
          avgGrayValue = avgGrayValue + grayImg(row, col);
      end
end
%}
%avgGrayValue = avgGrayValue/width/height;
totalGrayValue = sum(sum(grayImg));
gTH = totalGrayValue/width/height;
gTH = 10;

%OLD CODE
%{
maxDistance = 0;
centrePX = 0;
centrePY = 0;
for row=1:width
    p1 = row; p2 = row; curDistance = 0;
    for col=1:height
          if grayImg(row, col) > gTH
              p2 = col;              
              curDistance = p2 - p1;         
              
              if curDistance > maxDistance
                  maxDistance = curDistance;
                  centrePX = row;
                  centrePY = p1 + curDistance/2;
              end
              p1 = p2;
          else
              p2 = col;
          end
      end
end

x1 = centrePX; y1 = centrePY-maxDistance/2;
x2 = centrePX; y2 = centrePY+maxDistance/2;

x = [x1 y1];
y = [x2 y2];

imshow(grayImg);
line([x1,x2],[y1,y2]);
%}

%NEWCODE
imshow(grayImg);

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
%line([x1,x2],[y1,y2]);
line([y1,y2],[x1,x2]);

hold on
th = 0:pi/50:2*pi;
r = 10;
xunit = r * cos(th) + centrePYH;
yunit = r * sin(th) + centrePXH;
h = plot(xunit, yunit);
hold off
%{
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
%line([x1,x2],[y1,y2]);
line([y1,y2],[x1,x2]);
%}
%cX = fix((centrePXH + centrePXV)/2);
%cY = fix((centrePYH + centrePYV)/2);


