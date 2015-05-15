%themeBatch
for iter = 1:3
    if iter == 1
        category='keting'
    elseif iter == 2
        category = 'chufang'
    else
        category='canting'
    end
    rootDir=strcat('D:\wty\data\themegen\imageDB\', category);
    fileList = getAllFiles(rootDir);
    outputFD = fopen(strcat(category, '.txt'), 'w')
    for file_iter = 1:length(fileList)
        filePath = fileList(file_iter);
        filePath = filePath{1};
        len = length(filePath);
        if (strcmp(filePath(len - 3:len), '.txt') ~= 1)
            continue;
        end
        inputFileHandle = fopen(filePath, 'r');
        [A, count] = fscanf(inputFileHandle, '%d', 15);
        fclose(inputFileHandle)
        fprintf(outputFD, '%d ', A);
        fprintf(outputFD, '\n');
    end
    fclose('all')
end
mixDataBase