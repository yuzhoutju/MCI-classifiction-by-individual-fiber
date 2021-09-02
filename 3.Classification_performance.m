%Figure plot for performance of SVM
clear all
clc
folder_path = ['D:\SVM label\ADCeva'];
folders=dir(folder_path);
ADCevaluation=[];
for fib=9
fibname=[folder_path,'\',folders(fib+2).name];
figname=['D:\SVM label\ADCfig\',folders(fib+2).name];
figname1=strrep(figname,'.mat','_ROC');
figname2=strrep(figname,'.mat','_Spe');
load(fibname);
TP=[];
FN=[];
FP=[];
TN=[];
Sen=[];
Spe=[];
TPR=[];
FPR=[];
Sum_TP=evaluation(:,:,1);
Sum_FN=evaluation(:,:,2);
Sum_FP=evaluation(:,:,3);
Sum_TN=evaluation(:,:,4);
TP=sum(Sum_TP,1);
FN=sum(Sum_FN,1);
FP=sum(Sum_FP,1);
TN=sum(Sum_TN,1);
for i=1:100
    Sen(i)=TP(i)/(TP(i)+FN(i));
    Spe(i)=TN(i)/(TN(i)+FP(i));
    TPR(i)=TP(i)/(TP(i)+FN(i));
	FPR(i)=FP(i)/(FP(i)+TN(i));
end
Sum_TP=[];
Sum_FN=[];
Sum_FP=[];
Sum_TN=[];
sumA = [Sen' Spe'];
sum1 = sortrows(sumA);
AUC=0;
for mm=1:99
    AUC = AUC+0.01*((sum1(mm+1,2)+sum1(mm,2)))/2;
end

ACC=evaluation(:,50,10);
me=mean(ACC);
v=var(ACC);
st=std(ACC);
ADCevaluation(fib,1)=AUC;
ADCevaluation(fib,2)=me;
ADCevaluation(fib,3)=st;
ADCevaluation(fib,4)=v;

%ROC of TPR-FPR
% fig1=figure(1);
% plot(FPR,TPR,'k-','LineWidth',6);
% xlabel('FPR');
% ylabel('TPR');
% acctitle=['AUC=',num2str(AUC)];
% title(acctitle);
% set(gca,'xtick',[0:0.2:1]); 
% set(gca,'ytick',[0:0.2:1]);
% axis([0 1 0 1]);
% set(fig1, 'PaperPositionMode', 'manual');
% set(fig1, 'PaperUnits', 'points');
% set(fig1, 'PaperPosition', [0 0 800 800]);
% saveas(fig1,figname1,'tif');
% saveas(fig1,figname1,'pdf');
% saveas(fig1,figname1,'fig');

%ROC of Specificity-Sensitivity 
fig2=figure(2);
plot(Sen,Spe,'b-','LineWidth',1);
xlabel('Sen');
ylabel('Spe');
acctitle=['AUC=',num2str(AUC)];
title(acctitle);
set(gca,'xtick',[0:0.2:1]); 
set(gca,'ytick',[0:0.2:1]);
axis([0 1 0 1]);
set(fig2, 'PaperPositionMode', 'manual');
set(fig2, 'PaperUnits', 'points');
set(fig2, 'PaperPosition', [0 0 800 800]);
saveas(fig2,figname2,'tif');
saveas(fig2,figname2,'pdf');
saveas(fig2,figname2,'fig');
end
%matlocal=['D:\SVM label\ADCevaluation.mat'];
%save(matlocal,'ADCevaluation');
