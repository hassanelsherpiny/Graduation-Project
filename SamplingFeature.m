function [ feature_vectors1,numOfFeatures ] = SamplingFeature( fileName,deltaD )
%SAMPLING Summary of this function goes here
%   Detailed explanation goes here
% fileNameSeg = strrep(char(fileName),'.jpg','.png');
seg = strcat(cellstr('Segmented/'),cellstr(fileName));
fileName = char(fileName);
% lesion = Segmentation(fileName);
lesion = imread(char(seg));
numOfFeatures = 0;
I = imread(fileName);
I = im2double(I);
I = rgb2lab(I);
info = imfinfo(fileName);
% I = imresize(Img,[200 200]);
rows = info.Height;
cols = info.Width;
% if deltaD = 40, feature vector of 576 
% if deltaD = 20, feature vector of 36
feature_vectors1 = [];
ii = floor(rows/deltaD) * deltaD;
jj = floor(cols/deltaD) * deltaD;
halfOfDeltaD = (deltaD * deltaD) /2;

% Mask Matrices for texture feature extraction by Laws
L3 = [1 4 6 4 1];
E3 = [-1 -2 0 2 1];
S3 = [-1 0 2 0 -1];
MaskMatrices = double(transpose(L3) * L3);
MaskMatrices(:,:,2) = double(transpose(L3) * E3);
MaskMatrices(:,:,3) = double(transpose(L3) * S3);
MaskMatrices(:,:,4) = double(transpose(E3) * L3);
MaskMatrices(:,:,5) = double(transpose(E3) * E3);
MaskMatrices(:,:,6) = double(transpose(E3) * S3);
MaskMatrices(:,:,7) = double(transpose(S3) * L3);
MaskMatrices(:,:,8) = double(transpose(S3) * E3);
MaskMatrices(:,:,9) = double(transpose(S3) * S3);

% first quarter
for i=1:deltaD:ii
    for j=1:deltaD:jj
        val = 0;
        for row=i:(i+deltaD -1)
            for col=j:(j+deltaD -1)
                if lesion(row,col) ~= 0
                    val = val + 1;
                end
            end
        end
        if val >= halfOfDeltaD 
            patch = I( i:(i+deltaD -1) , j:(j+deltaD -1) ,:);
            numOfFeatures = numOfFeatures + 1;
%             vec1 = hog_feature_vector(patch);
%             size(features)
%             vec1 = opp_moments(patch);
%             vec1 = lab_histogram(patch);
            vec1 = Laws_Feature(patch,MaskMatrices);
%             features = [vec1 vec2];
            feature_vectors1 = [feature_vectors1;vec1];
        end
    end
end

% % second quarter
% if cols - jj > deltaD/2
%     for i=1:deltaD:ii
%         patch = I( i:(i+deltaD -1) , (jj+1):cols ,:);
% %         features = hog_feature_vector(patch);
% %         features = opp_moments(patch);
%         features = Laws_Feature(patch,MaskMatrices);
%         feature_vectors1 = [feature_vectors1;features];
%     end
% end
% % third quarter
% if rows - ii > deltaD/2
%     for j=1:deltaD:jj
%         patch = I( ii+1:rows , j:(j+deltaD -1) ,:);
%         features = Laws_Feature(patch,MaskMatrices);
% %         features = hog_feature_vector(patch);
% %         features = opp_moments(patch);
%         feature_vectors1 = [feature_vectors1;features];
%     end
% end
% 
% % forth quarter
% if cols - jj > deltaD/2 && rows - ii > deltaD/2
%     patch = I( ii+1:rows , jj+1:cols , :);
%     features = Laws_Feature(patch,MaskMatrices);
% %         features = hog_feature_vector(patch);
% %         features = opp_moments(patch);
%     feature_vectors1 = [feature_vectors1;features];
% end

end

