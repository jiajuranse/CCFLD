function [ mat ] = vectomat( vec )
%VECTOMAT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


mat = zeros(1, 5,3);
for i = 1:5
        for j = 1:3
            mat(1, i, j) = vec((i-1)*3+j);
        end
end
end

