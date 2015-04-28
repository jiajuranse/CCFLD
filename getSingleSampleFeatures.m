function [ features ] = getSingleSampleFeatures( datapoint, offset, scale )
%GETSINGLESAMPLEFEATURES 此处显示有关此函数的摘要
%   此处显示详细说明
features = CreateDataPointInput(datapoint, offset, scale);
features = features.features;

end

