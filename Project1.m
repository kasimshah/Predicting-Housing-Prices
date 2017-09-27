
clear
clc

data=dlmread('housing_price_data.dat');
price=data(:,2);
size=data(:,5);

table=sortrows([size price]);

newTable=table([25:600],:); %Remove outliers
originalSizeValue=table([25:600],1); %Table to be used later or the final w0 and w1 values with outliers removed

scatter(newTable(:,1),newTable(:,2));
title('price vs size');
xlabel('Size');
ylabel('Price');
hold on

m=mean(newTable(:,1));
s=std(newTable(:,1));

%For loop to normalize the size column of newTable
for i=1:length(newTable)
    newTable(i,1)=(newTable(i,1)-m)/s;    
end

r=0;
tableIter=[(0.1:.05:1.5)' (0.1:.05:1.5)']; %Table to hold the number of iterations and the corrsponding learning rate
tableErr=[(0.1:.05:1.5)' (0.1:.05:1.5)']; %Table to hold the number of iterations and the corrsponding error value

%For loop to go through the different values for the learning rate
for value=0.1:.05:1.5
    %Intilizing values for the gradient descent calculations
    w0=rand;
    w1=rand;
    learningRate=value;
    prevmse=0.0;
    converge=0.0000000001;
    count=0;

    %While loop to perform grdient descent on w0 and w1 values
    while 1

        w0gradient=0.0;
        w1gradient=0.0;
        for i=1:length(newTable)
            w0gradient=w0gradient+(w0+(w1*newTable(i,1))-newTable(i,2));
            w1gradient=w1gradient+((w0+(w1*newTable(i,1))-newTable(i,2))*newTable(i,1));
        end

        tempw0=w0-(learningRate*(w0gradient/length(newTable)));
        tempw1=w1-(learningRate*(w1gradient/length(newTable)));

        msesum=0.0;
        for i=1:length(newTable)
            msesum=msesum+((((tempw0+(tempw1*newTable(i,1)))-newTable(i,2)))^2);
        end

        mse=msesum/length(newTable);
        diffmse=abs(prevmse-mse);

        if diffmse<=converge
            w0=tempw0;
            w1=tempw1;
            break
        end

        prevmse=mse;
        w0=tempw0;
        w1=tempw1;
        count=count+1;
        %fprintf('The iteration is: %i\n',count);
    end
    
%     fprintf('For learning rate: %.3f, the values are:\n',value);
%     fprintf('The w0 value is: %.3f\n',w0);
%     fprintf('The w1 value is: %.3f\n',w1);
%     fprintf('The number of iterations is: %d\n',count);
%     fprintf('\n');
    
    r=r+1;
    %tableIter(r,1)=value;
    tableIter(r,2)=count;
    tableErr(r,1)=count;
    tableErr(r,2)=mse;
    
end

fprintf('The w0 final value is: %.3f\n',w0);
fprintf('The w1 final value is: %.3f\n',w1);
fprintf('\n');
fprintf('The following is a table showing learning rate( as the first column) and number of ietrations until convergance(in the second column):\n');
tableIter

for i=1:length(newTable)
    newTable(i,2)=w0+(w1*newTable(i,1));
end

scatter(originalSizeValue,newTable(:,2));
hold off

figure;scatter(tableErr(:,1),tableErr(:,2));
title('Iterations vs. Error');
xlabel('Number of Iterations');
ylabel('Error');
