for iter = 1:3
    load('data/colorLoversData.mat');    
    if iter == 1
        category='keting'
    elseif iter == 2
        category = 'chufang'
    else
        category='canting'
    end
    dataInputFileName = strcat(category, '.txt');
    inputFileHandle = fopen(dataInputFileName, 'r');
    gainterm = zeros(size(data, 1), 1);
    data = data / 256;
    std(targets)
    while(1)
        [A, count] = fscanf(inputFileHandle, '%f', 16);
        if count < 16
            break
        end
        A = vec2mat(A(1:15) / 256.0, 3);
        for i=1:size(gainterm, 1)   
            distance =  norm(data(i, :)' - A(:));
            gain = gaussmf(distance, [0.5, 0]);
            if gain > gainterm(i, 1)
                gainterm(i, 1) = gain;
            end
        end
    end
    for i=1:size(gainterm, 1)
        targets(i) = 0.8 * targets(i) + gainterm(i, 1);
    end
    targetMatFileName = strcat(category, '.mat');
save(targetMatFileName,'views','hearts','data','ids','targets','names');
end