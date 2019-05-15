%% PERFORMANCE EVALUATION FRAMEWORK FOR IMAGE SEGMENTATION ALGORITHM
% Create an image 
% Simulate reference and segmented region
% Evaluation segmentation performance by following metrics
%   1. Jaccard Coefficient
%   2. Dice Coefficient
%   3. Conformity
%   4. Sensitivity
%   5. Specificity
%   7. Sensibility

%% Create a simullated scene
% Image
W = 512;
H = 512;
I = zeros(W, H);

% Reference
x0 = round(W/2);
y0 = round(H/2);
a = round(W/6);
b = round(H/4);

t = 0:0.01:(2*pi);
x = x0 + a*cos(t);
y = y0 + b*sin(t);
plot(x,y)
axis([0 W 0 H])

%%
close all
h = imshow(I);
for i = 1:length(t)
    xi = round(x(i));
    yi = round(y(i));
    h.CData(xi, yi) = 1;
    pause(0.001)
    drawnow;
end
    

%% Create a ellipse mask
c = fix(size(I) / 2);   %# Ellipse center point (y, x)
r_sq = [76, 100] .^ 2;  %# Ellipse radii squared (y-axis, x-axis)
[X, Y] = meshgrid(1:size(I, 2), 1:size(I, 1));
ellipse_mask = (r_sq(2) * (X - c(2)) .^ 2 + ...
    r_sq(1) * (Y - c(1)) .^ 2 <= prod(r_sq));

%# Apply the mask to the image
I_cropped = bsxfun(@times, I, uint8(ellipse_mask));