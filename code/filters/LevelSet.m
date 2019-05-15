function [ phi ] = LevelSet( Img, cX, cY, varargin)
%% LEVELSET performs Level Set method
% Img: Input image 
% cX : initial X corrdinate
% cX : initial Y coordinate
% (Optional)
%   show <logical>: turn visualization on/off
%

%%
if isempty(varargin)
    show=0;
else
    show = varargin{1};
end

%% Parameter setting
timestep = 1;       % time step
mu = 0.2 / timestep;% coefficient of the distance regularization term R(phi)

iter_inner = 15;
iter_outer = 100;   % Assumingly a very large number

lambda = 5;         % coefficient of the weighted length term L(phi)
alfa = -3;          % coefficient of the weighted area term A(phi)
epsilon = 1.5;      % papramater that specifies the width of the DiracDelta function

sigma = .8;         % scale parameter in Gaussian kernel
G = fspecial('gaussian',15,sigma);  % Caussian kernel
Img_smooth = conv2(Img,G,'same');   % smooth image by Gaussiin convolution
[Ix, Iy] = gradient(Img_smooth);
f = Ix.^2 + Iy.^2;
g = 1./(1+f);  % edge indicator function.

%% Initialize LSF as binary step function
c0 = 2;
initialLSF = c0*ones(size(Img));

%% Generate the initial region R0 as two rectangles
initialLSF(cX-12:cX-2,cY-12:cY-2) = -c0; 
initialLSF(cX+2:cX+12,cY+2:cY+12) = -c0;
phi = initialLSF;

potential = 2;  
if potential ==1
    potentialFunction = 'single-well';  % use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model 
elseif potential == 2
    potentialFunction = 'double-well';  % use double-well potential in Eq. (16), which is good for both edge and region based models
else
    potentialFunction = 'double-well';  % default choice of potential function
end  

% Stoping criteria
deltaphi = 100;
lastphi = phi;
[W, H] = size(Img);
thres_phi = W*H*0.03/100;  % Threshold to stop (0.1% area of the image)

%% Initiate visualization
if show
    hfig = figure;
    set(hfig, 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.7], 'Color', 'w');
    % For drawing LSF expansion
    hax1 = subplot(1,2,1);
    him = imagesc(Img,[0, 255]); 
    axis off; axis equal; colormap(gray);
    
    % For drawing errors
    hax2 = subplot(1,2,2);
    x=0; y=0;
    hplot = plot(x,y);
    hold on;
    hplot2 = plot(1:iter_outer, thres_phi*ones(iter_outer,1), '-r');
    htext = text(5, thres_phi+100, 'Threshold', 'Color', 'r');
    hold off;
end

%% Start level set evolution
for n=1:iter_outer
    phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction); 
    deltaphi_temp = abs(lastphi - phi);
    deltaphi = sum(deltaphi_temp(:));
    fprintf('Loop %dth over %d - Delta = %.2f\n', n, iter_outer, deltaphi);

    % Update phi 
    lastphi = phi;
    if deltaphi < 10
        break;
    end
    
    x(n) = n;
    y(n) = deltaphi;
    
    if show==1 && mod(n,2)==0
        % Update image
        axes(hax1);
        imagesc(Img,[0, 255]); 
        hold on;  
        contour(phi, [0,0], 'r', 'LineWidth', 2);
        axis off;
        
        % Update deltaphi
        axes(hax2);
        hplot.XData = x;
        hplot.YData = y;
        
        drawnow;
    end
    
    if deltaphi < thres_phi
        fprintf('Delta is smaller than 0.05 percent of the image area (%.2f), stop expanding\n', thres_phi);
        break;
    end
end
hold off;

%% Refine the zero level contour by further level set evolution with alfa=0
alfa=0;
iter_refine = 10;
phi = drlse_edge(phi, g, lambda, mu, alfa, epsilon, timestep, iter_inner, potentialFunction);

end
