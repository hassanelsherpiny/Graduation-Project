function lesionSegmented = RegionGrowingModified( img, thresholdValue )
    %Threshold default value is 0.015

    
    im=im2double(img);
    [r,c]=size(im);
    A=zeros(r,c); % segmented mask
    s=[floor(r/2),floor(c/2)];      % Default starting position is the center
    A(s(1),s(2))=1;
    
    F=[]; % frontier list
    F=[F;s];
    while(~isempty(F)) % if frontier is empty
        n=neighbours(F(1,1),F(1,2),r,c);   % 4 neighbourhood
        for i=1:size(n,1)
            if(abs(im(F(1,1),F(1,2))-im(n(i,1),n(i,2)))<thresholdValue && A(n(i,1),n(i,2))~=1)
                % less than threshold & not already segmented
                A(n(i,1),n(i,2))=1;
                F=[F;n(i,1),n(i,2)];
            end
        end
        F(1,:)=[];
    end
    lesionSegmented = A;
end

function out=neighbours(s1,s2,r,c)
    out=[];
    if(s2>1),  out=[out;s1,s2-1];   end
    if(s1>1),  out=[out;s1-1,s2];   end
    if(s1<r),  out=[out;s1+1,s2];   end
    if(s2<c),  out=[out;s1,s2+1];   end
end