function XTrain = prepareDataTrain_S(options, data)
%PREPAREDATATRAIN_S
%
% Prepares the training data for statistical models

switch options.model
    case 'Your model'
    otherwise
        if options.useSubsequences
            [XTrain, ~, ~, ~] = splitDataTrain(data, ...
                options.hyperparameters.data.windowSize.value,  ...
                options.hyperparameters.data.stepSize.value,  ...
                1, 'reconstructive', options.dataType);
        else
            XTrain = cell2mat(data);
        end
end
end
