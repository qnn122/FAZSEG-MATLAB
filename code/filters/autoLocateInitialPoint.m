function [ cX, cY ] = autoLocateInitialPoint( grayImg, gTH )
%Auto located the initial point
[width, height] = size(grayImg);
%totalGrayValue = sum(sum(grayImg));
%gTH = totalGrayValue/width/height;
%gTH = 30;

%NEW CODE

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

%cX = centrePXH;
%cY = centrePYH;
cY = centrePXH;
cX = centrePYH;
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
%}

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

cX = centrePX;
cY = centrePY;
%}

end