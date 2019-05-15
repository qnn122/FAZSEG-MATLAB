function [ d ] = leftHorizonDistance( cluster, mask )
%Calculate max horizon distance from the cluster to the mask
%cluster: a vector contain all cluster pixels
%mask: a binary 2d matrix
[width, height] = size(mask);
s = [width, height];
[X,Y] = ind2sub(s,cluster);

[M,I] = min(X);
cX = X(I);
cY = Y(I);

%cX = fix(sum(X)/length(X));
%cY = fix(sum(Y)/length(Y));

disLeft = 0;
for x = cX-1:-1:1
    if mask(x, cY) == 1
        disLeft = cX - x;
        break;
    end
end


d = disLeft;
end
