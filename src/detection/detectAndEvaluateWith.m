function scores = detectAndEvaluateWith(model, testingData, testingLabels)
options = model.options;
switch model.options.type
    case 'DNN'
        Mdl = model.Mdl;

        [XTest, YTest, labels] = prepareDataTest_DNN(options, testingData, testingLabels);
            
        [anomalyScores, YTest, labels] = detectWithDNN(options, Mdl, XTest, YTest, labels);
    
        staticThreshold = model.staticThreshold;
        
        thrFields = fieldnames(staticThreshold);
        selectedThreshold = staticThreshold.(thrFields{1});

        if endsWith(thrFields{1}, 'Parametric')
            pd = model.pd;
            parametric = true;
        else
            pd = 0;
            parametric = false;
        end
    
        anomsStatic = calcStaticThresholdPrediction(anomalyScores, selectedThreshold, pd, parametric);
        [scoresPointwiseStatic, scoresEventwiseStatic, ...
            scoresPointAdjustedStatic, compositeFScoreStatic] = calcScores(anomsStatic, labels);
    
        padding = 3;
        windowSize = floor(size(YTest{1, 1}, 1) / 2);           
        z_range = 1:2;
        min_percent = 1;
    
        [anomsDynamic, ~] = calcDynamicThresholdPrediction(anomalyScores, labels, padding, ...
            windowSize, min_percent, z_range);
        [scoresPointwiseDynamic, scoresEventwiseDynamic, ...
            scoresPointAdjustedDynamic, compositeFScoreDynamic] = calcScores(anomsDynamic, labels);
    case 'CML'
        Mdl = model.Mdl;
        
        [XTest, labels] = prepareDataTest_CML(options, testingData, testingLabels);
        
        [anomalyScores, ~, labels] = detectWithCML(options, Mdl, XTest, labels);
        
        staticThreshold = model.staticThreshold;

        thrFields = fieldnames(staticThreshold);
        selectedThreshold = staticThreshold.(thrFields{1});

        if endsWith(thrFields{1}, 'Parametric')
            pd = model.pd;
            parametric = true;
        else
            pd = 0;
            parametric = false;
        end
        
        anomsStatic = calcStaticThresholdPrediction(anomalyScores, selectedThreshold, pd, parametric);
        [scoresPointwiseStatic, scoresEventwiseStatic, ...
            scoresPointAdjustedStatic, compositeFScoreStatic] = calcScores(anomsStatic, labels);
        
        padding = 3;
        windowSize = floor(size(XTest, 1) / 2);           
        z_range = 1:2;
        min_percent = 1;
        
        [anomsDynamic, ~] = calcDynamicThresholdPrediction(anomalyScores, labels, padding, ...
            windowSize, min_percent, z_range);
        [scoresPointwiseDynamic, scoresEventwiseDynamic, ...
            scoresPointAdjustedDynamic, compositeFScoreDynamic] = calcScores(anomsDynamic, labels);

    case 'S'
        Mdl = model.Mdl;
        
        [XTest, labels] = prepareDataTest_S(options, testingData, testingLabels);
        
        [anomalyScores, ~, labels] = detectWithS(options, Mdl, XTest, labels);
        
        staticThreshold = model.staticThreshold;

        thrFields = fieldnames(staticThreshold);
        selectedThreshold = staticThreshold.(thrFields{1});

        if endsWith(thrFields{1}, 'Parametric')
            pd = model.pd;
            parametric = true;
        else
            pd = 0;
            parametric = false;
        end

        anomsStatic = calcStaticThresholdPrediction(anomalyScores, selectedThreshold, pd, parametric);
        [scoresPointwiseStatic, scoresEventwiseStatic, ...
            scoresPointAdjustedStatic, compositeFScoreStatic] = calcScores(anomsStatic, labels);
        
        padding = 3;
        windowSize = floor(size(XTest, 1) / 2);           
        z_range = 1:2;
        min_percent = 1;
        
        [anomsDynamic, ~] = calcDynamicThresholdPrediction(anomalyScores, labels, padding, ...
            windowSize, min_percent, z_range);
        [scoresPointwiseDynamic, scoresEventwiseDynamic, ...
            scoresPointAdjustedDynamic, compositeFScoreDynamic] = calcScores(anomsDynamic, labels);

end

scores = [compositeFScoreStatic; ...
            scoresPointwiseStatic(3); ...
            scoresEventwiseStatic(3); ...
            scoresPointAdjustedStatic(3); ...
            scoresPointwiseStatic(4); ...
            scoresEventwiseStatic(4); ...
            scoresPointAdjustedStatic(4); ...
            scoresPointwiseStatic(1); ...
            scoresEventwiseStatic(1); ...
            scoresPointAdjustedStatic(1); ...
            scoresPointwiseStatic(2); ...
            scoresEventwiseStatic(2); ...
            scoresPointAdjustedStatic(2); ...
            compositeFScoreDynamic; ...
            scoresPointwiseDynamic(3); ...
            scoresEventwiseDynamic(3); ...
            scoresPointAdjustedDynamic(3); ...
            scoresPointwiseDynamic(4); ...
            scoresEventwiseDynamic(4); ...
            scoresPointAdjustedDynamic(4); ...
            scoresPointwiseDynamic(1); ...
            scoresEventwiseDynamic(1); ...
            scoresPointAdjustedDynamic(1); ...
            scoresPointwiseDynamic(2); ...
            scoresEventwiseDynamic(2); ...
            scoresPointAdjustedDynamic(2)];
end