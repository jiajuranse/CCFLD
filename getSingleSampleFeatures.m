function [ features ] = getSingleSampleFeatures( datapoint, offset, scale )
%GETSINGLESAMPLEFEATURES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
features = CreateDataPointInput(datapoint, offset, scale);
features = features.features;

end

