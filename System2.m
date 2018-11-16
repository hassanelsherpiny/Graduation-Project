function [ accuracy,precision,recall ] = System2( benign_names,malignant_names,benign_test,malignant_test, k_dic,deltaD )
%SYSTEM2 Summary of this function goes here
%   Detailed explanation goes here
    ben_size = 2
    mal_size = 2
    ben_test_size = size(benign_test,1)
    mal_test_size = size(malignant_test,1)
    mal_size_with_replication = mal_size * 4
    
%     all_features = [];
%     FeatureSizes = [];
%     for i=1:mal_size
%         sample_index = i
%         [FeatureVector,num] = SamplingFeature(malignant_names(i),deltaD);
%         all_features = [all_features;FeatureVector];
%         FeatureSizes = [FeatureSizes;num];
%         for outerIndex = 1:3
%             replicated_vector = [];
%             for index=1:num
%                 replicated_vector = [replicated_vector;awgn(FeatureVector(index,:),.01,'measured')];
%             end
%             all_features = [all_features;replicated_vector];
%             FeatureSizes = [FeatureSizes;num];
%         end
%     end
%     mal_size = mal_size * 4;
%     
%     for i=1:ben_size
%         sample_index = i+173
%         [FeatureVector,num] = SamplingFeature(benign_names(i),deltaD);
%         all_features = [all_features;FeatureVector];
%         FeatureSizes = [FeatureSizes;num];
%     end
%     
%     [idx,dictionary] = kmeans(all_features,k_dic,'start','uniform', 'emptyaction','singleton');
%     
%     % to make all histogram of the same dimension.
%     nBins = 25;
%     % create matrix of malignant histograms
%         malignant_histograms = [];
%         index = 1;
%         for i=1:mal_size
%             curSize = FeatureSizes(i);
%             starting = index;
%             ending = curSize + index -1;
%             [N,E] = histcounts(idx(starting:ending),nBins);
%             malignant_histograms(i,:) = N;
%             index = index + curSize;
%         end
%         
%     % create matrix of benign histograms
%         benign_histograms = [];
%         for i=1:ben_size
%             curSize = FeatureSizes(i+mal_size);
%             starting = index;
%             ending = curSize + index -1;
%             [N,E] = histcounts(idx(starting:ending),nBins);
%             benign_histograms(i,:) = N;
%             index = index + curSize;
%         end
%     
%     all_histograms = [malignant_histograms;benign_histograms];
%     
%     c = [];
%     for i=1:mal_size
%         c(i) = 1;
%     end
%     for i=1:ben_size
%         c(i+mal_size) = 2;
%     end
%     
% %     KNN
% %     k_KNN = 19;
% %     Model = fitcknn(all_histograms,c,'NumNeighbors',k_KNN,'ClassNames',{'1','2'});
%     
% %     SVM
%     Model = fitcsvm(all_histograms,c,'ClassNames',{'1','2'});
%     save('data');
    load('data');
%     %       testing malignant
        test_malignant_histograms = [];
        for malI=1:2
            mal_test_index = malI
            [test_feature,num] = SamplingFeature(malignant_test(malI),deltaD);
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
            test_malignant_histograms = [test_malignant_histograms;N];
%             [N,E] = histcounts(replicated_test_labels,nBins);
%             test_malignant_histograms = [test_malignant_histograms;N];
            
        end
        malignant_labels = predict(Model,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
    %          testing benign
        test_benign_histograms = [];
        for benI=1:2
            ben_test_index = benI
            [test_feature,num] = SamplingFeature(benign_test(benI),deltaD);
%             diff = zeros(size(test_feature));
            diff = zeros(size(test_feature,1),k_dic);

            for i=1:size(test_feature,1)
                for k=1:size(dictionary,1)
                    diff(i,k) = norm(test_feature(i,:) - dictionary(k,:) );
                end
            end

            test_labels = [];
            for i=1:size(diff,1)
                [val,index] = min(diff(i,:));
                test_labels(i) = index;
            end
            [N,E] = histcounts(test_labels,nBins);
            test_benign_histograms = [test_benign_histograms;N];
        end
        benign_labels = predict(Model,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_test,1) + size(benign_test,1);
        accuracy = (TP+TN)/All
        precision = TP / (TP+FP)
        recall = TP / (TP+FN)

end

