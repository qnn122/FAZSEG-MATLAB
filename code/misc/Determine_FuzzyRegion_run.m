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
% 
% References:
%   Herng-Hua Chang, A. H.-C. (2009). Performance measure characterization for evaluating neuroimage. NeuroImage, 122-135

%% Load data
clear all, close all;
load('SegmentedRegion.mat');

% Initiation
N = size(manualAll,3);
K_C_All = zeros(N, 1);
K_J_All = zeros(N, 1);
n_stv_All = zeros(N, 1);    % Sensitivity
n_spf_All = zeros(N, 1);    % Specificity
n_sbl_All = zeros(N, 1);    % Sensibility

%% 
for k = 1:N;
    manual = manualAll(:,:,k);
    auto = autoAll(:,:,k);
    inter = interAll(:,:,k);    % intersection
    union = unionAll(:,:,k);    % union

    %
    TP = inter;                 % True Possitive Region
    TN = imcomplement(union);   % True Negative Region
    FP = auto - inter;          % False Negative Region
    FN = manual - inter;        % False Positive Region

    % Calculating metrics
    % 
    AllErr = FP + FN;   % All mis-segmented pixels
    E = sum(AllErr(:))/sum(TP(:));  % Discrepancy-to-Concordance ratio (Whatever that means)
    K_C_All(k) = 1 - E;        % Conformity coefficient
    K_J_All(k) = 1/(1+E);      % Jaccard coefficient

    % 
    n_stv_All(k) = sum(TP(:))/(sum(TP(:)) + sum(FN(:))); 
    n_spf_All(k) = sum(TN(:))/(sum(TN(:)) + sum(FP(:)));  
    n_sbl_All(k) = 1- sum(FP(:))/(sum(TP(:)) + sum(FN(:)));  
end

%% Results
ID = (1:N)';
Result = table(ID, K_J_All, K_C_All, n_stv_All, n_spf_All, n_sbl_All)

% Print average
fprintf('Jaccard Coefficient: %.2f\n', 100*mean(K_J_All));
fprintf('Conformity Coefficient: %.2f\n', 100*mean(K_C_All));
fprintf('Sentivity: %.2f\n', 100*mean(n_stv_All));
fprintf('Specificity: %.2f\n', 100*mean(n_spf_All));
fprintf('Sensibility: %.2f\n', 100*mean(n_sbl_All));

%%
figure; plot(ID, K_J_All, ID, K_C_All, ID, n_stv_All, ID, n_spf_All, ID, n_sbl_All)
axis([1 30 0.5 1.2]); grid on; legend('Jaccard', 'Conformity', 'Sensitivity', 'Specificity', 'Sensibility');

%% Visualization
SHOW = 1;
k = 2;
if SHOW  
    % Color presenation
    manual = manualAll(:,:,k);
    auto = autoAll(:,:,k);
    inter = interAll(:,:,k);    % intersection
    union = unionAll(:,:,k);    % union
    
    %
    manualrgb = cat(3, manual, zeros(size(manual)), zeros(size(manual)));   % red
    autorgb = cat(3, zeros(size(auto)), auto, zeros(size(auto)));           % Green
    merge = manualrgb + autorgb;
    
    %
    figure;
    imshow(merge(150:350, 150:350, :));
    title(sprintf('Red: Manual, Green: Auto, Yellow: Intersection\nID: %d', ID(k)));
    fprintf('ID = %d\n', ID(k));
    fprintf(   ['Jaccard Coefficient = %.3f\n',...
                'Conformity Coefficient = %.3f\n',...
                'Sensitivity = %.3f\n',...
                'Specificity = %.3f\n',...
                'Sensibility = %.3f\n'], K_J_All(k), K_C_All(k), n_stv_All(k), n_spf_All(k), n_sbl_All(k));
    
    % TP, TN, FP, FN
    inter = interAll(:,:,k);    % intersection
    union = unionAll(:,:,k);    % union
    %
    TP = inter;                 % True Possitive Region
    TN = imcomplement(union);   % True Negative Region
    FP = auto - inter;          % False Negative Region
    FN = manual - inter;        % False Positive Region
    figure;
    subplot(2,2,1); imshow(TP); title('True Positive');
    subplot(2,2,2); imshow(TN); title('True Negative');
    subplot(2,2,3); imshow(FP); title('False Positive (Over-segmented)');
    subplot(2,2,4); imshow(FN); title('False Negative (Mis-segmented)');

end


