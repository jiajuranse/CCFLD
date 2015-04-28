function [ mat ] = vectomat( vec )
%VECTOMAT 此处显示有关此函数的摘要
%   此处显示详细说明


mat = zeros(1, 5,3);
for i = 1:5
        for j = 1:3
            mat(1, i, j) = vec((i-1)*3+j);
        end
end
end

