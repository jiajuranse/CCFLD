inputImagePath = 'D:\wty\sharedFolder\1.jpg';
patternImageSize = 600;
timeLimitSeconds = 60;
setupenv;
try
    origimg = imread(inputImagePath);
catch
    fprintf('not a valid image file, skip\n');
    return;
end
[height, width, dim] = size(origimg);
inputimg = imresize(origimg, sqrt(100 * 100 /( height * width)));
rater = @(vec)glmnetPredict(fit, 'response',  getSingleSampleFeatures(vec, offset, scale));
gainer = @(x)themegain(rater, inputimg, x);
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
imwrite(outputimg, strcat(inputImagePath, '.theme.png'));
input('hi')
system(['themeUtil\themesorter "', strcat(inputImagePath, '.theme.png"')])