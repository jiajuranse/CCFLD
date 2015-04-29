%This is supplementary code for SIGGRAPH submission #248
%Color Compatibility for Large Datasets
%This code/data is not yet public. Please do not distribute.
%January 16, 2011

setupenv
%set the code directory...
[codeRoot,~,~] =  fileparts(mfilename('fullpath'))
codeRoot = strcat(codeRoot, '/');
addpath([codeRoot])
addpath([codeRoot,'data/'])
addpath([codeRoot,'circstat/'])
addpath([codeRoot,'glmnet_matlab/'])

%%choose a dataset
%dataset='mturkData'
%dataset='kulerData'
dataset='keting'
maxNumberOfDatapoints=10000;

%create the datapoints and features
datapoints = createDatapoints(dataset,maxNumberOfDatapoints);

%train LASSO regressor
options=glmnetSet();  
%this parameter set through cross-validation to minimize regression error 
%increase the value if you want a sparser solution (ie, more zero weights)
options.lambda=1.6e-004;

%This has been tested on Matlab 2008 and 2010 on windows XP.
%If you are running this on MacOS or Linux, you may have to compile the mex
%file with a fortran compiler. Please see the readme in the glmnet folder

fit = glmnet(datapoints.features, datapoints.targets,'gaussian',options);
offset = datapoints.offset;
scale = datapoints.scale;
save 'fit.mat' 'fit' 'offset' 'scale'