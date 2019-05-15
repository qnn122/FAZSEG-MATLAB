function [value] = avgGrayValue(Img, phi)
mask=sign(phi);
[width, height] = size(Img);
value = 0;
count = 0;
for i = 1:width
    for j = 1:height
        if mask(i, j) == -1
            value = value + Img(i, j);
            count = count + 1;
        end
    end
end

value = fix(value/count);

end