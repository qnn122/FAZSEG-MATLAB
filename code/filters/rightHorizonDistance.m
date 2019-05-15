function [ d ] = rightHorizonDistance( cluster, mask )
%Calculate max horizon distance from the cluster to the mask
%cluster: a vector contain all cluster pixels
%mask: a binary 2d matrix
[width, height] = size(mask);
s = [width, height];
[X,Y] = ind2sub(s,cluster);
[M,I] = max(X);
cX = X(I);
cY = Y(I);
%cX = fix(sum(X)/length(X));
%cY = fix(sum(Y)/length(Y));

disRight = 0;
for x = cX+1:width
    if mask(x, cY) == 1
        disRight = x - cX;
        break;
    end
end

d = disRight;
end
