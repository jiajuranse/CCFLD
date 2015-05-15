
setupenv

for iter=1:3
    %%choose a dataset
    %dataset='mturkData'
    %dataset='kulerData'
    if iter == 1
        dataset='keting'
    elseif iter == 2
        dataset='chufang'
    elseif iter == 3
        dataset='canting'
    end
    
    
    maxNumberOfDatapoints=1000000;

    %create the datapoints and features
    datapoints = createFeatureMatrixFast(dataset,maxNumberOfDatapoints);
    %datapoints = createDatapoints(dataset,maxNumberOfDatapoints);
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
    %outputFileName = strcat('fit_', dataset, '.mat');
    %save outputFileName 'fit' 'offset' 'scale'
    
    fout = fopen(strcat('fit_', dataset, '.txt'), 'w');
    fprintf(fout, '%d %f\n', size(fit.beta,1), fit.a0);
    for i=1:size(fit.beta,1)
        fprintf(fout, '%f ', fit.beta(i));
    end
    fprintf(fout, '\n');
    for i=1:size(offset,2)
        fprintf(fout, '%f ', offset(i));
    end
    fprintf(fout, '\n');
    for i=1:size(offset,2)
        fprintf(fout, '%f ', scale(i));
    end
    fclose(fout);
end