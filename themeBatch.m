rootDir = 'D:\wty\data\themegen\testcase'%'D:\wty\data\newImages';
patternImageSize = 50;
timeLimitSeconds = 60;
setupenv

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
    if exist(strcat(filePath, '.theme.png'), 'file')
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
    rater = @(vec)glmnetPredict(fit, 'response',  getSingleSampleFeatures(vec, offset, scale));
    gainer = @(x)themegain(rater, inputimg, x);
    lb = zeros(1, 15);
    ub = ones(1, 15);
    result = patternsearch(gainer, 0.5*ub, [], [],[], [], lb, ub, [], psoptimset('CompletePoll ', 'on', 'Cache','on', 'CacheSize',1e6, 'Vectorized', 'on', 'TimeLimit',timeLimitSeconds*12));
    outputimg = zeros(patternSize, patternSize, 'uint8');
    for i=1:5
        for j = 1:3
            for x=uint32(patternImageSize / 5) * (i-1)+1:uint32(patternImageSize / 5)*i
                for y = 1:patternImageSize
                    outputimg(y, x, j) = uint8(result((i-1)*3+j)*256);
                end
            end
        end
    end
    imwrite(outputimg, strcat(filePath, '.theme.png'));
    system(['themeUtil\themesorter "', strcat(filePath, '.theme.png"')]);
end