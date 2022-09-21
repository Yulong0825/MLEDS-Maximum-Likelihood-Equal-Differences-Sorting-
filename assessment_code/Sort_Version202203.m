

%% --------Maximum Likelihood Equal Differences Sorting----------
%-------------------------------------------------------------------
% File: Sort_Version202203.m 
% Version: Matlab R2021a
% Name:  Yulong Liu
% Create  Date: 2017/11/15
% Revised Data: 2021/07/25
% Experiment: Occurrence Probability of Sorting about Angle Discrimination.
% Desc: Program about psycholinguistics.
% Usage: Input the name of filelist.(*.csv; Example w21.csv) 
%        Input the name of subject.
%        Output the name of filelist.(*OutResult.csv)
%-------------------------------------------------------------------
clear

%% ------------------Reading input data CSV list ---------------------------------
%Input file name - Exp:0018.csv - DatafileName= '0018'
DatafileName = input('Please Input the Name of raw data file(***.csv) ? ', 's'); %Input name
if isempty(DatafileName) % if not
    return;
end
InDatafileName=strcat(DatafileName,'.csv');
F=csvread(InDatafileName);%read input data ***.csv 
OutputResultname = strcat(DatafileName,'OutResult.csv');
% Sigma Interval - Default precision：0.01
% Increased precision value increases computation time
blanking = input('Please Input the step value of calculation (default - 0.01) ? ', 's'); 
if isempty(blanking) % if not
%     return;
    blanking=0.01;
end
if isnumeric(blanking)==0
    blanking=str2num(blanking);
end
% MaxValue of Sigma - 
% Increased Range increases computation time
MaxSigma = input('Please Input the range of calculation (default - 20) ? ', 's'); 
if isempty(MaxSigma) % if not
%     return;
  MaxSigma=20;  
end
if isnumeric(MaxSigma)==0
    MaxSigma=str2num(MaxSigma);
end
% the start degree of stimuli
startNum = input('Please Input the start value of raw data (default - 22) ? ', 's'); 
if isempty(startNum) % if not
%     return;
    startNum=22;
end
if isnumeric(startNum)==0
    startNum=str2num(startNum);
end
%the Interval degree of Experiment stimuli - difference angle:2(deg)
InterNum = input('Please Input the step value of raw data (default - 2) ? ', 's'); 
if isempty(InterNum) % if not
%     return;
    InterNum=2;
end
if isnumeric(InterNum)==0
    InterNum=str2num(InterNum);
end
sizeXY=size(F);%the size of matrix
%sizeXY=[1,19];
% F=(F-startNum)/InterNum+1;%Convert matrix (degrees value to rank value)
%------------------Calculate the Probability ---------------------------------

count=1;%count
Fa=zeros(sizeXY(1),sizeXY(2));%swap
Lp=zeros(sizeXY(1),MaxSigma/blanking);%swap
swap=zeros(sizeXY(2),1);
figure_n=sizeXY(1);
 for s=blanking:blanking:MaxSigma %Loop (Sigma Interval to MaxSigma by Sigma Interval)
     sigsco=s;  %sigma value in this cycle

     %%
     for m=1:sizeXY(1)%Loop through the data of each subject
 %*****       maxn=max(F(m,:));%
 %*****         minn=min(F(m,:));
        for n=1:sizeXY(2)% Loop the the data of each angle sort
 %% ---Revised by LIU  for Probability of each position in the sorting           
                minn=min(F(m,(n:(sizeXY(2))))); %Finding the smallest of the remaining angles 
                meanMu=minn;
                %set  normal distribution template
                for stuNo=0:(sizeXY(2)-n)
                    norVariX =meanMu+stuNo*InterNum;%change to Angle(date:5-21)
                %The axis of symmetry is at the min angle position
                    Pacc1(stuNo+1)=normpdf(norVariX,meanMu,sigsco);
                end
%                 allPa1=sum(Pacc1); 
                %Check the previously selected angle
                dropPosi=0;%
                exBigData=0;
                if n>1&&n<sizeXY(2)
 % When starting from the position 2nd, check the previously selected angle
 % If there is a larger angle than the remaining angle, then accumulate the probabilityof its corresponding normal distribution position
 % the accumulate value use for the denominator in the normalization later.
                    for backCheck=1:(n-1)
                        if F(m,backCheck)>minn%
                            %
                            dropPosi=dropPosi+Pacc1((F(m,backCheck)-minn)/InterNum+1); %change to Angle(date:5-21)
                            exBigData=1;
                        end
                    end
                end
                %There is no stimulus greater than the remaining angles in the previous selection angle 
                if exBigData==0 
                    allPa=sum(Pacc1(1:(sizeXY(2)-n+1)));
                %if there is stimulus greater than the remaining angles in the previous selection angle  
                %Remove its corresponding probability 
                else            
                    allPa=sum(Pacc1)-dropPosi;
                end
                %Calculate the probability of this cycle, and normalize
                if F(m,n)  ==  minn  %The smallest stimulus is selected this time
                    Pa=Pacc1(1)/allPa;%normalize
                    Posin(n)=Pa;
                    %The smallest stimulus is not selected this time
                else
                    Pa=Pacc1((F(m,n)-minn)/InterNum+1)/allPa; %normalize%change to Angle(date:5-21)
                    Posin(n)=Pa;
                end
                %Calculate the probability of the penultimate choice of stimulus
                 if n==(sizeXY(2)-1)
                    minn=min(F(m,(n:sizeXY(2))));%get min
                    disTav=(sum(F(m,(n:sizeXY(2))))-2*minn)/InterNum+1;%Calculate a few units away from the minimum stimulus%change to Angle(date:5-21)
