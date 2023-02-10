clear 
home_dir = '/MYPATH/' 
code_dir = fullfile(home_dir,'code'); 
mkdir(code_dir); 
delete(sprintf('%s/*',code_dir)); 
fid0=fopen(sprintf('%s/All.sh',code_dir),'w'); 
fprintf(fid0,'#!/bin/bash \n');
for iii=1:48 
batNames = sprintf('%s/bat%i.pbs',code_dir,iii);
fid = fopen(batNames,'w');
fprintf(fid,'#!/bin/bash \n');
fprintf(fid,'#SBATCH --ntasks=1 \n');
fprintf(fid,'#SBATCH --time=19:59:59 \n');
fprintf(fid,'#SBATCH --mem=12000 \n');
fprintf(fid,'#SBATCH --wrap=mytask \n');
fprintf(fid,'cd MYPATH/ \n');
fprintf(fid,'module load r/4.1.0 \n');
fprintf(fid,'R CMD BATCH --no-save --no-restore %s/bat%i.r %s/bat%i.out\n',code_dir,iii,code_dir,iii); 
fclose(fid); 
fprintf(fid0,'sbatch bat%i.pbs\n',iii);
batNames = sprintf('%s/bat%i.r',code_dir,iii);
fid = fopen(batNames,'w');
fprintf(fid,'iii=1 \n');
fprintf(fid,'iii=%i \n',iii);
fprintf(fid,'method.list = c("glmnet", "svmLinear", "rf", "xgbTree", "lda2","nnet","glmboost","hdda")    \n');
fprintf(fid,'vecT=expand.grid(c(1,3,4,5,6,7),1:8)    \n');
fprintf(fid,'i1=vecT[iii,1]    \n');
fprintf(fid,'i2=vecT[iii,2]    \n');
fprintf(fid,'library(caret)    \n');
fprintf(fid,'library(glmnet)    \n');
fprintf(fid,'library(Matrix)    \n');
fprintf(fid,'library(qqman)    \n');
fprintf(fid,'library(MLmetrics)    \n');
fprintf(fid,'library(ggplot2) # Data visualization    \n');
fprintf(fid,'library(data.table)    \n');
fprintf(fid,'library(caret)    \n');
fprintf(fid,'library(LiblineaR)    \n');
fprintf(fid,'library(xgboost)    \n');
fprintf(fid,'library(lightgbm)    \n');
fprintf(fid,'library(MASS)    \n');
fprintf(fid,'options(scipen=999)    \n');
fprintf(fid,'library(data.table)    \n');
fprintf(fid,'if(!require("kernlab"))install.packages("kernlab",repos = "http://cran.us.r-project.org")    \n');
fprintf(fid,'library(pls)    \n');
fprintf(fid,'library(randomForest)    \n');
fprintf(fid,'A=read.csv("TMJOAI_Long_040422_Norm.csv",check.names = FALSE)    \n');
fprintf(fid,'y=A[,1]    \n');
fprintf(fid,'X=A[,-1] \n');
fprintf(fid,'Nfold=10    \n');
fprintf(fid,'N=10    \n');
fprintf(fid,'seed0=2022    \n');
fprintf(fid,'set.seed(seed0)    \n');
fprintf(fid,'foldsCVT <- createFolds(factor(y)[-(1:40)], k=Nfold, list=TRUE, returnTrain=FALSE)    \n');
fprintf(fid,'train.control <- trainControl(method = "cv", number = 10, # k-folds CV with k=10    \n');
fprintf(fid,'                              classProbs = TRUE,    \n');
fprintf(fid,'                              savePredictions = TRUE,    \n');
fprintf(fid,'                              summaryFunction = multiClassSummary)# save predictions for ROC    \n');
fprintf(fid,'predYT=matrix(NA,length(y),1)  \n');
fprintf(fid,'Shap=matrix(0,length(y),dim(X)[2]);colnames(Shap)= colnames(X)   \n');
fprintf(fid,'select=rep(NA,10)    \n');
fprintf(fid,'predYT_valid=matrix(NA,length(y),10)    \n');
fprintf(fid,'for(ii in 1:Nfold)    \n');
fprintf(fid,'{    \n');
fprintf(fid,'	print(Nfold-ii)    \n');
fprintf(fid,'	indtempT=foldsCVT[[ii]]+40    \n');
fprintf(fid,'	y0=y[-indtempT]    \n');
fprintf(fid,'	X0=X[-indtempT,]    \n');
fprintf(fid,'	X1=X[indtempT,]    \n');
fprintf(fid,'	p=dim(X0)[2]    \n');
fprintf(fid,'	training.set=as.data.frame(cbind(factor(paste0("X",y0)),X0));colnames(training.set)[1]="Y"    \n');
fprintf(fid,'	test.set=as.data.frame(X1)    \n');
fprintf(fid,'	#W0=table(training.set$Y)/sum(table(training.set$Y));w0=training.set$Y;w00=rep(NA,length(w0));w00[w0==names(W0)[1]]=W0[2];w00[w0==names(W0)[2]]=W0[1];    \n');
fprintf(fid,'	if(i1==1){  \n');
fprintf(fid,'		fea=matrix(NA,dim(X)[2],Nfold*N);rownames(fea)=colnames(X)   	 \n');
fprintf(fid,'		kk=1    \n');
fprintf(fid,'		predY=matrix(NA,length(y0),10)    \n');
fprintf(fid,'		for(seed1 in 2020:(2020+N-1))    \n');
fprintf(fid,'		{    \n');
fprintf(fid,'			if(seed1%%%%50==0)print(c((2020+N-1)-seed1,Nfold-ii))    \n');
fprintf(fid,'			set.seed(seed1)    \n');
fprintf(fid,'			foldsCV <- createFolds(factor(y0)[-(1:40)], k=Nfold, list=TRUE, returnTrain=FALSE)    \n');
fprintf(fid,'			for(i in 1:Nfold)    \n');
fprintf(fid,'			{    \n');
fprintf(fid,'				indtemp=foldsCV[[i]]+40    \n');
fprintf(fid,'				Y1=y0[-indtemp]    \n');
fprintf(fid,'				X.fea0=X0[-indtemp,]    \n');
fprintf(fid,'				p=dim(X.fea0)[2]    \n');
fprintf(fid,'				cv0=cv.glmnet(as.matrix(X.fea0),factor(Y1),family="binomial",alpha=1)    \n');
fprintf(fid,'				lamb0=cv0$lambda.min    \n');
fprintf(fid,'				mod0=glmnet(as.matrix(X.fea0),factor(Y1),family="binomial",alpha=1,lambda=lamb0)    \n');
fprintf(fid,'				fea[,kk]=mod0[[2]][,1]    \n');
fprintf(fid,'				kk=kk+1    \n');
fprintf(fid,'				predY[indtemp,seed1-2019]=predict(mod0,as.matrix(X[indtemp,]))    \n');
fprintf(fid,'			}    \n');
fprintf(fid,'		}    \n');
fprintf(fid,'		score=apply(fea!=0,1,mean)    \n');
fprintf(fid,'		score=sort(score,decreasing=T)    \n');
fprintf(fid,'	}    \n');
fprintf(fid,'	if((i1<=5)&(i1!=1)){    \n');
fprintf(fid,'	model0 = train(Y~.,data = training.set,method = method.list[i1],trControl = train.control,verbosity=0)}    \n');
fprintf(fid,'	if(i1==6){    \n');
fprintf(fid,'	model0 = train(Y~.,data = training.set,method = method.list[i1],center = TRUE)}    \n');
fprintf(fid,'	if(i1>6){    \n');
fprintf(fid,'	model0 = train(Y~.,data = training.set,method = method.list[i1],trControl = train.control)}    \n');
fprintf(fid,'	if(i1!=1){    \n');
fprintf(fid,'		rfImp <- varImp(model0, scale = T);ind00=sort(-as.matrix(round(rfImp[[1]][,1],3)),ind=T)$ix;   \n');
fprintf(fid,'		tempp=t(t(as.matrix(round(rfImp[[1]],3))[ind00,]));rownames(tempp)=gsub("\\\\\\\\","",gsub("`","",rownames(tempp)))  \n');
fprintf(fid,'		tempp=t(t(tempp[unique(rownames(tempp)),])) \n');
fprintf(fid,'		write.table(tempp,file=paste0("imp/",method.list[i1],"_",ii,".txt"),quote=F,col.names=F)    \n');
fprintf(fid,'		score=tempp[,1];names(score)=gsub("\\\\\\\\","",gsub("`","",names(score)))  \n');
fprintf(fid,'	}  \n');
fprintf(fid,'	if(i1==1){    \n');
fprintf(fid,'	write.table(t(t(score)),file=paste0("imp/",method.list[i1],"_",ii,".txt"),quote=F,col.names=F)    \n');
fprintf(fid,'	}    \n');
fprintf(fid,'	selectT=c(5,10,15,20)    \n');
fprintf(fid,'	selectL=length(selectT)    \n');
fprintf(fid,'	AUCT=rep(NA,length(selectT))    \n');
fprintf(fid,'	for(jj in 1:length(selectT)){    \n');
fprintf(fid,'	if(i2<=5){model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:selectT[jj]])],method = method.list[i2],trControl = train.control,verbosity=0)}    \n');
fprintf(fid,'	if(i2==6){model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:selectT[jj]])],method = method.list[i2],center = TRUE)}    \n');
fprintf(fid,'	if(i2>6){model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:selectT[jj]])],method = method.list[i2],trControl = train.control)}    \n');
fprintf(fid,'	AUCT[jj]=max(model0[[4]]$AUC)}    \n');
fprintf(fid,'	select[ii]=selectT[which.max(AUCT)]    \n');
fprintf(fid,'	for(jj in setdiff(1:10,ii)){    \n');
fprintf(fid,'		indvalidT=foldsCVT[[jj]]+40    \n');
fprintf(fid,'		y0_valid=y[-c(indtempT,indvalidT)]    \n');
fprintf(fid,'		X0_valid=X[-c(indtempT,indvalidT),]    \n');
fprintf(fid,'		X1_valid=X[indvalidT,]    \n');
fprintf(fid,'		training.set1=as.data.frame(cbind(factor(paste0("X",y0_valid)),X0_valid));colnames(training.set1)[1]="Y"    \n');
fprintf(fid,'		valid.set=as.data.frame(X1_valid)    \n');
fprintf(fid,'		if((i2<=5)&(i2!=1)){    \n');
fprintf(fid,'		model0 = train(Y~.,data = training.set1[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],trControl = train.control,verbosity=0)}    \n');
fprintf(fid,'		if(i2==6){model0 = train(Y~.,data = training.set1[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],center = TRUE)}    \n');
fprintf(fid,'		if(i2>6){model0 = train(Y~.,data = training.set1[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],trControl = train.control)}    \n');
fprintf(fid,'		if(i2!=1){predYT_valid[indvalidT,ii] <- round(as.numeric(predict(model0, valid.set,type="prob")[,2]),4)}    \n');
fprintf(fid,'		if(i2==1){    \n');
fprintf(fid,'			cv0=cv.glmnet(as.matrix(training.set1[,c(names(score)[1:select[ii]])]),training.set1[,"Y"],family="binomial",alpha=1)    \n');
fprintf(fid,'			lamb0=cv0$lambda.min    \n');
fprintf(fid,'			mod0 <- glmnet(as.matrix(training.set1[,c(names(score)[1:select[ii]])]),training.set1[,"Y"],family="binomial",alpha=1,lambda=lamb0)    \n');
fprintf(fid,'			temp111=exp(as.numeric(predict(mod0,as.matrix(valid.set[,c(names(score)[1:select[ii]])]))[,1]))    \n');
fprintf(fid,'			predYT_valid[indvalidT,ii]=round(temp111/(1+temp111),4)    \n');
fprintf(fid,'		}    \n');
fprintf(fid,'	}    \n');
fprintf(fid,'	if(i2==1){    \n');
fprintf(fid,'		cv0=cv.glmnet(as.matrix(training.set[,c(names(score)[1:select[ii]])]),training.set[,"Y"],family="binomial",alpha=1)    \n');
fprintf(fid,'		lamb0=cv0$lambda.min    \n');
fprintf(fid,'		mod0 <- glmnet(as.matrix(training.set[,c(names(score)[1:select[ii]])]),training.set[,"Y"],family="binomial",alpha=1,lambda=lamb0)    \n');
fprintf(fid,'		temp111=exp(as.numeric(predict(mod0,as.matrix(test.set[,c(names(score)[1:select[ii]])]))[,1]))    \n');
fprintf(fid,'		predYT[indtempT]=round(temp111/(1+temp111),4) \n');
fprintf(fid,'		for(jjj in 1:select[ii]){ \n');
fprintf(fid,'		datatemp=test.set;datatemp[,names(score)[jjj]]=0 \n');
fprintf(fid,'		temp000=as.numeric(predict(mod0,as.matrix(datatemp[,c(names(score)[1:select[ii]])]))[,1]) \n');
fprintf(fid,'		Shap[indtempT,names(score)[jjj]]=temp000-log(predYT[indtempT]/(1-predYT[indtempT]))} \n');
fprintf(fid,'	}    \n');
fprintf(fid,'	if((i2<=5)&(i2!=1)){    \n');
fprintf(fid,'	model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],trControl = train.control,verbosity=0)}    \n');
fprintf(fid,'	if(i2==6){model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],center = TRUE)}    \n');
fprintf(fid,'	if(i2>6){model0 = train(Y~.,data = training.set[,c("Y",names(score)[1:select[ii]])],method = method.list[i2],trControl = train.control)}    \n');
fprintf(fid,'    if(i2!=1){predYT[indtempT] <- round(as.numeric(predict(model0, test.set,type="prob")[,2]),4) \n');
fprintf(fid,'		predYT[indtempT]=pmin(pmax(predYT[indtempT],0.001),0.999) \n');
fprintf(fid,'		for(jjj in 1:select[ii]){  \n');
fprintf(fid,'		datatemp=test.set;datatemp[,names(score)[jjj]]=0 \n');
fprintf(fid,'		temp000=as.numeric(predict(model0, datatemp,type="prob")[,2]) \n');
fprintf(fid,'		temp000=pmin(pmax(temp000,0.001),0.999) \n');
fprintf(fid,'		Shap[indtempT,names(score)[jjj]]=log(temp000/(1-temp000))-log(predYT[indtempT]/(1-predYT[indtempT]))} \n');
fprintf(fid,'	} \n');
fprintf(fid,'}    \n');
fprintf(fid,'write.table(predYT,file=paste0("out/",method.list[i1],"_",method.list[i2],".txt"),quote=F,col.names=F,row.names=F)    \n');
fprintf(fid,'write.table(predYT_valid,file=paste0("out_valid/",method.list[i1],"_",method.list[i2],".txt"),quote=F,col.names=F,row.names=F)    \n');
fprintf(fid,'write.table(select,file=paste0("select/",method.list[i1],"_",method.list[i2],".txt"),quote=F,col.names=F,row.names=F)    \n');
fprintf(fid,'write.table(Shap,file=paste0("Shap/",method.list[i1],"_",method.list[i2],".txt"),quote=F,row.names=F) \n');
fclose(fid); 
end; 
fclose(fid0); 
clear all; 
