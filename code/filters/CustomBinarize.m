function [ outputImg ] = CustomBinarize( inputImg )
%{
Custom binarize image
Steps:
-Calculate custom threshold for each pixel > common threshold
Custom threshold for pixel P: avg gray value of the NxN box centered at P
%}
%inputImg = imread('19.tif');
inputImg = double(inputImg(:,:,1));
boxSize = 5; %odd value
hs = (boxSize - 1)/2;
[width, height] = size(inputImg);
commonThreshold = sum(sum(inputImg))/(width*height);

commonThreshold = 20;
CH(1:width, 1:height) = commonThreshold;

for x = hs + 1:width-hs - 1
    for y = hs + 1:height - hs - 1
        if inputImg(x, y) > commonThreshold
            cth = 0;
            for i = -hs:hs
                for j = -hs:hs
                    cth = cth + inputImg(x + i, y + j);
                end
            end
            cth = cth/(boxSize*boxSize);
            CH(x, y) = cth;
        end
    end
end

for x = 1:width
    for y = 1:height
       if inputImg(x, y) > CH(x, y)
           inputImg(x, y) = 255;
       else
           inputImg(x, y) = 0;
       end
    end
end

outputImg = inputImg;
end