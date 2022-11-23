function bestOptions = autoOptimization(models, dataTrain, labelsTrain, dataValTest, labelsValTest, dataTest, labelsTest, ratioValTest, configOptFileName, cmpScore, threshold, iterations)
%AUTOOPTIMIZATION
%
% Runs the auto-optimization for all selected models

bestOptions_DNN = [];
bestOptions_CML = [];
bestOptions_S = [];

for i = 1:length(models)
    % Load hyperparameters to be optimized
    optVars = getOptimizationVariables(models(i).options.model, configOptFileName);
    
    % If no hyperparameters are available for the model, save default
    % options
    if isempty(optVars)
        bestOptions_tmp.options = models(i).options;
        switch models(i).options.type
            case 'DNN'
                bestOptions_DNN = [bestOptions_DNN; bestOptions_tmp];
            case 'CML'
                bestOptions_CML = [bestOptions_CML; bestOptions_tmp];
            case 'S'
                bestOptions_S = [bestOptions_S; bestOptions_tmp];
        end
        continue;
    end
    
    % Optimization
    results = optimizeModel(optVars, models(i), dataTrain, ...
                            labelsTrain, dataValTest, labelsValTest, ...
                            dataTest, labelsTest, ...
                            ratioValTest, threshold, cmpScore, iterations, true);

    optimumVars = results.XAtMinObjective;
    
    bestOptions_tmp.options = adaptModelOptions(models(i).options, optimumVars);
    switch models(i).options.type
        case 'DNN'
            bestOptions_DNN = [bestOptions_DNN; bestOptions_tmp];
        case 'CML'
            bestOptions_CML = [bestOptions_CML; bestOptions_tmp];
        case 'S'
            bestOptions_S = [bestOptions_S; bestOptions_tmp];
    end
end

if ~isempty(bestOptions_DNN)
    bestOptions.DNN_Models = bestOptions_DNN;
end
if ~isempty(bestOptions_CML)
    bestOptions.CML_Models = bestOptions_CML;
end
if ~isempty(bestOptions_S)
    bestOptions.S_Models = bestOptions_S;
end
end