rootDir = 'D:\wty\data\themegen\testcase'%'D:\wty\data\newImages';
timeLimitSeconds = 60;

fileList = getAllFiles(rootDir);
themetxtfile = fopen(strcat(rootDir, 'extract.txt'), 'w');
fprintf('%d files detected\n', length(fileList));
for file_iter = 1:length(fileList)
    filePath = fileList(file_iter);
    filePath = filePath{1};
    len = length(filePath);
    if (strcmp(filePath(len - 3:len), '.png') == 1)
        continue;
    end
    if exist(strcat(filePath, '.theme.keting.png'), 'file')
        continue;
    end
    fprintf('processing %s\n', filePath);
    try
        origimg = imread(filePath);
    catch
        fprintf('not a valid image file, skip\n');
        continue;
    end
    [height, width, dim] = size(origimg);
    inputimg = imresize(origimg, sqrt(100 * 100 /( height * width)));
    rater = @(vec)glmnetPredict(fit, 'response',  getSingleSampleFeatures(vec, datapoints.offset, datapoints.scale));
    gainer = @(x)themegain(rater, inputimg, x);
    lb = zeros(1, 15);
    ub = ones(1, 15);
    result = patternsearch(gainer, 0.5*ub, [], [],[], [], lb, ub, [], psoptimset('CompletePoll ', 'on', 'Cache','on', 'CacheSize',1e6, 'Vectorized', 'on', 'TimeLimit',timeLimitSeconds*12));
    outputimg = zeros(50, 50, 3, 'uint8');
    for i=1:5
        for j = 1:3
            for x=10*(i-1)+1:10*i
                for y = 1:50
                    outputimg(y, x, j) = uint8(result((i-1)*3+j)*256);
                end
            end
        end
    end
    imwrite(outputimg, strcat(filePath, '.theme.keting.png'));
    %fprintf(themetxtfile, '%s ', filePath);
    %for i=1:15
        %fprintf(themetxtfile, '%d ', uint8(result(i)*256));
    %end
    %fprintf(themetxtfile, '%f\n', rater(vectomat(result)));
end