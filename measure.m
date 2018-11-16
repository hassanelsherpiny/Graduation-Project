numR = sum(y(testIdx)); %y(testIdx)--> ground truth for testing data
yy = y(testIdx).';   
counter = 1;
precision = [];
for kk=1:numel(pred_2) %pred_2 -->   predicted values for testing data
    if(pred_2(kk)==1 && yy(kk)==1)   
        precision(counter) = sum(pred_2(1:kk)==yy(1:kk))/ sum(pred_2(1:kk));
        counter = counter + 1;
    end
end
avgPr = sum(precision)/numR;