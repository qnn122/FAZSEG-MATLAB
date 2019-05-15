function coefficients = similaritycompare(refSet, segSet, varargin)
%% SIMILARITYCOMPARE compare similarity between 2 set of image
% Input:
% 	setOne 	<M x N x k>: set of k images with size MxN with segmented ROI
% 	setOne 	<M x N x k>: set of k images with size MxN
% Output
%   coefficiences: a table includes
%       J       <k x 1> Vector of k Jaccard coeffcients 
%       C       <k x 1> Conformity coeffcients 
%       stv 	<k x 1> Sensitivity coeffcients 
%       spf     <k x 1> Specificity coeffcients 
%       sbl     <k x 1> Sensibility coeffcients 
%
% Optional:
%   isshow  <logical>: plot result, all samples vs all coefficients
%   isprint <logical>: print summary in form mean +- std
%   sample  <numeric>: specific image in the set, refering to ID
%   save    <string> : name of the saved file, e.g. 'Results.mat'
%
% Example:
%   similaritycompare(manual1, autoCCL, 'sample', 8);
%   Man1_AutoCCL = similaritycompare(manual1, autoCCL, 'isshow', 1, 'save', 'Man1_AutoCCL.csv');
%
% Important Note:
% 	The segmented ROI has to have value 0 (black), while the background is 1 (white)
%




%% Initializing
% Get size
[W, H, N] = size(refSet);

%
p = inputParser;

%
defaultShow = 0;
defaultSave = 0;
defaultSample = 0;
defaultPrint = 0;
islowerthanN = @(x) x<=N;

%
addParameter(p, 'isshow', defaultShow, @isnumeric)
addParameter(p, 'isprint', defaultPrint, @isnumeric)
addParameter(p, 'save', defaultSave, @isstr)
addParameter(p, 'sample', defaultSample, islowerthanN)

%
parse(p, varargin{:})

% Check if dimensions of two group identical (latter)


% Initializing Output
coefficients = table();

%% Comparing
for i = 1:N
    ref = refSet(:,:,i);
    seg = segSet(:,:,i);
    coefficients = [coefficients; similaritycompareSingle(ref, seg, 'ID', i)];
end

%% Post-processing
% Expand
ID = table2array(coefficients(:, 1));
J = table2array(coefficients(:, 2));
C = table2array(coefficients(:, 3));
stv = table2array(coefficients(:, 4));
spf = table2array(coefficients(:, 5));
sbl = table2array(coefficients(:, 6));

% Print average
if p.Results.isprint
    fprintf('Jaccard Coefficient: %.2f %s %.2f\n', 100*mean(J), char(177), 100*std(J));
    fprintf('Conformity Coefficient: %.2f %s %.2f\n', 100*mean(C), char(177), 100*std(C));
    fprintf('Sentivity: %.2f %s %.2f\n', 100*mean(stv), char(177), 100*std(stv));
    fprintf('Specificity: %.2f %s %.2f\n', 100*mean(spf), char(177), 100*std(spf));
    fprintf('Sensibility: %.2f %s %.2f\n', 100*mean(sbl), char(177), 100*std(sbl));
end

% Show 
if p.Results.isshow
    figure; plot(ID, J, ID, C, ID, stv, ID, spf, ID, sbl)
    axis([1 30 0.5 1.2]); grid on; legend('Jaccard', 'Conformity', 'Sensitivity', 'Specificity', 'Sensibility');
end

% Display a sample
if p.Results.sample
    k = p.Results.sample;
    
    ref = refSet(:,:,k);
    seg = segSet(:,:,k);
    
    fprintf('Result for sample No. %d\n', k);
    similaritycompareSingle(ref, seg, 'ID', k, 'isshow', 1, 'isprint', 1);
end

% 
if p.Results.save
    writetable(coefficients, p.Results.save)
end

