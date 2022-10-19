%---------------------------------------------------------------------
%-------------------------------------------------------------------

% File: Sort_Prob.m
% Name: Yiyang Yu
% Date: 2017/11/15
% Experiment: Occurrence Probability of Sorting about Angle Discrimination.
% Desc: Program about psycholinguistics.
% Usage: Input the name of filelist.(*.txt; Example w21.txt) 
%        Input the name of subject.
%        Have fun :)

%-------------------------------------------------------------------
%----------------------------------------------------------------------
%------------------Filelist ---------------------------------
% datalist = input('Please Input the Name of Filelist(*.csv).', 's'); % input
% if isempty(datalist) % if not
%     return;
% end; 
%------------------Sigma Score ---------------------------------
% sigsco = input('Please Input the Sigma Score.'); % input
% if isempty(sigsco)
%     return;  
% end;
% %------------------Reading CSV ---------------------------------
clear all
tic
F=csvread('36.csv');%read dataTV24
blanking=0.01;%Sigma Interval 
MaxSigma=10;%MaxValue of Sigma
startNum=22;%the start degree of stimuli
InterNum=2;%the Interval degree of Experiment stimuli 
sizeXY=size(F);%the size of matrix
%sizeXY=[1,19];
% F=(F-startNum)/InterNum+1;%Convert matrix (degrees value to rank value)
%------------------Calculate the Probability ---------------------------------

count=1;%count
Fa=zeros(sizeXY(1),sizeXY(2));%swap
Lp=zeros(sizeXY(1),MaxSigma/blanking);%swap
swap=zeros(sizeXY(2),1);

 for s=blanking:blanking:MaxSigma %Loop (Sigma Interval to MaxSigma by Sigma Interval)
     sigsco=s;  %sigma value in this cycle

     %%
     for m=1:sizeXY(1)%Loop through the data of each subject
 %*****       maxn=max(F(m,:));%
 %*****         minn=min(F(m,:));
        for n=1:sizeXY(2)% Loop the the data of each angle sort
 %% ---add by LIU  for Probability of each position in the sorting           
                minn=min(F(m,(n:(sizeXY(2))))); %Finding the smallest of the remaining angles 
                meanMu=minn;
                %set  normal distribution template
                for stuNo=0:(sizeXY(2)-n)
                    norVariX =meanMu+stuNo*InterNum;%change to Angle(date:5-21)
                %The axis of symmetry is at the min angle position
                    Pacc1(stuNo+1)=normpdf(norVariX,meanMu,sigsco);
                end
%                 allPa1=sum(Pacc1); %������
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
%%   ----end            
%  add *****************
% %           %*****������1
%             if n==1  
%                 if F(m,n) - minn == 0                               %add*****��������������������?
%                     Pa=Pacc1(F(m,n))/allPa1;                               %add
%                     Posin(n)=Pa;
%                     dddo(n)=1;
%                 elseif F(m,n) - minn ~=0
%                     Pa=Pacc1(F(m,n))/allPa1;
%                     Posin(n)=Pa;
%                     dddo(n)=0;
%                 end 
% %           %***** 2~���n-1��������?              
%             elseif n<sizeXY(2)&& n>1                                   
%                 %**********
%                 minn=min(F(m,(n:sizeXY(2)))); %add*****����������?��������������?��������������������������������������
%                 %********************
%                 %��?����������������������?��������������������
%                 dropPosi=0;%������������������
%                 exBigData=0;
%                 for backCheck=1:(n-1)%��?����������������������������?
%                     if F(m,backCheck)>minn        %
%                         dropPosi=dropPosi+Pacc1(F(m,backCheck)-minn+1); %��������������?����������?F(m,backCheck)-minn+1)������������
%                         exBigData=1;
%                     end
%                 end
%                 if exBigData==0 %��������������������������������������������?
%                     allPa=sum(Pacc1(1:(sizeXY(2)-n)));
%                 else            %��������������������������������������������������������������?
%                     allPa=sum(Pacc1)-dropPosi;
%                     
%                 end
%                 %******************������2��?n-1)������
%                 %��������������?
%                 if F(m,n) - minn == 0          
%                     Pa=Pacc1(1)/allPa;                             
%                     Posin(n)=Pa;
%                  %��������������?��
%                 else     
%                     Pa=Pacc1(F(m,n)-minn+1)/allPa; %��������������?����������?F(m,backCheck)-minn+1)������������,��������?��?
%                     Posin(n)=Pa;
%                 end
%                 
%             %************    
%             elseif n==sizeXY(2)
%                 Pa=1;
%                 Posin(n)=Pa;
%             end
            %  *********************
%             a=1:maxn;%a��������������������?
%             d=F(m,n)-n;%��??������������������������������������ 1������ ��? d��? 1��������? d��?
% %****           Pa=normpdf(a,n,sigsco);%������������������������      *** 
%             Pa=Pa/sum(Pa);%��������������������������������?
%                 if n>1%������������������
%                     for na=1:n-1
%                         Pa(swap(na))=0;%��?����������?��������������?
%                     end
%                     Pa=Pa/sum(Pa);%��������������������������������?
%                 end
%             Fa(m,n)=Pa(n+d);%������������������������
%             swap(n)=F(m,n);%������������������������
%         end
% *****************        
%       
%****        Lp(m,count)=prod(Fa(m,:));%��������������������������������������?
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
%%    add by LIU for Cumulative probability when x<sigma                      
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
%% add by LIU ********* add when sort correct sigma setting
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
% for fig=1:60
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
%%  -add by LIU
columns = {'Probability', 'sigma', 'Cumulative probability'};
data = table(Pm(:,1),Pm(:,2),Pm(:,3), 'VariableNames', columns); %
writetable(data, 'OutputResult1221.csv')
toc


