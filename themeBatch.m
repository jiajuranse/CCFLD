rootDir = 'D:\wty\data\themegen\imageDB'
patternImageSize = 500;
timeLimitSeconds = 90;
setupenv

fileList = getAllFiles(rootDir);
themetxtfile = fopen(strcat(rootDir, 'extract.txt'), 'w');
fprintf('%d files detected\n', length(fileList));
parfor file_iter = 1:length(fileList)
    filePath = fileList(file_iter);
    filePath = filePath{1};
    len = length(filePath);
    if (strcmp(filePath(len - 9:len), '.theme.png') == 1)
        continue;
    end
    if (strcmp(filePath(len - 8:len), '.mask.png') == 1)
        continue;
    end
    %if exist(strcat(filePath, '.theme.png'), 'file')
%        fileInfo = dir(strcat(filePath, '.theme.png'));
%        fileSize = fileInfo.bytes;
%        if fileSize > 10
%            continue;
%        end
%    end
    fprintf('processing %s\n', filePath);
    try
        [origimg, map, trans] = imread(filePath);
        if (~isa(origimg, 'uint8'))
            origimg = im2uint8(origimg);
            trans = im2uint8(trans);
        end
    catch
        fprintf('not a valid image file, skip\n');
        continue;
    end
    [height, width, dim] = size(origimg);
    inputimg = imresize(origimg, sqrt(150 * 150 /( height * width)));
    if (size(trans, 1) > 1)
        trans = imresize(trans, sqrt(150 * 150 /( height * width)));
    end
    
    rater = @(vec)glmnetPredict(fit, 'response',  getSingleSampleFeatures(vec, offset, scale));
    if (size(trans, 1) > 1)
        gainer = @(x)themegain(rater, inputimg, x, trans);
    else
        gainer = @(x)themegain(rater, inputimg, x);
    end
    lb = zeros(1, 15);
    ub = ones(1, 15);
    result = patternsearch(gainer, 0.5*ub, [], [],[], [], lb, ub, [], psoptimset('CompletePoll ', 'on', 'Cache','on', 'CacheSize',1e6, 'Vectorized', 'on', 'TimeLimit',timeLimitSeconds*12));
    outputimg = zeros(patternImageSize, patternImageSize, 'uint8');
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