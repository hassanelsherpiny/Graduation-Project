function [ accuracy_KNN_5,sensitivity_KNN_5,Specificity_KNN_5,accuracy_KNN_9,sensitivity_KNN_9,Specificity_KNN_9,accuracy_KNN_15,sensitivity_KNN_15,Specificity_KNN_15,accuracy_KNN_19,sensitivity_KNN_19,Specificity_KNN_19, accuracy_KNN_25,sensitivity_KNN_25,Specificity_KNN_25,accuracy_SVM_linear,sensitivity_SVM_linear,Specificity_SVM_linear,accuracy_SVM_rbf,sensitivity_SVM_rbf,Specificity_SVM_rbf] = System( benign_names,malignant_names,benign_test,malignant_test, k_dic,deltaD,foldNum )
%SYSTEM Summary of this function goes here
%   Detailed explanation goes here
%     load('dataFold','Model','dictionary','nBins');
    
    ben_size = size(benign_names,1)
    mal_size = size(malignant_names,1)
    ben_test_size = size(benign_test,1)
    mal_test_size = size(malignant_test,1)
    mal_size_with_replication = mal_size * 4
    
    all_features = [];
    FeatureSizes = [];
    for i=1:mal_size
        sample_index = i
%         str = char(strcat('NewData/Malignant/',int2str(malignant_names(i))));
%         load(str,'FeatureVector','num');
        [FeatureVector,num] = SamplingFeature(malignant_names(i),deltaD);
        all_features = [all_features;FeatureVector];
        FeatureSizes = [FeatureSizes;num];
        for outerIndex = 1:3
            replicated_vector = zeros(size(FeatureVector));
            for index=1:num
                replicated_vector(index,:) = awgn(FeatureVector(index,:),10,'measured');
            end
            all_features = [all_features;replicated_vector];
            FeatureSizes = [FeatureSizes;num];
        end
    end
    mal_size = mal_size * 4;
    
    for i=1:ben_size
        sample_index = i+mal_size
%         str = char(strcat('NewData/Benign/',int2str(benign_names(i))));
%         load(str,'FeatureVector','num');
        [FeatureVector,num] = SamplingFeature(benign_names(i),deltaD);
        all_features = [all_features;FeatureVector];
        FeatureSizes = [FeatureSizes;num];
    end
    
    foldNum
    [idx,dictionary] = kmeans(all_features,k_dic,'start','plus', 'emptyaction','singleton','MaxIter',100);
    
    % to make all histogram of the same dimension.
    nBins = k_dic;
    % create matrix of malignant histograms
        malignant_histograms = [];
        index = 1;
        for i=1:mal_size
            curSize = FeatureSizes(i);
            starting = index;
            ending = curSize + index -1;
            [N,E] = histcounts(idx(starting:ending),nBins);
            malignant_histograms(i,:) = N;
            index = index + curSize;
        end
        
    % create matrix of benign histograms
        benign_histograms = [];
        for i=1:ben_size
            curSize = FeatureSizes(i+mal_size);
            starting = index;
            ending = curSize + index -1;
            [N,E] = histcounts(idx(starting:ending),nBins);
            benign_histograms(i,:) = N;
            index = index + curSize;
        end
    
    all_histograms = [malignant_histograms;benign_histograms];
%     
    c = [];
    for i=1:mal_size
        c(i) = 1;
    end
    for i=1:ben_size
        c(i+mal_size) = 2;
    end
%     
%     KNN
%     k_KNN = 5;
    Model_KNN_5 = fitcknn(all_histograms,c,'NumNeighbors',5,'ClassNames',{'1','2'});
    Model_KNN_9 = fitcknn(all_histograms,c,'NumNeighbors',9,'ClassNames',{'1','2'});
    Model_KNN_15 = fitcknn(all_histograms,c,'NumNeighbors',15,'ClassNames',{'1','2'});
    Model_KNN_19 = fitcknn(all_histograms,c,'NumNeighbors',19,'ClassNames',{'1','2'});
    Model_KNN_25 = fitcknn(all_histograms,c,'NumNeighbors',25,'ClassNames',{'1','2'});
%     
%     SVM
    Model_SVM_linear = fitcsvm(all_histograms,c,'ClassNames',{'1','2'},'KernelFunction','linear','Standardize',true);
    Model_SVM_rbf = fitcsvm(all_histograms,c,'ClassNames',{'1','2'},'KernelFunction','rbf','Standardize',true);
%     save('dataFold');
    %       testing malignant
        test_malignant_histograms = [];
        for malI=1:size(malignant_test,1)
            mal_test_index = malI
            malignant_name_in_test = malignant_test(malI)
            [test_feature,num] = SamplingFeature(malignant_test(malI),deltaD);
%             str = char(strcat('NewData/Malignant/',int2str(malignant_test(malI))));
%             load(str,'FeatureVector','num');
%             test_feature = FeatureVector;
               replicated_test_feature2 = zeros(size(test_feature,1),size(test_feature,2));
               replicated_test_feature3 = zeros(size(test_feature,1),size(test_feature,2));
               replicated_test_feature4 = zeros(size(test_feature,1),size(test_feature,2));
              for index=1:size(test_feature,1)
                   replicated_test_feature2(index,:) = awgn(test_feature(index,:),10,'measured');
              end
              for index=1:size(test_feature,1)
                   replicated_test_feature3(index,:) = awgn(test_feature(index,:),10,'measured');
              end
              for index=1:size(test_feature,1)
                   replicated_test_feature4(index,:) = awgn(test_feature(index,:),10,'measured');
              end
            
