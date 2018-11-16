clc
clear
mal_size = 40;
ben_size = 160;
k_dic = 100;
deltaD = 20;
malignant_names = cell(mal_size,1);
benign_names = cell(ben_size,1);
for i=1:mal_size
     str = strcat(strcat('Malignant/',int2str(i)),'.bmp');
     malignant_names(i) = cellstr(str);
end
for i=1:ben_size
    str = strcat(strcat('Benign/',int2str(i+mal_size)),'.bmp');
    benign_names(i) = cellstr(str);
end

all_features = [];
FeatureSizes = [];
for i=1:mal_size
    sample_index = i
%     str = char(strcat('NewData/Malignant/',int2str(i)));
%     load(str,'FeatureVector','num');
    [FeatureVector,num] = SamplingFeature(malignant_names(i),deltaD);
%     str = strcat('NewData/Malignant/',int2str(sample_index));
%     save(char(str));
    all_features = [all_features;FeatureVector];
    FeatureSizes = [FeatureSizes;num];
    for outerIndex = 1:3
        replicated_vector = [];
        for index=1:num
            replicated_vector = [replicated_vector;awgn(FeatureVector(index,:),10,'measured')];
        end
        all_features = [all_features;replicated_vector];
        FeatureSizes = [FeatureSizes;num];
    end
end
mal_size = mal_size * 4;
    
for i=1:ben_size
    sample_index = i+mal_size
    [FeatureVector,num] = SamplingFeature(benign_names(i),deltaD);
%     str = strcat('NewData/Benign/',int2str(sample_index));
%     save(char(str));
%     str = char(strcat('NewData/Benign/',int2str(i+173)));
%     load(str,'FeatureVector','num');
    all_features = [all_features;FeatureVector];
    FeatureSizes = [FeatureSizes;num];
end
% save('D:\computer science\4th year\GP\TheProject\FinalData\lab_histogram_bin_45_delta_80');
[idx,dictionary] = kmeans(all_features,k_dic,'start','plus', 'emptyaction','singleton','MaxIter',200,'Replicates',5);
% 
% % to make all histogram of the same dimension.
nBins = k_dic;
% % create matrix of malignant histograms
malignant_histograms = zeros(mal_size,nBins);
index = 1;
for i=1:mal_size
    curSize = FeatureSizes(i);
    starting = index;
    ending = curSize + index -1;
    [N,E] = histcounts(idx(starting:ending),nBins);
    malignant_histograms(i,:) = N;
    index = index + curSize;
end
% 
% create matrix of benign histograms
benign_histograms = zeros(ben_size,nBins);
for i=1:ben_size
    curSize = FeatureSizes(i+mal_size);
    starting = index;
    ending = curSize + index -1;
    [N,E] = histcounts(idx(starting:ending),nBins);
    benign_histograms(i,:) = N;
    index = index + curSize;
end
% 
all_histograms = [malignant_histograms;benign_histograms];

c = [];
for i=1:mal_size
    c(i) = 1;
end
for i=1:ben_size
    c(i+mal_size) = 2;
end
% % 
% % k_KNN = 19;
% % KNN_Model = fitcknn(all_histograms,c,'NumNeighbors',k_KNN,'ClassNames',{'1','2'});
% 
% % %     SVM
Model = fitcsvm(all_histograms,c,'ClassNames',{'1','2'},'Standardize',true,'KernelFunction','linear');
save('FinalModel22','Model','dictionary','nBins');
% % save('features',all_features,FeatureSizes);
