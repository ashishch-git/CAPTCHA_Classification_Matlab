function S = myclassifier(im)
global Mdl
f = getImageFeatures(im);
S = Mdl.predict(double(f));
S = S';
end

