function trainedModels_S = trainModels_S(models, trainingData, testValData, testValLabels, thresholds)
for i = 1:length(models)
    options = models(i).options;
    
    [XTrain, XVal] = prepareDataTrain_S(options, trainingData);

    Mdl = trainS(options, XTrain);

    [staticThreshold, pd] = getStaticThreshold_S(options, Mdl, XTrain, XVal, testValData, testValLabels, thresholds);

    trainedModel.staticThreshold = staticThreshold;
    trainedModel.options = options;
    trainedModel.Mdl = Mdl;    
    trainedModel.pd = pd;
    
    trainedModels_S.(models(i).options.id) = trainedModel;
end
end
