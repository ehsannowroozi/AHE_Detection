
clc
clear
close all

tic

% Add LIBSVM package
addpath(genpath('./Libsvm-3.17'));

% load the features already computed
load('CRSPAM_features_H0_H1_SVM80.mat');

%-------------------------------------------------------------------------------------------------------%
%               AWARE CASE: two awarness (2class SVM - only one negative class)
%-------------------------------------------------------------------------------------------------------%

% AWARNESS: select the processing type we wnat the SVM made aware of
Proc_Type1  = 'Adapthisteq';
malacious1 = H1;

data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
data_malacious1_matrix1 = zeros(size(malacious1.features,2),numel(H1.features{1,1}));


for i=1:size(H0.features,2)
    data_H0_matrix(i,:) = H0.features{1,i};
end

for i=1:size(H1.features,2)
    data_malacious1_matrix1(i,:) = malacious1.features{1,i};
end


%----------------------------------------------------------------------
% 0. Define the setup and prepare data
%----------------------------------------------------------------------

 Ntest_H0 = 1997;
 Ntest_H1 = Ntest_H0;


cv_idx_H0 = 1:1000;
cv_idx_H1 = cv_idx_H0;
tr_idx_H0 = 1001:6000;
tr_idx_H1 = tr_idx_H0;
te_idx_H0 = 6001:7997;
te_idx_H1 = te_idx_H0;

%----------------------------------------------------------------------
% 1. N-fold cross-validation
%----------------------------------------------------------------------


cross_labels = [ones(1,numel(cv_idx_H0)), -1*ones(1,numel(cv_idx_H1))]';

% Examples for cross-validation
cross_data = [data_H0_matrix(cv_idx_H0,:); data_malacious1_matrix1(cv_idx_H1,:)];

% Grid of parameters
folds = 5;
[C,gamma] = meshgrid(-5:2:15, -15:2:3);

% Grid search
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(cross_labels, cross_data, ...
        sprintf('-q -c %f -g %f -v %d', 2^C(i), 2^gamma(i), folds));
end

% Pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

% Contour plot of parameter selection
% % contour(C, gamma, reshape(cv_acc,size(C))), colorbar
% % hold on
% % plot(C(idx), gamma(idx), 'rx')
% % text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cv_acc(idx)), ...
% %    'HorizontalAlign','left', 'VerticalAlign','top')
% % hold off
% % xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')


%----------------------------------------------------------------------
% 2. Training model using best_C and best_gamma
%----------------------------------------------------------------------

bestc = 2^C(idx);
bestg = 2^gamma(idx);

% Training on images from each class not used in cross-validation
trainLabel = [ones(1,numel(tr_idx_H0)), -1*ones(1,numel(tr_idx_H1))]';
trainData = [data_H0_matrix(tr_idx_H0,:); data_malacious1_matrix1(tr_idx_H1,:)];

% Train (probabilistic model)
model_2C_CRSPAM_SVM80 = svmtrain(trainLabel, trainData, ['-c ' num2str(bestc) ' -g ' num2str(bestg) ' -b 0']);

%--------------------------------------------------------------------------
%                                     Testing
%--------------------------------------------------------------------------

% Clean training data
testLabel = [ones(1,Ntest_H0), -1*ones(1,Ntest_H1)]';
testData = [data_H0_matrix(te_idx_H0,:); data_malacious1_matrix1(te_idx_H1,:)];

% Test
[predict_label, accuracy, decision_function_LM_80] = svmpredict(testLabel, testData, model_2C_CRSPAM_SVM80, ' -b 0');

%----------------------------------------------------------------
%         True Positive and False Positive and AUC
%----------------------------------------------------------------

%%%%%%
Accuracy_Test=accuracy(1);
MSE_Test=accuracy(2);
Error_Probability=1-(accuracy(1)/100);
sprintf('Accuracy in testing part is: %f ',Accuracy_Test)
sprintf('Mean Square Error in testing part is: %f ',MSE_Test)
sprintf('Error Probability in testing part is: %f ',Error_Probability)
 
%Scatter PLot for Leg
figure;
scatter(1:1997,decision_function_LM_80(1:1997,:),'filled'); xlabel('Sample Count'); ylabel('Decision function');
hold on
%Scatter PLot for Mal
scatter(1:1997,decision_function_LM_80(1998:3994,:),'filled'); xlabel('Sample Count'); ylabel('Decision function'); 
legend('legitimate','Malicious');
% line
x=[0 1997];
y=[0 0];
plot(x,y)
%title(['Legitimate Versus Hist Stretching, Accuracy_Test:' Accuracy_Test ')']);
title(sprintf('Legitimate Versus Histogram Stretch (CRSPAM1372-SVM80) \n Error Probability %.4f ',Error_Probability));


% % % %--------------------------------------------------------
% % % % Auc and Roc Curve
% % % %--------------------------------------------------------

AUC=0;
min=min(decision_function_LM_80(1998:3994,:));
max=max(decision_function_LM_80(1:1997,:));
stepS=linspace(min,max,100);
% % stepS = 0:0.005:1;
 K=1;
 TP = zeros(K,numel(stepS));
 FP = zeros(K,numel(stepS));
 
     pe = decision_function_LM_80(1:1997,:);
     pe1 = decision_function_LM_80(1998:3994,:);
     
 for t=1:numel(stepS)
     TP(t) = sum(pe>=stepS(t))/1997;
     FP(t) = sum(pe1>=stepS(t))/1997;
 end
 
  AUC = abs(trapz(FP,TP));

 
 figure(),plot(FP,TP,'*-');xlabel('False Positive'); ylabel('True Positive');title(sprintf('SVM80 \n AUC: %.2f',abs(trapz(FP,TP))));

% % % %---------------------------------------------------------------------
% % % %                       Save The Results
% % % %---------------------------------------------------------------------
 
save(['Results_AWARE_' Proc_Type1 '_.mat'],'model_2C_CRSPAM_SVM80','H0','H1','malacious1', 'data_H0_matrix', ...
    'data_malacious1_matrix1', 'decision_function_LM_80','accuracy','Error_Probability','predict_label','AUC','TP','FP', ...
    'Ntest_H0','Ntest_H1', 'cv_idx_H0', 'cv_idx_H1', 'tr_idx_H0', 'tr_idx_H1', 'te_idx_H0', 'te_idx_H1')
decision_function_LM_80_CRSPAM=decision_function_LM_80;
save('decision_function_LM_80_CRSPAM')
save('model_2C_CRSPAM_SVM80')
% % % 
% % % 
t=toc;
fprintf('Elapsed Time: %.3f sec.\n',t);