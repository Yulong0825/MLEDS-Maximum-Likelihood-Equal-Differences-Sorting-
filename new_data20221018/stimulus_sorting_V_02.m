%stimulus sorting
% by Yulong LIU
%created date 2022-9-6
%function: stimulus sorting 

%%
clear all
% %set the number of data
% %set star_data
% star_data = input('Please Input the star_data value of sorting (default - 22) ? ', 's'); 
% if isempty(star_data) % if not
% %     return;
%     star_data=22;
% end
% if isnumeric(star_data)==0
%     star_data=str2num(star_data);
% end
% %set inte_data
% inte_data = input('Please Input the step value of sorting (default - 2) ? ', 's'); 
% if isempty(inte_data) % if not
% %     return;
%     inte_data=2;
% end
% if isnumeric(inte_data)==0
%     inte_data=str2num(inte_data);
% end
% %set end_data
% end_data = input('Please Input the end value of calculation (default - 26) ? ', 's'); 
% if isempty(end_data) % if not
% %     return;
%     end_data='26';
% end
% OutputResultname=strcat(end_data,'outStimulsData.csv');
% if isnumeric(end_data)==0
%     end_data=str2num(end_data);
% end
clear;
all_sigma=csvread('all_sigma_di.csv');
for end_data=26:2:40
star_data=22;
inte_data=2;
% end_data='26';
OutputResultname=strcat(string(end_data),'outStimulsData.csv');


rawData=(star_data:inte_data:end_data);

%%     set_rules of sorting
    testfalData=zeros;
    testData=zeros;
    proba=[0];
    
    %subjects
    for a=1:100000
        % rand the sigma
        % gass distarbution u=1,sigma=0.3
        sigma=all_sigma(a);
%         sigma=normrnd(1,1,1,1);
% %         sigma=normrnd(1,0.3,1,1);
%         if sigma<0.43
%             sigma=abs(sigma)+0.43;
%         end
        [rl,cl]=size(rawData);
        % calculate probability model
        for i=1:cl
            
            u=min(rawData);
            proba(i)=normpdf(rawData(i),u,sigma);
        end
        %trails
        for j=1:1
            oberPro_model=(proba/(sum(proba)));
            model_table=[rawData;oberPro_model];
            
            [rl1,cl2]=size(model_table);
            
            % stimulus
            for i=1:cl2
                if i==cl2
                   model_table(2,1)=1; 
                end                  
                sorting1=randsrc(1,1,model_table);
                testData(j,i)=sorting1;
                [xla,yla]=find(model_table==sorting1);%xla=1,yla=?
                model_table(:,yla)=[];%Del colom
                model_table(2,:)=(model_table(2,:)/(sum(model_table(2,:))));
            end
            testData(j,(cl2+1))=sigma;
        end
        if testfalData==0
            testfalData= testData;
        else
            testfalData=[testfalData;testData];
        end
    end
csvwrite(OutputResultname,testfalData)
end





