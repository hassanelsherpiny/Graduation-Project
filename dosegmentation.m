function [lesion] = dosegmentation(fileName)

threshold = 0.015;

% addpath('D:\MATLAB codes\Segmentation\AdvancedTechniques');
% addpath('D:\MATLAB codes\Segmentation\Metrics');
lesionAndBorders = FuzzyCMeansClustering(fileName);
lesion = RegionGrowingModified(lesionAndBorders, threshold);
lesion = imgaussfilt(lesion, 6);
end