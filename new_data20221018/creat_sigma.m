%creat the participants discrimination index sigma


clear
testfalData=[];
for a=1:10000
 sigma=normrnd(1,1,1,1);
%         sigma=normrnd(1,0.3,1,1);
        if sigma<0.43
            sigma=abs(sigma)+0.43;
        end
        for b=1:10
           testfalData=[testfalData;sigma]; 
        end
        


end
csvwrite('all_sigma_di.csv',testfalData)