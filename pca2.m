function [signals,PC,V, meanx, demeaned] = pca2(data)
% PCA2: Perform PCA using SVD.
% data - MxN matrix of input data
% (M dimensions, N trials)
% signals - MxN matrix of projected data
% PC - each column is a PC
% V - Mx1 matrix of variances
[M,N] = size(data);
% subtract off the mean for each dimension
meanx = mean(data,2);
demeaned = data - repmat(meanx,1,N);
% construct the matrix Y
Y = demeaned' / sqrt(N-1);
% SVD does it all
[u,S,PC] = svd(Y);
% calculate the variances
S = diag(S);
V = S .* S;
% project the original data
signals = PC' * demeaned;