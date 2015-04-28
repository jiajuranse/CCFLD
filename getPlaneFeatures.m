function [normal pctExplained meanX sse] = getPlaneFeatures(X)

[~,coeff,roots, meanX, demeaned] = pca2(X');

normal = coeff(:,3);

if (normal(1)<0)
    normal = normal.*-1;
end

if (sum(roots)==0)
    pctExplained = [0 0 0];
else
    pctExplained = roots' ./ sum(roots);
end;
[n,~] = size(X);
meanX = meanX';

error = abs(demeaned'*normal);
sse = sum(error.^2);