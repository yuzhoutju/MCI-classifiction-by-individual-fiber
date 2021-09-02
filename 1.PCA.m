% Put the file in the mat matrix directory
clc;clear all

%%
% Reading file 
% https://www.mathworks.com/help/matlab/files-and-folders.html  (Files and folders)
List=dir(pwd);List(1:2,:)=[];
% File filtering, only keep the '.mat' suffix
for i=size(List,1):-1:1
    if List(i).name(end-2:end)~='mat'
        List(i,:)=[];
    end
end
FileC=size(List,1);
%%
% PCA
% Storage in 'Res'
% 'PriAccC' is the number of files2 matrix, the first row represents the number of principal components retained, and the second row represents the percentage of variance explained by these principal components
% 'LastNum' is the number of data points for each fiber tract
% 'Res' is 96 the number of principal components 42, which represents the result of the original data after PCA
PriAccC=zeros(FileC,2);LastNum=zeros(FileC,1);
Res=zeros(96,30,FileC);
for TC=1:FileC
    load(List(TC).name);
    A=A';
    LastNum(FileC)=size(A,1); % fiber tract data points
    [coeff, score, latent, tsquared, explained, mu] = pca(A');
    tot=explained(1);cnt=1;
    while tot<95            %95 percent is the threshold
        tot=tot+explained(cnt+1);
        cnt=cnt+1;
    end
    PriAccC(TC,1)=cnt;PriAccC(TC,2)=tot; %Calculate the number of PCA principal components
    
    % PCA dimensionality reduction results
    for j=1:30
        aTemp=coeff(:,j)'*A;
        Res(:,j,TC)=aTemp; %Calculate the PCA result
    end
    
end
save('D:\SVM label\ADCindexindex.mat','PriAccC');
save('D:\SVM label\ADC.mat','Res');
