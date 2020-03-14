
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The script
% 1. After make a dataset such as H0 and H1, know called H0 and H1
%  To extract the the feature
% 2.By default we used to SPAM686.M fore feature computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all

% Read the Path of H0 and H1
% changed
H0 = 'F:\Mauro\NewSimulations\ADVERSARY UN-AWARE\H0\';
H1 = 'F:\Mauro\NewSimulations\ADVERSARY UN-AWARE\H1\';


%----------------------------------------------------------
%            1. Feature Computation CRSPAM
%----------------------------------------------------------

H0 = computeAllFeatures(H0);
H1 = computeAllFeatures(H1);


save('CRSPAM_features_H0_H1_TIFF.mat', 'H0', 'H1');


