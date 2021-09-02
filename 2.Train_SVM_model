
%%Clear environment variables 
clear all
clc
folder_path = ['D:\SVM label\ADC'];
folders=dir(folder_path);
for fib=1:28
fibname=[folder_path,'eva\',folders(fib+2).name];
%The storage mat of the external random 100 holdout method evaluation indicators, initialized to all 0
evaluation=[];
load('ADC.mat');
load('ADCindex.mat');
matrix=Res(:,1:PriAccC(fib,1),fib);
for R=1:100
NC=matrix(1:54,:);
MCI=matrix(55:96,:);
NC=[ones(54,1) NC];
MCI=[zeros(42,1) MCI];
Nr=randperm(54);
Mr=randperm(42);
n1=NC(Nr(1:44),:);
n2=NC(Nr(45:end),:);
m1=MCI(Mr(1:34),:);
m2=MCI(Mr(35:end),:);
train=[n1;m1];
test=[n2;m2];
Tr=randperm(78);
Te=randperm(18);
train_matrix=train(Tr(1:78),2:end);
train_label=train(Tr(1:78),1);
test_matrix=test(Te(1:18),2:end);
test_label=test(Te(1:18),1);


%% Data normalization
[Train_matrix,PS] = mapminmax(train_matrix');
Train_matrix = Train_matrix';
Test_matrix = mapminmax('apply',test_matrix',PS);
Test_matrix = Test_matrix';

%% SVM creation/training (RBF kernel function)

% Search for the best c/g parameter(5 fold cross-validation method)
[c,g] = meshgrid(-10:0.2:10,-10:0.2:10);
[m,n] = size(c);
cg = zeros(m,n);
eps = 10^(-4);
v = 5;
bestc = 1;
bestg = 0.1;
bestacc = 0;
for i = 1:m
    for j = 1:n
        cmd = ['-v ',num2str(v),' -t 2',' -c ',num2str(2^c(i,j)),' -g ',num2str(2^g(i,j))];
        cg(i,j) = svmtrain(train_label,Train_matrix,cmd);     
        if cg(i,j) > bestacc
            bestacc = cg(i,j);
            bestc = 2^c(i,j);
            bestg = 2^g(i,j);
        end        
        if abs( cg(i,j)-bestacc )<=eps && bestc > 2^c(i,j) 
            bestacc = cg(i,j);
            bestc = 2^c(i,j);
            bestg = 2^g(i,j);
        end               
    end
end
cmd = [' -t 2',' -c ',num2str(bestc),' -g ',num2str(bestg),' -b 1'];
% Creation/training for SVM model
model = svmtrain(train_label,Train_matrix,cmd);

%% SVM simulation test
[predict_label_1,accuracy_1,prob_estimates_1] = svmpredict(train_label,Train_matrix,model,' -b 1');
[predict_label_2,accuracy_2,prob_estimates_2] = svmpredict(test_label,Test_matrix,model,' -b 1');
result_1 = [train_label predict_label_1];
result_2 = [test_label predict_label_2];

%% Determining for the probability of a positive sample
if (predict_label_2(1,1)==1&&prob_estimates_2(1,1)>=0.5)||(predict_label_2(1,1)==0&&prob_estimates_2(1,1)<0.5)
num=1
else
num=2
end

  
    for T=1:1:100%Step size%
        TP=0;
        FN=0;
        FP=0;
        TN=0;

        for k=1:18%Number of samples
            if test_label(k)==1&&prob_estimates_2(k,num)>=T/100 %This is a positive class, and it is predicted to be a positive class if it is greater than or equal to T
                TP=TP+1;
            elseif test_label(k)==1&&prob_estimates_2(k,num)<T/100 %This is a positive class, and it is predicted to be a negative class if it is less than T
                FN=FN+1;
            elseif test_label(k)==0&&prob_estimates_2(k,num)>=T/100 %This is a negative class, and it is predicted to be a positive class if it is greater than or equal to T
                FP=FP+1;
            elseif test_label(k)==0&&prob_estimates_2(k,num)<T/100 %This is a negative class, and it is predicted to be a negative class if it is less than T
                TN=TN+1;
            end
        end
        TP
        FN
        FP
        TN
        Sen=TP/(TP+FN);
        Spe=TN/(TN+FP);
        TPR=TP/(TP+FN);
		FPR=FP/(FP+TN);
        Acc=(TP+TN)/(TP+TN+FP+FN);
        evaluation(R,T,1)=TP;
        evaluation(R,T,2)=FN;
        evaluation(R,T,3)=FP;
        evaluation(R,T,4)=TN;
		evaluation(R,T,5)=Sen;
        evaluation(R,T,6)=Spe;
        evaluation(R,T,7)=TPR;
        evaluation(R,T,8)=FPR;
        evaluation(R,T,9)=Acc;
		evaluation(R,T,10)=accuracy_2(1,1);
    end
end
save(fibname,'evaluation');
end

