sssssssssssssssinput_file_name = 'C:\Users\Public\Pictures\Sample Pictures\Lighthouse.jpg';
origimg = imread(input_file_name);
[height, width, dim] = size(origimg);
inputimg = imresize(origimg, sqrt(100 * 100 /( height * width)));
rater = @(vec)glmnetPredict(fit, 'response',  getSingleSampleFeatures(vec, datapoints.offset, datapoints.scale));
gainer = @(x)themegain(rater, inputimg, x);
lb = zeros(1, 15);
ub = ones(1, 15);
result = patternsearch(gainer, 0.5*ub, [], [],[], [], lb, ub, [], psoptimset('CompletePoll ', 'on', 'Cache','on', 'CacheSize',1e6, 'Vectorized', 'on', 'TimeLimit',60*12));
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
subplot(2,1,1);
subimage(origimg);
subplot(2,1,2);
subimage(outputimg);