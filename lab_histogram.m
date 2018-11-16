function [ feature ] = lab_histogram( im )
%LAB_HISTOGRAM Summary of this function goes here
%   Detailed explanation goes here
    nBins = 15;
%     im = im2double(im);
%     im = rgb2lab(im);
    L = im(:,:,1);
    a = im(:,:,2);
    b = im(:,:,3);
    
    min_elm = min(min(L));
    max_elm = max(max(L));
    diff = max_elm - min_elm;
    for i=1:size(L,1)
        for j=1:size(L,2)
            L(i,j) = (L(i,j) - min_elm) / diff;
        end
    end
%     vector = [];
%     for i=1:size(L,1)
%         vector = [vector;L(i,:)];
%     end
    [N,E] = histcounts(L,nBins);
    feature = N;
    
    min_elm = min(min(a));
    max_elm = max(max(a));
    diff = max_elm - min_elm;
    for i=1:size(a,1)
        for j=1:size(a,2)
            a(i,j) = (a(i,j) - min_elm) / diff;
        end
    end
%     vector = [];
%     for i=1:size(a,1)
%         vector = [vector;a(i,:)];
%     end
    [N,E] = histcounts(a,nBins);
    feature = [feature N];
    
    min_elm = min(min(b));
    max_elm = max(max(b));
    diff = max_elm - min_elm;
    for i=1:size(b,1)
        for j=1:size(b,2)
            b(i,j) = (b(i,j) - min_elm) / diff;
        end
    end
%     vector = [];
%     for i=1:size(b,1)
%         vector = [vector;b(i,:)];
%     end
    [N,E] = histcounts(b,nBins);
    feature = [feature N];
end

