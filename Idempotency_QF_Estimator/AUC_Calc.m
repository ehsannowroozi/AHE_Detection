function [ AUC_2C ] = AUC_Calc( data_H0_matrix,data_H1_matrix,model )

addpath(genpath('./libsvm-3.17'));


% %              te_2C = 1001:1997; %1997 for testing
% %              Ntest_2C = 997;
             

             te_2C = 1:1997; %1997 for testing
             Ntest_2C = 1997;

             testLabel_2C = [ones(1,Ntest_2C), -1*ones(1,Ntest_2C)]';
             testData_2C = [data_H0_matrix(te_2C,:); data_H1_matrix(te_2C,:)];

             % Test
             [~,~, decision_2C] = svmpredict(testLabel_2C, testData_2C, model, ' -b 0');
             
             minn=min(decision_2C(1998:3994,:));
             maxx=max(decision_2C(1:1997,:));
             
             stepS=linspace(minn,maxx,100);

             K=1;
             TP = zeros(K,numel(stepS));
             FP = zeros(K,numel(stepS));
 
%             pe = decision_2C(1:997,:);
%             pe1 = decision_2C(998:1994,:);

              pe = decision_2C(1:1997,:);
             pe1 = decision_2C(1998:3994,:);
            
      
            for t=1:numel(stepS)
               TP(t) = sum(pe>stepS(t))/1997;
               FP(t) = sum(pe1>stepS(t))/1997;
               
               
            end
 
             AUC_2C = abs(trapz(FP,TP));

end

