%calculate the average sigma stimulus
% by Yulong LIU
%created date 2022-9-17
%function: stimulus sorting 

%%
clear all
%recording start time
datetime(now,'ConvertFrom','datenum')
%file
for DatafileName=26:2:26
    InDatafileName=strcat(string(DatafileName),'input.csv');
    OutputResultname01=strcat(string(DatafileName),'ResTure.csv');
    OutputResultname02=strcat(string(DatafileName),'ResEstimat.csv');
    rawData=csvread(InDatafileName);%read input data ***.csv
    [rl1,cl2]=size(rawData);
    subAvergData01=zeros;
    subAvergData02=zeros;
    index=1;
    b=1;
    c=1;
    %%     calculate the average for 10 clown
    %subjects ture sigma
    for a=index:rl1
        subAvergData01(c,b)= rawData(a,1);
        b=b+1;
        if mod(a,10)==0 %10trials
            c=c+1;
            b=1;
        end
    end
%     csvwrite(OutputResultname,testfalData)
resultData01=[subAvergData01,(sum(subAvergData01,2)/10)];

    %subjects estimated sigma
    index=1;
    b=1;
    c=1;
    for a=index:rl1
        subAvergData02(c,b)= rawData(a,2);
        b=b+1;
        if mod(a,10)==0 %10trials
            c=c+1;
            b=1;
        end
    end
%     
resultData02=[subAvergData02,(sum(subAvergData02,2)/10)];


end
csvwrite(OutputResultname01,resultData01)
csvwrite(OutputResultname02,resultData02)



