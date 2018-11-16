% load('ModelOf_KNN_100_20_labHistogram','dictionary','nBins','all_histograms','c');
% Model = fitcsvm(all_histograms,c,'ClassNames',{'1','2'});
load('FinalModel','dictionary','nBins','Model');
Model = fitSVMPosterior(Model);
all_size = 379;
% ben_size = 727;
k_dic = 300;
deltaD = 80;
all_test = cell(all_size,1);
for i=1:all_size
     str = strcat(strcat('Test/',int2str(i)),'.jpg');
     all_test(i) = cellstr(str);
end
test_all_histograms = [];
for malI=1:size(all_test,1)
    mal_test_index = malI
    malignant_name_in_test = all_test(malI)
    [test_feature,num] = SamplingFeature(all_test(malI),deltaD);
    %             replicated_test_feature = [];
    %             for index=1:size(test_feature,1)
    %                 replicated_test_feature = [replicated_test_feature;awgn(test_feature(index,:),0.01,'measured')];
    %             end
    %             diff = zeros(size(test_feature));
    diff = zeros(size(test_feature,1),k_dic);
    %             replicated_diff = zeros(size(replicated_test_feature,1),k_dic);
    for i=1:size(test_feature,1)
        for k=1:size(dictionary,1)
            diff(i,k) = norm(test_feature(i,:) - dictionary(k,:) );
            %                     replicated_diff(i,k) = norm(replicated_test_feature(i,:) - dictionary(k,:) );
        end
    end
    
    test_labels = [];
    %             replicated_test_labels = [];
    for i=1:size(diff,1)
        [val,index] = min(diff(i,:));
        test_labels(i) = index;
        %                 [val,index] = min(replicated_diff(i,:));
        %                 replicated_test_labels(i) = index;
    end
    [N,E] = histcounts(test_labels,nBins);
    test_all_histograms = [test_all_histograms;N];
    %             [N,E] = histcounts(replicated_test_labels,nBins);
    %             test_malignant_histograms = [test_malignant_histograms;N];
    
end
[malignant_labels,SVMpostProb] = predict(Model,test_all_histograms);
% TP = 0;
% FN = 0;
% for h=1:size(malignant_labels,1)
%     malignant = malignant_labels(h)
%     if ( strcmp(malignant_labels(h),cellstr('1')) )
%         TP = TP + 1;
%     else
%         FN = FN + 1;
%     end
% end
% benign_test = cell(ben_size,1);
% for i=1:ben_size
%     str = strcat(strcat('Benign/',int2str(i+mal_size)),'.jpg');
%     benign_test(i) = cellstr(str);
% end
%          testing benign
% test_benign_histograms = [];
% for benI=1:size(benign_test,1)
%     ben_test_index = benI
%     ben_name_in_test = benign_test(benI)
%     [test_feature,num] = SamplingFeature(benign_test(benI),deltaD);
%                 diff = zeros(size(test_feature));
%     diff = zeros(size(test_feature,1),k_dic);
%     
%     for i=1:size(test_feature,1)
%         for k=1:size(dictionary,1)
%             diff(i,k) = norm(test_feature(i,:) - dictionary(k,:) );
%         end
%     end
%     
%     test_labels = [];
%     for i=1:size(diff,1)
%         [val,index] = min(diff(i,:));
%         test_labels(i) = index;
%     end
%     [N,E] = histcounts(test_labels,nBins);
%     test_benign_histograms = [test_benign_histograms;N];
% end
% benign_labels = predict(Model,test_benign_histograms);
% 
% FP = 0;
% TN = 0;
% for h=1:size(benign_labels,1)
%     benign = benign_labels(h)
%     if ( strcmp(benign_labels(h),cellstr('2')) )
%         TN = TN +1;
%     else
%         FP = FP +1;
%     end
% end
% 
% All = size(malignant_test,1) + size(benign_test,1);
% accuracy = (TP+TN)/All
% sensitivity = TP / (TP+FN)
% Specificity = TN / (FP+TN)