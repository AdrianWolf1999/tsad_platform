function standardizedData = standardizeData(data, mu, sigma)
%STANDARDIZEDATA
%
% Standardizes the data to have a mean of 0 and std of 1


numChannels = size(data{1, 1}, 2);

for channelIdx = 1:numChannels
    if sigma(channelIdx) == 0
        % If data is a flat line, set mean to 0
        for dataIdx = 1:size(data, 1)
            newData = data{dataIdx, 1}(:, channelIdx);
            newData = newData - mu(channelIdx);
            data{dataIdx, 1}(:, channelIdx) = newData;
        end
    else
        for dataIdx = 1:size(data, 1)
            newData = data{dataIdx, 1}(:, channelIdx);
            newData = (newData - mu(channelIdx)) / sigma(channelIdx);
            data{dataIdx, 1}(:, channelIdx) = newData;
        end
    end
end

standardizedData = data;
end