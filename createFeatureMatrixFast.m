function [datapoints] = createFeatureMatrixFast(datasetName,maxDatapoints)
load(datasetName)
%only test on themes with >=100 views
if strcmp(datasetName,'colorLoversData')
    data=data(views>=100,:,:)/256.0;
    ids=ids(views>=100);
    targets=targets(views>=100);
    names=names(views>=100);
end
%Randomize the data
randomize=randperm(length(targets));
data=data(randomize,:,:);
ids=ids(randomize);
targets=targets(randomize);
names=names(randomize);
%[allFeatures numThemes rgbs labs]= createFeaturesFromData(data,maxDatapoints);

numThemes = min(maxDatapoints, length(targets));
testFeature = hueProb(data(1,:));

datapoints=[];
datapoints.features = zeros(numThemes, length(testFeature));
for i=1:numThemes
    datapoints.features(i,:) = hueProb(data(i,:));
end

offsets=[];
scales=[];
for i=1:size(datapoints.features,2)
    minfeat = min(datapoints.features(:,i));
    maxfeat = max(datapoints.features(:,i));

    offsets(i)=minfeat;
    scales(i)=(maxfeat-minfeat);

    datapoints.features(:,i) =(datapoints.features(:,i)-minfeat);
    datapoints.features(:,i) =datapoints.features(:,i)./(maxfeat-minfeat);
    if scales(i) == 0
        scales(i) = -1;
        datapoints.features(:,i) = zeros(size(datapoints.features(:, i)));
    end
end
datapoints.offset = offsets;
datapoints.scale = scales;


%set the output structure
%datapoints.rgb=rgbs;
%datapoints.lab=labs;
%datapoints.allFeatureNames=featureNames;
%datapoints.allFeatures=allFeatures;
datapoints.ids=ids(1:numThemes);
datapoints.names=names(1:numThemes);
datapoints.targets=targets(1:numThemes);
%[datapoints.features datapoints.offset datapoints.scale]=createFeatureMatrix(datapoints,{'*'},1);
end