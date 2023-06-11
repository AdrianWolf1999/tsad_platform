function scores = detectAndEvaluateWith(trainedModel, dataTest, labelsTest, threshold, dynamicThresholdSettings)
%DETECTANDEVALUATEWITH Runs the detection and returns the scores (not anomaly scores but performance metrics) for the model

fprintf("Detecting with: %s\n", trainedModel.modelOptions.label);

[XTest, TSTest, labels] = dataTestPreparationWrapper(trainedModel.modelOptions, dataTest, labelsTest);
    
anomalyScores = detectionWrapper(trainedModel, XTest, TSTest, labels);

if ~trainedModel.modelOptions.outputsLabels
    [predictedLabels, ~] = applyThresholdToAnomalyScores(trainedModel, anomalyScores, labels, threshold, dynamicThresholdSettings);
else
    predictedLabels = anomalyScores;
end

scores = computeMetrics(anomalyScores, predictedLabels, labels);
end