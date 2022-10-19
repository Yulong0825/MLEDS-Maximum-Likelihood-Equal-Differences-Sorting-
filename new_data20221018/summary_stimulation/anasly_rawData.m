%% --------Maximum Likelihood Equal Differences Sorting----------
%-------------------------------------------------------------------
% File: anasly_rawData.m 
% Version: Matlab R2021a
% Name:  Yulong Liu
% Create  Date: 2017/11/15
% Revised Data: 2021/07/25
% Experiment: caculate mean/error/perecent error for subject.
% Desc: Program about psycholinguistics.
% Usage: Input the name of filelist.(allsun_sigma.csv; Example w21.csv) 
%        Input the dara format
%        row1~8:(22:2:26)~(22:2:40)
%        stimulation sub ture sigma:row 9
%-------------------------------------------------------------------
clear
%input data
 rawData=csvread('allsun_sigma.csv');
[row_trials, colom_stimuli]=size(rawData);


 
%% -------- analysis data--------------------
%mean
mean_data=[];
% mean_data1=[];
mid_data=0;
bis_index=0;
for stims=1:colom_stimuli
    mean_data1=[];
    for trls=1:row_trials
        if rawData(trls,stims)~=0
            bis_index=bis_index+1;
        else
            bis_index=bis_index;
        end
        mid_data=rawData(trls,stims)+mid_data;
        if mod(trls,10)==0
            mid_data=mid_data/bis_index;
            mean_data1 =[mean_data1;mid_data];
            mid_data=0;
            bis_index=0;
        end
    end
    mean_data=[mean_data,mean_data1]
end
%------------------------------------------------
%Error
[row_sub, colom_stimuli1]=size(mean_data);
error_data=[];

for subs=1:row_sub
    emid_data=0;
    error_cdata=[];
    for col=1:8
        emid_data=mean_data(subs,col)-mean_data(subs,9);
        error_cdata=[error_cdata,emid_data];
    end
    error_data=[error_data;error_cdata];    
end

%------------------------------------------------
%Prec_Error

pre_error=-[];
for subs=1:row_sub
    prec_error=[];
    midc=0;
    for co=1:8
        midc=error_data(subs,co)/mean_data(subs,9);
        prec_error=[prec_error,midc];
    end
    pre_error=[pre_error;prec_error];
end


% for ll=1:subs
%     midx=1:9;
%     if ll==1
%         x=midx ;
%     else
%         x=[x;midx];
%     end
% end
% 
% 
% for lm=1:subs
%     midx1=1:8;
%     if lm==1
%         x1=midx1 ;
%     else
%         x1=[x1;midx1];
%     end
% end
csvwrite('mean_data.csv',mean_data);
csvwrite('error_data.csv',error_data);
csvwrite('pre_error.csv',pre_error);





