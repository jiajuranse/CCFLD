function [ datapoints ] = createFeatureInputFast( data, offset, scale )

ids= 1:size(data, 1);
targets = zeros(size(data, 1));
names= zeros(size(data, 1));

[allFeatures, numThemes, rgbs, labs]= createFeaturesFromData(data,1000);

%set the output structure
datapoints=[];
datapoints.rgb=rgbs;
datapoints.lab=labs;
%datapoints.allFeatureNames=featureNames;
datapoints.allFeatures=allFeatures;
datapoints.ids=ids(1:numThemes);
datapoints.names=names(1:numThemes);
datapoints.targets=targets(1:numThemes);

datapoints.features=hueProb(reshape(squeeze(data)',[1,15]));
for i=1:size(datapoints.features,2)
    datapoints.features(:,i) =(datapoints.features(:,i)-offset(i));
    if scale(i) <= 0
        datapoints.features(:, i) = zeros(size(datapoints.features(:, i)));
    else
        datapoints.features(:,i) =datapoints.features(:,i)./scale(i);
    end
end