%                     for backCheck=1:(n-1)
%                         if F(m,backCheck)>minn 
%                             dropPosi=dropPosi+Pacc1(F(m,backCheck)-minn+1); 
%                         end
%                     end
                    % Calculate the normalized denominator    
                    allPa=(Pacc1(1)+Pacc1(disTav));
                    if F(m,n)==minn%the penultimate choice is the min
                        Posin(n)=Pacc1(1)/allPa;
                    else %the penultimate choice isnot the min
                        Posin(n)=Pacc1(disTav)/allPa;
                    end
                 end
                %**************************
                %the last the probability set 1.
                if n==sizeXY(2)
                    Pa=1;
                    Posin(n)=Pa;
                end
       end    

         Lp(m,count)=prod(Posin);    
     end
     count=count+1;
end
%------------------draw Fig--------------------------------- 
for idata=1:(MaxSigma/blanking)
    for subNo=1:sizeXY(1)
        if isnan(Lp(subNo,idata))
            Lp(subNo,idata)=0;
        end
    end
end
%------------------draw Fig---------------------------------
%------------------draw Fig--------------------------------- 
 odd=1;
 even=1;
%  index(sortNo)=zeros(1,sizeXY(2));

SumallData=sum(Lp,2);
SumPosity=[];
F1=(F-startNum)/InterNum+1;%change to Number for verification(date:5-21)
for sig=1:sizeXY(1)
    
    sortAngle=F1(sig,:);
   for sortNo=1:sizeXY(2)   
        if sortAngle(sortNo)==sortNo
            index(sortNo)= 1;
        else 
            index(sortNo)=0;
        end
   end
        if sum(index)~=sizeXY(2) %sort error
            Pm(sig,1)=max(Lp(sig,:));
            [y]=find((Lp(sig,:))==max(Lp(sig,:))) ;
            Pm(sig,2)=y(1)*blanking;
            daYYYq= Lp(sig,:);
            perData(sig)=(sum(daYYYq(1:y)))/SumallData(sig);
%%    Revised by LIU for Cumulative probability when x<sigma                      
            Pm(sig,3)=perData(sig);%
%%            
                if mod(sig,2)==0
                Ps(even,3)=Pm(sig,1);
                Ps(even,4)=Pm(sig,2);
                even=even+1;
                else
                    Ps(odd,1)=Pm(sig,1);
                    Ps(odd,2)=Pm(sig,2);
                    odd=odd+1;
                end  
%% Revised by LIU ********* add when sort correct sigma setting
        else % add sort correct 
           Lq=roundn(Lp,-4) ; % Set 4 effective decimal places.
           for maxide=2:(count-1)
              juetPoint=Lq(sig,maxide)-Lq(sig,maxide-1);
              daYYYq= Lp(sig,:);
              % When sigma starts to decrease
              if juetPoint<0
                  Pm(sig,1)=Lp(sig,maxide-1);
                  Pm(sig,2)=(maxide)*blanking;
                  perData(sig)=(sum(daYYYq(1:maxide)))/SumallData(sig);
                  Pm(sig,3)=perData(sig);
                  break;
%               elseif ~isnan(juetPoint)
%                 Pm(sig,1)=Lp(sig,maxide+1);  
%                 [y]=find(Lp(sig,maxide+1)) ;  
%                 Pm(sig,2)=y(1)*blanking;
%                 break;  
              end
%% *********
           end
        end

end 


%  figure (1)
%  figure_FontSize=8;
%  
% for fig=1:m
%     if mod(fig,2)==0
%        t=2;
%     else
%        t=1;
%     end
%     subplot(5,12,fig);
%     bar(Lp(fig,:));
% %     set(gca, 'YLim',[0 1.2]); 
%     set(gca, 'XLim',[0 MaxSigma/blanking]); 
%     set(gca, 'XTick',[0,MaxSigma/blanking/4*1,MaxSigma/blanking/4*2,MaxSigma/blanking/4*3,MaxSigma/blanking],'xticklabel',[0,MaxSigma/4*1,MaxSigma/4*2,MaxSigma/4*3,MaxSigma]);
%     title1=['Maximum of P=',num2str(Pm(fig,1)),'    Sub ',num2str(fix((fig+1)/2))];
%     title2=['Maximum of Sigma=',num2str(Pm(fig,2)),'    Times ',num2str(t)];
%     xlabel1=['Sigma=,',num2str(MaxSigma),']'   'Interval of Sigma=',num2str(blanking)];
%     title({[title1];[title2]});
%     xlabel(xlabel1);
%     ylabel('P');
% end

% figure (2)
% for fig=1:20 
%     subplot(5,4,fig)
%     bar(Lp(fig+20,:))  
%     title(fig+20)
%     set(gca, 'XLim',[0 40]); 
%     set(gca, 'XTick',[0,10,20,30,40],'xticklabel',[0,0.5,1,1.5,2]);
%     xlabel('Sigma=0.05 to 2');
%     ylabel('P');
% end
% L=csvread('data2.csv');
% for r=1:10
% Th(r,:)=((log(1/0.75-1)-L(r,1))/L(r,2)-(log(1/0.25-1)-L(r,1))/L(r,2))/2;
% end
% PT(:,1)=Ps(:,2);
% PT(:,2)=Ps(:,4);
% PT(:,3)=Th(:,1);
% p1=PT(:,1);
% p2=PT(:,2);
% p3=(p1+p2)/2;
% t=PT(:,3);
%%  -Revised by LIU - Out Data Result list
% Probability - The probability corresponding to the maximum sigma
% sigma - Optimal solution sigma maximum
% Cumulative probability - The cumulative probability 
%                          corresponding to the maximum value of sigma
columns = {'Probability', 'sigma', 'Cumulative probability'};
data = table(Pm(:,1),Pm(:,2),Pm(:,3), 'VariableNames', columns); %
writetable(data, OutputResultname)



