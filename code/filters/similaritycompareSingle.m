function coefficientsSingle = similaritycompareSingle(ref, seg, varargin)
%% SIMILARITYCOMPARE compare similarity between 2 images
% Input:
% 	ref 	<M x N>: referece segmented ROI, 0: 1 segmented pixel, 1: non-segment pixel
% 	seg 	<M x N>: segmented ROI needing comparision
% Output
%   coefficiences: a table includes
%       J       Vector of k Jaccard coeffcients 
%       C       Conformity coeffcients 
%       stv     Sensitivity coeffcients 
%       spf     Specificity coeffcients 
%       sbl     Sensibility coeffcients 
% Optional:
%   isshow  <logical>:  show overlapping color image, TP, TN, FP, FN images
%
% Example:
%   similaritycompareSingle(manual1, autoCCL, 10, 'isshow', 1, 'isprint', 1);
%
% Important Note:
% 	The segmented ROI has to have value 0 (black), while the background is 1 (white)
%



%% Checking things
%
p = inputParser;

%
defaultShow = 0;
defaultPrint = 0;
defaultID = 0;

%
addParameter(p, 'isshow', defaultShow, @isnumeric)
addParameter(p, 'isprint', defaultPrint, @isnumeric)
addParameter(p, 'ID', defaultID, @isnumeric)


%
parse(p, varargin{:})

if p.Results.ID ~= defaultID
    ID = p.Results.ID;
else
    ID = defaultID;
end

%% Re-Scale input
% ref = double(ref);
% seg = double(seg);
% 
% ref = ceil(ref/max(ref(:)));
% seg = ceil(seg/max(seg(:)));
% 
% ref = imcomplement(ref);
% seg = imcomplement(seg);


%% Comparing   
% Calculate intersection and union
inter = ref.*seg;
union = ref + seg - inter;

%
TP = inter;                 % True Possitive Region
TN = imcomplement(union);   % True Negative Region
FP = seg - inter;           % False Negative Region
FN = ref - inter;           % False Positive Region

% 
AllErr = sum(FP(:)) + sum(FN(:));           % All mis-segmented pixels
E = AllErr / sum(TP(:));      % Discrepancy-to-Concordance ratio (Whatever that means)
C = 1 - E;                  % Conformity coefficient
J = 1/(1+E);                % Jaccard coefficient

% 
stv = sum(TP(:))/(sum(TP(:)) + sum(FN(:))); 
spf = sum(TN(:))/(sum(TN(:)) + sum(FP(:)));  
sbl = 1- sum(FP(:))/(sum(TP(:)) + sum(FN(:)));  

%% Results
AllErrArea = AllErr*0.0055^2;
coefficientsSingle = table(ID, J, C, stv, spf, sbl, AllErrArea);

% Print average
if p.Results.isprint
    fprintf('Jaccard Coefficient: %.2f\n', 100*J);
    fprintf('Conformity Coefficient: %.2f\n', 100*C);
    fprintf('Sentivity: %.2f\n', 100*stv);
    fprintf('Specificity: %.2f\n', 100*spf);
    fprintf('Sensibility: %.2f\n', 100*sbl);
end

%%
if p.Results.isshow
    refrgb = cat(3, ref, zeros(size(ref)), zeros(size(ref)));   % red
    segrgb = cat(3, zeros(size(seg)), seg, zeros(size(seg)));           % Green
    merge = refrgb + segrgb;
    
    %
    figure('Color', 'w');
    imshow(merge(120:380, 130:380, :).*255);
    title(sprintf('Red: ref, Green: seg, Yellow: Intersection\nID: %d', ID));

    % TP, TN, FP, FN
    inter = ref.*seg;
    union = ref + seg - inter;
    
    %
    TP = inter;                 % True Possitive Region
    TN = imcomplement(union);   % True Negative Region
    FP = seg - inter;           % False Negative Region
    FN = ref - inter;           % False Positive Region
    
    figure('Color', 'w');
    subplot(2,2,1); imshow(TP,[]); title('True Positive');
    subplot(2,2,2); imshow(TN, []); title('True Negative');
    subplot(2,2,3); imshow(FP, []); title('False Positive (Over-segmented)');
    subplot(2,2,4); imshow(FN, []); title('False Negative (Mis-segmented)');
end



