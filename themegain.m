function [ gain ] = themegain(rater, img, x, trans )
alpha = 3;
[~, ~, dim] = size(img);
assert(dim == 3);
nvecs = size(x, 1);
gain = zeros(nvecs, 1);
colorVec = zeros(1, 15,'uint8');
raterVec = zeros(nvecs, 5,3);
for veciter = 1:nvecs
    for i = 1:5
        for j = 1:3
            colorVec((i - 1) * 3 + j) = uint8(x(veciter, (i-1)*3+j) * 256);
            raterVec(veciter, i, j) = x(veciter, (i-1)*3+j);
        end
    end
    if (nargin == 4)
        gain(veciter) = main(img, colorVec, trans);
    else
        gain(veciter) = main(img, colorVec);
    end
end
%gain = gain - alpha * rater(raterVec);
end

