function trainedModels = trainingWrapper(models, dataTrain, labelsTrain, dataTestVal, labelsTestVal, thresholds, trainingPlots, parallelEnabled)
%TRAINMODELS Main wrapper function for training models and calculating static thresholds

trainedModelsCell = cell(length(models), 1);
if parallelEnabled
    parfor model_idx = 1:length(models)
        trainedModelsCell{model_idx, 1} = trainModel(models(model_idx).modelOptions, dataTrain, labelsTrain, dataTestVal, labelsTestVal, thresholds, trainingPlots, false);
    end
else
    for model_idx = 1:length(models)
        trainedModelsCell{model_idx, 1} = trainModel(models(model_idx).modelOptions, dataTrain, labelsTrain, dataTestVal, labelsTestVal, thresholds, trainingPlots, true);
    end
end

for model_idx = 1:length(models)
    trainedModels.(trainedModelsCell{model_idx, 1}.modelOptions.id) = trainedModelsCell{model_idx, 1};
end

% Delete parallel pool
if ~isempty(gcp('nocreate'))
    delete(gcp('nocreate'));
end
end