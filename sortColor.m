function [ outputColors ] = sortColor( inputColors )
outputColors = inputColors;
for i = 1:5
    for j = 1:4
        for k = 1:3
            if outputColors(j) > outputColors(j + 1)
                outputColors([j, j+1], :) = outputColors([j+1, j], :);
                break;
            elseif outputColors(j) < outputColors(j + 1)
                break;
            end
        end
    end
end
end

