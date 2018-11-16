function [ feature ] = opp_moments( im )
    im = im2double(im);
    R = im(:,:,1);
    G = im(:,:,2);
    B = im(:,:,3);
    
    O1 = (R-G)./sqrt(2);
    O2 = (R+G-2*B)./sqrt(6);
    O3 = (R+G+B)./sqrt(3);
    
    O1mean = mean(O1(:));
    O1std = std(O1(:));
    O1skew = skewness(O1(:));
    
    O2mean = mean(O2(:));
    O2std = std(O2(:));
    O2skew = skewness(O2(:));
    
    O3mean = mean(O3(:));
    O3std = std(O3(:));
    O3skew = skewness(O3(:));
    
    feature = [O1mean O1std O1skew O2mean O2std O2skew O3mean O3std O3skew];
    

end

