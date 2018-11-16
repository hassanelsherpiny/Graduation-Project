function [ feature ] = Laws_Feature( im,MaskMatrices )
%LAWS_FEATURE Summary of this function goes here
%   Detailed explanation goes here
    newIm = double(rgb2gray(im));
    numOfPixels = numel(newIm);
    numOfMasks = 9;
    feature = [];
    for i=1:numOfMasks
        h = MaskMatrices(:,:,i);
        convMat = conv2(newIm,h,'same');
        E = 0;
        for row=1:size(convMat,1)
            for col=1:size(convMat,2)
                E = E + abs(convMat(row,col));
            end
        end
%         numOfPixels = numel(convMat)
        mean = E/numOfPixels;
        std = sqrt((E-mean)/numOfPixels);
        feature = [feature mean std];
    end
end

