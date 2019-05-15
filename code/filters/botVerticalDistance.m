function [ d ] = botVerticalDistance( cluster, mask )
%Calculate max horizon distance from the cluster to the mask
%cluster: a vector contain all cluster pixels
%mask: a binary 2d matrix
[width, height] = size(mask);
s = [width, height];
[X,Y] = ind2sub(s,cluster);
[M,I] = max(Y);
cX = X(I);
cY = Y(I);

%cX = fix(sum(X)/length(X));
%cY = fix(sum(Y)/length(Y));

disBot = 0;
for y = cY+1:height
    if mask(cX, y) == 1
        disBot = y - cY;
        break;
    end
end

d = disBot;
end
