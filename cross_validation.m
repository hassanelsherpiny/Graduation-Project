clc
clear
benign_size = 160;
malignant_size = 40;

c = cell(benign_size+malignant_size,1);
for i=1:(benign_size+malignant_size)
    if i<=malignant_size
        c(i) = cellstr('1');
    else
        c(i) = cellstr('2');
    end
end

CVO = cvpartition(c,'k',10);
CVO.TrainSize
CVO.TestSize
% CVO.NumTestSets
result1 = ones(10,1);
result2 = ones(10,1);
result3 = ones(10,1);
result4 = ones(10,1);
result5 = ones(10,1);
result6 = ones(10,1);
result7 = ones(10,1);
result8 = ones(10,1);
result9 = ones(10,1);
result10 = ones(10,1);
result11 = ones(10,1);
result12 = ones(10,1);
result13 = ones(10,1);
result14 = ones(10,1);
result15 = ones(10,1);
result16 = ones(10,1);
result17 = ones(10,1);
result18 = ones(10,1);
result19 = ones(10,1);
result20 = ones(10,1);
result21 = ones(10,1);



for i = 1:CVO.NumTestSets
% for i = 1:2
    trIdx = CVO.training(i);
    teIdx = CVO.test(i);
    
    train_benign = cell(1,1);
    train_malignant = cell(1,1);
    test_benign = cell(1,1);
    test_malignant = cell(1,1);
    
    for j=1:size(trIdx,1)
        if trIdx(j) == 1
            if j <= malignant_size
%                 if j <= 116
%                     str = strcat(strcat('Malignant/',int2str(j)),'.jpg');
%                 else
                    str = strcat(strcat('Malignant/',int2str(j)),'.bmp');
%                 end 
                train_malignant = [train_malignant;cellstr(str)];
            else
%                 if j<= 243
%                     str = strcat(strcat('Benign/',int2str(j)),'.jpg');
%                 else
                    str = strcat(strcat('Benign/',int2str(j)),'.bmp');
%                 end
                train_benign = [train_benign;cellstr(str)];
            end
        end
    end
    
    for j=1:size(teIdx,1)
        if teIdx(j) == 1
            if j <= malignant_size
%                 if j <= 116
%                     str = strcat(strcat('Malignant/',int2str(j)),'.jpg');
%                 else
                    str = strcat(strcat('Malignant/',int2str(j)),'.bmp');
%                 end 
                test_malignant = [test_malignant;cellstr(str)];
            else
%                 if j<= 243
%                     str = strcat(strcat('Benign/',int2str(j)),'.jpg');
%                 else
                    str = strcat(strcat('Benign/',int2str(j)),'.bmp');
%                 end
                test_benign = [test_benign;cellstr(str)];
            end
        end
    end
    
    train_benign = train_benign(2:end);
    train_malignant = train_malignant(2:end);
    test_benign = test_benign(2:end);
    test_malignant = test_malignant(2:end);
    size(train_benign,1)
    size(train_malignant,1)
    size(test_benign,1)
    size(test_malignant)
    [result1(i),result2(i),result3(i),result4(i),result5(i),result6(i),result7(i),result8(i),result9(i),result10(i),result11(i),result12(i),result13(i),result14(i),result15(i),result16(i),result17(i),result18(i),result19(i),result20(i),result21(i)]= System(train_benign,train_malignant,test_benign,test_malignant,300,20,i);
end

% cost 1
mean_accuracy_KNN_5 = mean(result1)
mean_sensitivity_KNN_5 = mean(result2)
mean_specificity_KNN_5 = mean(result3)
cost_KNN_5 = (1.5*(1-mean_sensitivity_KNN_5)+1*(1-mean_specificity_KNN_5))/2.5


% cost 2
mean_accuracy_KNN_9 = mean(result4)
mean_sensitivity_KNN_9 = mean(result5)
mean_specificity_KNN_9 = mean(result6)
cost_KNN_9 = (1.5*(1-mean_sensitivity_KNN_9)+1*(1-mean_specificity_KNN_9))/2.5

% cost 3
mean_accuracy_KNN_15 = mean(result7)
mean_sensitivity_KNN_15 = mean(result8)
mean_specificity_KNN_15 = mean(result9)
cost_KNN_15 = (1.5*(1-mean_sensitivity_KNN_15)+1*(1-mean_specificity_KNN_15))/2.5

% cost 4
mean_accuracy_KNN_19 = mean(result10)
mean_sensitivity_KNN_19 = mean(result11)
mean_specificity_KNN_19 = mean(result12)
cost_KNN_19 = (1.5*(1-mean_sensitivity_KNN_19)+1*(1-mean_specificity_KNN_19))/2.5

% cost 5
mean_accuracy_KNN_25 = mean(result13)
mean_sensitivity_KNN_25 = mean(result14)
mean_specificity_KNN_25 = mean(result15)
cost_KNN_25 = (1.5*(1-mean_sensitivity_KNN_25)+1*(1-mean_specificity_KNN_25))/2.5

% cost 6
mean_accuracy_SVM_linear = mean(result16)
mean_sensitivity_SVM_linear = mean(result17)
mean_specificity_SVM_linear = mean(result18)
cost_SVM_linear = (1.5*(1-mean_sensitivity_SVM_linear)+1*(1-mean_specificity_SVM_linear))/2.5

% cost 1
mean_accuracy_SVM_rbf = mean(result19)
mean_sensitivity_SVM_rbf = mean(result20)
mean_specificity_SVM_rbf = mean(result21)
cost_SVM_rbf = (1.5*(1-mean_sensitivity_SVM_rbf )+1*(1-mean_specificity_SVM_rbf ))/2.5
