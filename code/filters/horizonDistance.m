function [ d ] = horizonDistance( cluster, mask )
%Calculate horizon distance (2 directions) from the cluster to the biggest
%cluster (mask)
%cluster: a vector contain all cluster pixels
%mask: a binary 2d matrix that mark the biggest cluster
[width, height] = size(mask);
s = [width, height];
[X,Y] = ind2sub(s,cluster);
cX = fix(sum(X)/length(X));
cY = fix(sum(Y)/length(Y));

disLeft = 0;
disRight = 0;

for x = cX-1:-1:1
    if mask(x, cY) == 1
        disLeft = cX - x;
        break;
    end
end

for x = cX+1:width
    if mask(x, cY) == 1
        disRight = x - cX;
        break;
    end
end

d = disLeft + disRight;
end
