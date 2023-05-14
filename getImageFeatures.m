function [F, I1, I2, I3] = getImageFeatures(I)
I_B = binarize(I);
[I1, I2, I3] = getComponents(I_B);
f1 = getFeature(I1);
f2 = getFeature(I2);
f3 = getFeature(I3);
F = [f1;f2;f3];
end

function [I1, I2, I3]=getComponents(IBW)
    components = bwconncomp(IBW,4);
    p = regionprops(components, 'BoundingBox');
    objNum = size(p, 1);
    if objNum >= 3 
        % Should not be greater than 3, but if it happens,
        % return the first 3 images instead of throwing an error
        BB1 = round(p(1).BoundingBox);
        BB2 = round(p(2).BoundingBox);
        BB3 = round(p(3).BoundingBox);
        I1 = IBW(BB1(2):BB1(2) + BB1(4), BB1(1): BB1(1) + BB1(3));
        I2 = IBW(BB2(2):BB2(2) + BB2(4), BB2(1): BB2(1) + BB2(3));
        I3 = IBW(BB3(2):BB3(2) + BB3(4), BB3(1): BB3(1) + BB3(3));
    elseif objNum == 2
        BB1 = round(p(1).BoundingBox);
        BB2 = round(p(2).BoundingBox);
        if BB1(3) > BB2(3)
            I1 = IBW(BB1(2): BB1(2) + BB1(4), BB1(1): BB1(1) + round(BB1(3)/2));
            I2 = IBW(BB1(2): BB1(2) + BB1(4), BB1(1) + round(BB1(3)/2): BB1(1) + BB1(3));
            I1 = removeBlackRows(I1);
            I2 = removeBlackRows(I2);
            I3 = IBW(BB2(2): BB2(2) + BB2(4), BB2(1): BB2(1) + BB2(3));
        else
            I2 = IBW(BB2(2): BB2(2) + BB2(4), BB2(1): BB2(1) + round(BB2(3)/2));
            I2 = removeBlackRows(I2);
            I3 = IBW(BB2(2): BB2(2) + BB2(4), BB2(1) + round(BB2(3)/2): BB2(1) + BB2(3));
            I3 = removeBlackRows(I3);
            I1 = IBW(BB1(2): BB1(2) + BB1(4), BB1(1): BB1(1) + BB1(3));
        end
    elseif objNum == 1
        BB = round(p(1).BoundingBox);
        w = BB(3);       
        I1 = IBW(BB(2): BB(2) + BB(4), BB(1): BB(1) +round(w/3));
        I1 = removeBlackRows(I1);
        I2 = IBW(BB(2): BB(2) + BB(4), BB(1) + round(w/3): BB(1) + round(2 * (w/3)));
        I2 = removeBlackRows(I2);
        I3 = IBW(BB(2): BB(2) + BB(4), BB(1) + round(2* (w/3)): BB(1) + w);
        I3 = removeBlackRows(I3);
    else
        % Should not be here, but s*** happens
        I1 = IBW;
        I2 = IBW;
        I3 = IBW;
    end
       
end

function f = getFeature(I)
    I = imresize(I,[25 25]);
    f = I(:)';
end


function I2=removeBlackRows(I)
I2 = I(any(I, 2),:);
end