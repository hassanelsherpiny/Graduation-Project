function lesionSegmented = Segmentation( imgPath)

    p_sz_thr = 500;
    n_sz_thr = 1500;
    img = imread(imgPath);

    % Resize image
    initialSize = size(im2bw(img));
    img=imresize(img,512/size(img,1));
    
    % Convert to grayscale
    imgbw=rgb2gray(img);

    %% Analyze

    % Binarize using Otsu's method
    img_bn=~(im2bw(imgbw,graythresh(imgbw))); % Skin lesions are darker

    %% Small region removal
    img_bns=img_bn;

    % Small region removal on positive image
    img_lbl=bwlabel(img_bns,4);
    bins=1:max(img_lbl(:));
    a=histc(img_lbl(:),bins);
    blist=bins(a<p_sz_thr);
    img_bns(ismember(img_lbl,blist))=0;


    % Small region removal on negative image
    img_lbl=bwlabel(~img_bns,4);
    bins=1:max(img_lbl(:));
    a=histc(img_lbl(:),bins);
    blist=bins(a<n_sz_thr);
    img_bns(ismember(img_lbl,blist))=1;

    %% Identify primary region of interest
    % Look for the connected component closest to center of image

    img_x0=size(imgbw,2)/2;
    img_y0=size(imgbw,1)/2;
    img_lbl=bwlabel(img_bns,4);
    stats=regionprops(img_lbl,'Centroid');
    mindist=inf;
    for rgn=1:numel(stats)
        dist=sqrt(((stats(rgn).Centroid(1)-img_x0)^2) + ...
            ((stats(rgn).Centroid(2)-img_y0)^2));
        if dist<mindist
            mindist=dist;
            minrgn=rgn;
        end
    end

    img_pr=img_bns;
    img_pr(img_lbl~=minrgn)=0;
    lesionSegmented = imresize(img_pr, initialSize);
    
end

