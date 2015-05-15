[codeRoot,~,~] =  fileparts(mfilename('fullpath'))
codeRoot = strcat(codeRoot, '/');
addpath([codeRoot]);
addpath([codeRoot,'data/']);
addpath([codeRoot,'circstat/']);
addpath([codeRoot,'glmnet_matlab/']);
addpath([codeRoot,'themeUtil/']);

load hueProbsRGB
load kulerX
%load('fit.mat')
load('env.mat')