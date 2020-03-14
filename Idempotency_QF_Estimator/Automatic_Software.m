clc
clear
close all

% -------------------------------------------------------------------------

for i=80:100
    
    i
    tic;
    
    %-------------------------------------------------------------------------
    %    Read The Images From File separatly (From QF80 till QF100)- H1
    %-------------------------------------------------------------------------
    
    Dataset_H=sprintf('E:/EhsanNowroozi/Matlab/Features/Test_QF%d_CRSPAM_Matlab/H1/',i);
    jpg_images=dir([Dataset_H '*.jpg']);
    N=size(jpg_images,1);   %chosse 1997 images (Raise8k from 6001 till 7997)
      
          
    %------------------------------------------------------------------------
    %                        Load Features
    %------------------------------------------------------------------------
    
    load_name=strcat('Test_QF', num2str(i), '_CRSPAM_Matlab_features_H0_H1','.mat');
    load(load_name,'H0','H1');
    
    %-------------------------------------------------------------------------
    %                        Quality Factor Estimation
    %-------------------------------------------------------------------------
    
    
    for j=1:N
        
        img_name=[Dataset_H jpg_images(j).name];
        Img=imread(img_name);
        [QF(j),~]=QF_Estimator(Img,70);
    end
    
    QF_name=strcat('QF', num2str(i), '.mat');
    save(QF_name,'QF');
    
    %-----------------------------------------------------------------------
    %                       Find The Closest QF
    %-----------------------------------------------------------------------
    
    %search the members of QF estimator output
    for jj=1:N
        if  (QF(jj)<=82)
            QF_Closest= 80;
        elseif (QF(jj)>=83) && (QF(jj)<=86)
            QF_Closest= 85;
        elseif (QF(jj)>=87) && (QF(jj)<=92)
            QF_Closest= 90;
        elseif (QF(jj)>=93) && (QF(jj)<=96)
            QF_Closest= 95;
        elseif (QF(jj)>=97) && (QF(jj)<=100)
            QF_Closest= 98;
        else
            disp('Error In Part of Finding The Closest QF !!!!!');
        end
    end
    
    clear QF
    %-----------------------------------------------------------------------
    %               Test the Images from QF 80 till 100
    %-----------------------------------------------------------------------
    switch QF_Closest
        case 80
            load('model_2C_CRSPAM_SVM80','model_2C_CRSPAM_SVM80');
            data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
            data_H1_matrix = zeros(size(H1.features,2),numel(H1.features{1,1}));
            
            
            for ii=1:size(H0.features,2)
                data_H0_matrix(ii,:) = H0.features{1,ii};
            end
            for ii=1:size(H1.features,2)
                data_H1_matrix(ii,:) = H1.features{1,ii};
            end
            
            AUC= AUC_Calc (data_H0_matrix,data_H1_matrix,model_2C_CRSPAM_SVM80);
            
            AUC_name=strcat('AUC', num2str(i), '.mat');
            save(AUC_name,'AUC');
            
            
            clear H0 H1 AUC data_H0_matrix data_H1_matrix
            
        case 85
            load('model_2C_CRSPAM_SVM85','model_2C_CRSPAM_SVM85');
            data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
            data_H1_matrix = zeros(size(H1.features,2),numel(H1.features{1,1}));
            
            
            for ii=1:size(H0.features,2)
                data_H0_matrix(ii,:) = H0.features{1,ii};
            end
            for ii=1:size(H1.features,2)
                data_H1_matrix(ii,:) = H1.features{1,ii};
            end
            
            AUC= AUC_Calc (data_H0_matrix,data_H1_matrix,model_2C_CRSPAM_SVM85);
            
            AUC_name=strcat('AUC', num2str(i), '.mat');
            save(AUC_name,'AUC');
            
            clear H0 H1 AUC data_H0_matrix data_H1_matrix
            
        case 90
            load('model_2C_CRSPAM_SVM90','model_2C_CRSPAM_SVM90');
            data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
            data_H1_matrix = zeros(size(H1.features,2),numel(H1.features{1,1}));
            
            
            for ii=1:size(H0.features,2)
                data_H0_matrix(ii,:) = H0.features{1,ii};
            end
            for ii=1:size(H1.features,2)
                data_H1_matrix(ii,:) = H1.features{1,ii};
            end
            
            AUC= AUC_Calc (data_H0_matrix,data_H1_matrix,model_2C_CRSPAM_SVM90);
            
            AUC_name=strcat('AUC', num2str(i), '.mat');
            save(AUC_name,'AUC');
            
            clear H0 H1 AUC data_H0_matrix data_H1_matrix
            
        case 95
            load('model_2C_CRSPAM_SVM95','model_2C_CRSPAM_SVM95');
            data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
            data_H1_matrix = zeros(size(H1.features,2),numel(H1.features{1,1}));
            
            
            for ii=1:size(H0.features,2)
                data_H0_matrix(ii,:) = H0.features{1,ii};
            end
            for ii=1:size(H1.features,2)
                data_H1_matrix(ii,:) = H1.features{1,ii};
            end
            
            AUC= AUC_Calc (data_H0_matrix,data_H1_matrix,model_2C_CRSPAM_SVM95);
            
            AUC_name=strcat('AUC', num2str(i), '.mat');
            save(AUC_name,'AUC');
            
            clear H0 H1 AUC data_H0_matrix data_H1_matrix
            
        case 98
            load('model_2C_CRSPAM_SVM98','model_2C_CRSPAM_SVM98');
            data_H0_matrix = zeros(size(H0.features,2),numel(H0.features{1,1}));
            data_H1_matrix = zeros(size(H1.features,2),numel(H1.features{1,1}));
            
            for ii=1:size(H0.features,2)
                data_H0_matrix(ii,:) = H0.features{1,ii};
            end
            
            for ii=1:size(H1.features,2)
                data_H1_matrix(ii,:) = H1.features{1,ii};
            end
            
            AUC= AUC_Calc (data_H0_matrix,data_H1_matrix,model_2C_CRSPAM_SVM98);
            
            AUC_name=strcat('AUC', num2str(i), '.mat');
            save(AUC_name,'AUC');
            
            clear H0 H1 AUC data_H0_matrix data_H1_matrix
            
            
        otherwise
            disp('Decision Error In Switch Case !!!!')
    end
    
    t=toc;
    fprintf('Elapsed: %.3f sec.\n',t);    
end

%----------------------------------------------------------------------------------------
%                              Plot for All AUCs
%----------------------------------------------------------------------------------------
AUC_array= zeros(1,21);
for i=80:100
    idx=i-80+1;
    VarName=strcat('AUC',num2str(i),'.mat');
    load(VarName);
    AUC_array(idx)=AUC;
end

x=[80:100];
y=[AUC_array];

plot(x,y,'k*-');xlabel('Quality Factors'); ylabel('AUC'); title(sprintf('Matlab H1 Images \n Test With Nearest SVMs'));
xlim([80 100])