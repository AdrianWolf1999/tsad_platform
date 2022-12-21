function trainedModels = trainModels_DNN_Parallel(models, dataTrain, labelsTrain, dataValTest, labelsValTest, thresholds, closeOnFinished)
%TRAINMODELS_DNN_PARALLEL
%
% Trains all DL models in parallel and calculates the thresholds

numNetworks = length(models);

XTrainCell = cell(1, numNetworks);
YTrainCell = cell(1, numNetworks);
XValCell = cell(1, numNetworks);
YValCell = cell(1, numNetworks);

for i = 1:numNetworks
    options = models(i).options;

    switch options.requiresPriorTraining
        case true
            if isempty(dataTrain)
                error("One of the selected models requires prior training, but the dataset doesn't contain training data (train folder).")
            end
            
            [XTrain, YTrain, XVal, YVal] = prepareDataTrain_DNN(options, dataTrain, labelsTrain);
        case false
            % Not yet implemented
    end

    XTrainCell{i} = XTrain{1};
    YTrainCell{i} = YTrain{1};
    XValCell{i} = XVal{1};
    YValCell{i} = YVal{1};
end

[Mdls, MdlInfos] = trainDNN_Parallel(models, XTrainCell, YTrainCell, XValCell, YValCell, closeOnFinished);

for i = 1:numel(models)
    options = models(i).options;

    switch options.requiresPriorTraining
        case true
            if ~isequal(XVal{1, 1}, 0)
                pd = getProbDist(options, Mdls{i}, XValCell(i), convertYForTesting(YValCell(i), options.modelType, options.isMultivariate, options.hyperparameters.data.windowSize.value));
            else
                pd = getProbDist(options, Mdls{i}, XTrainCell(i), convertYForTesting(YTrainCell(i), options.modelType, options.isMultivariate, options.hyperparameters.data.windowSize.value));
            end

            staticThreshold = getStaticThreshold_DNN(options, Mdls{i}, XTrainCell(i), YTrainCell(i), XValCell(i), YValCell(i), dataValTest, labelsValTest, thresholds, pd);
        case false
            % Not yet implemented
    end


    trainedNetwork.Mdl = Mdls{i};
    trainedNetwork.MdlInfo = MdlInfos{i};
    trainedNetwork.options = options;
    trainedNetwork.staticThreshold = staticThreshold;
    trainedNetwork.pd = pd;

    trainedModels.(options.id) = trainedNetwork;
end
end                              
