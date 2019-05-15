close all;
clear;
BW = imread('19 full size.png');
[width, height] = size(BW);
%imshow(BW);
binThreshold = 3;

%BI = im2bw(BW,binThreshold);
BI = BW > binThreshold;
mask = zeros(width, height);
CC = bwconncomp(BI);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
%BW(CC.PixelIdxList{idx}) = 0;
biggestCluster = CC.PixelIdxList{idx};
s = [width, height];
IND = biggestCluster;
[I,J] = ind2sub(s,IND);

for i=1:length(biggestCluster)
  mask(I(i), J(i)) = 1;  
end

BIFiltered = BI;
d = 0;
%{
%old code
for i=1:length(CC.PixelIdxList)
    if i ~= idx
        d = horizonDistance(CC.PixelIdxList{i}, mask);
        if d > 50
            BIFiltered(CC.PixelIdxList{i}) = 0;
        end
    end
end
%}

%new code
bgValue = 0; dSC = 5; dBC = 10; maxClusterSize = 50;

for i=1:length(CC.PixelIdxList)
    if i ~= idx
        d1 = horizonDistance(CC.PixelIdxList{i}, mask);
        d2 = verticalDistance(CC.PixelIdxList{i}, mask);
        ld = leftHorizonDistance(CC.PixelIdxList{i}, mask);
        rd = rightHorizonDistance(CC.PixelIdxList{i}, mask);
        td = topVerticalDistance(CC.PixelIdxList{i}, mask);
        bd = botVerticalDistance(CC.PixelIdxList{i}, mask);
        
        l = length(CC.PixelIdxList{i});
        %if (d1 > 50 || d2 > 50) && l < 30
        if (d1 + d2 > 120)
            if  l < maxClusterSize
                if ld > dSC && rd > dSC && td > dSC && bd > dSC
                    BIFiltered(CC.PixelIdxList{i}) = bgValue;
                end
            else
                if ld > dBC && rd > dBC && td > dBC && bd > dBC
                    BIFiltered(CC.PixelIdxList{i}) = bgValue;
                end
            end
        end
    end
end

%{
for i=1:length(biggestCluster)
  elm = biggestCluster(i);
  [I, J] = ind2sub(BW, elm);
  %BW(fix(elm/width), rem(elm,width)) = 0;
  %BW(rem(elm,width) + 1, fix(elm/width)) = 0;
  BW(I, J) = 0;
end
%}
figure(1);
labeled = labelmatrix(CC);
RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
imshow(RGB_label,'InitialMagnification','fit')
%imshow(BI,'InitialMagnification','fit')

figure(2);
CCFiltered = bwconncomp(BIFiltered);
labeledF = labelmatrix(CCFiltered);
RGB_labelF = label2rgb(labeledF, @copper, 'c', 'shuffle');
imshow(RGB_labelF,'InitialMagnification','fit')
%imshow(BIFiltered,'InitialMagnification','fit')

%imshow(BW);