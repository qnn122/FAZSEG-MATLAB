function [ d ] = topVerticalDistance( cluster, mask )
%Calculate max horizon distance from the cluster to the mask
%cluster: a vector contain all cluster pixels
%mask: a binary 2d matrix
[width, height] = size(mask);
s = [width, height];
[X,Y] = ind2sub(s,cluster);
[M,I] = min(Y);
cX = X(I);
cY = Y(I);
%cX = fix(sum(X)/length(X));
%cY = fix(sum(Y)/length(Y));

disTop = 0;
for y = cY-1:-1:1
    if mask(cX, y) == 1
        disTop = cY - y;
        break;
    end
end
d = disTop;
end
