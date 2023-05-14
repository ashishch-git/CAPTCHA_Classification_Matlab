function I_M=binarize(I)

IG = imgaussfilt(I, 1);

seg = kmeans(double(reshape(IG, [], 3)), 2, Distance="sqeuclidean");
seg = reshape(seg, size(IG, [1:2]));

if numel(find(seg == 1)) > numel(find(seg == 2)) 
    fgLabel = 2;
else
    fgLabel = 1;
end

fg = (seg == fgLabel);

I_BW = fg;

I_M = imerode(I_BW, strel('disk',4));

I_M = bwareaopen(I_M,300);

I_M = imdilate(I_M, strel('disk',3));

end