%             diff = zeros(size(test_feature));
             diff = zeros(size(test_feature,1),k_dic);
            diff2 = zeros(size(test_feature,1),k_dic);
            diff3 = zeros(size(test_feature,1),k_dic);
            diff4 = zeros(size(test_feature,1),k_dic);
%             replicated_diff = zeros(size(replicated_test_feature,1),k_dic);
            for i=1:size(test_feature,1)
                for k=1:size(dictionary,1)
                     diff(i,k) = norm(test_feature(i,:) - dictionary(k,:) );
                    diff2(i,k) = norm(replicated_test_feature2(i,:) - dictionary(k,:) );
                    diff3(i,k) = norm(replicated_test_feature3(i,:) - dictionary(k,:) );
                    diff4(i,k) = norm(replicated_test_feature4(i,:) - dictionary(k,:) );
%                     replicated_diff(i,k) = norm(replicated_test_feature(i,:) - dictionary(k,:) );
                end
            end
            
            test_labels = [];
            test_labels2 = [];
            test_labels3 = [];
            test_labels4 = [];
%             replicated_test_labels = [];
            for i=1:size(diff,1)
                [val,index] = min(diff(i,:));
                test_labels(i) = index;
                [val,index] = min(diff2(i,:));
                test_labels2(i) = index;
                [val,index] = min(diff3(i,:));
                test_labels3(i) = index;
                [val,index] = min(diff4(i,:));
                test_labels4(i) = index;
              
%                 [val,index] = min(replicated_diff(i,:));
%                 replicated_test_labels(i) = index;
            end
            [N,E] = histcounts(test_labels,nBins);
            test_malignant_histograms = [test_malignant_histograms;N];
            [N,E] = histcounts(test_labels2,nBins);
            test_malignant_histograms = [test_malignant_histograms;N];
            [N,E] = histcounts(test_labels3,nBins);
            test_malignant_histograms = [test_malignant_histograms;N];
            [N,E] = histcounts(test_labels4,nBins);
            test_malignant_histograms = [test_malignant_histograms;N];
%             [N,E] = histcounts(replicated_test_labels,nBins);
%             test_malignant_histograms = [test_malignant_histograms;N];
            
        end
        mal_test_size = mal_test_size *4;
        
    %          testing benign
        test_benign_histograms = [];
        for benI=1:size(benign_test,1)
            ben_test_index = benI
            ben_name_in_test = benign_test(benI)
            [test_feature,num] = SamplingFeature(benign_test(benI),deltaD);
%             str = char(strcat('NewData/Benign/',int2str(benign_test(benI))));
%             load(str,'FeatureVector','num');
%             test_feature = FeatureVector;
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
        
        % KNN with 5
        malignant_labels = predict(Model_KNN_5,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_KNN_5,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_KNN_5 = (TP+TN)/All
        sensitivity_KNN_5 = TP / (TP+FN)
        Specificity_KNN_5 = TN / (FP+TN)
        
        % KNN with 9
        malignant_labels = predict(Model_KNN_9,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_KNN_9,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_KNN_9 = (TP+TN)/All
        sensitivity_KNN_9 = TP / (TP+FN)
        Specificity_KNN_9 = TN / (FP+TN)
        
         % KNN with 15
        malignant_labels = predict(Model_KNN_15,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_KNN_15,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_KNN_15 = (TP+TN)/All
        sensitivity_KNN_15 = TP / (TP+FN)
        Specificity_KNN_15 = TN / (FP+TN)
        
        
        % KNN with 19
        malignant_labels = predict(Model_KNN_19,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_KNN_19,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_KNN_19 = (TP+TN)/All
        sensitivity_KNN_19 = TP / (TP+FN)
        Specificity_KNN_19 = TN / (FP+TN)
        
        % KNN with 25
        malignant_labels = predict(Model_KNN_25,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_KNN_25,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_KNN_25 = (TP+TN)/All
        sensitivity_KNN_25 = TP / (TP+FN)
        Specificity_KNN_25 = TN / (FP+TN)
        
        % SVM_linear
        malignant_labels = predict(Model_SVM_linear,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_SVM_linear,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_SVM_linear = (TP+TN)/All
        sensitivity_SVM_linear = TP / (TP+FN)
        Specificity_SVM_linear = TN / (FP+TN)
        
        % SVM_rbf
        malignant_labels = predict(Model_SVM_rbf,test_malignant_histograms);
        TP = 0;
        FN = 0;
        for h=1:size(malignant_labels,1)
            malignant = malignant_labels(h)
            if ( strcmp(malignant_labels(h),cellstr('1')) )
                TP = TP + 1;
            else
                FN = FN + 1;
            end
        end
        
        benign_labels = predict(Model_SVM_rbf,test_benign_histograms);
        
        FP = 0;
        TN = 0;
        for h=1:size(benign_labels,1)
            benign = benign_labels(h)
            if ( strcmp(benign_labels(h),cellstr('2')) )
                TN = TN +1;
            else
                FP = FP +1;
            end
        end
        
%         accuracy = accuracy / ( size(malignant_test,1)+ (size(malignant_test,1)*2) )
        All = size(malignant_labels,1) + size(benign_labels,1);
        accuracy_SVM_rbf = (TP+TN)/All
        sensitivity_SVM_rbf = TP / (TP+FN)
        Specificity_SVM_rbf = TN / (FP+TN)
        
        
end

