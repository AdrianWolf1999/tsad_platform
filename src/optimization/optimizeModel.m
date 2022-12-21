function results = optimizeModel(optVars, models, dataTrain, labelsTrain, dataValTest, labelsValTest, dataTest, labelsTest, thresholds, cmpScore, iterations, trainingPlots, exportLogData)
%OPTIMIZEMODEL
%
% Main optimization function which calls the bayesopt() function

optVariables = [];
optVarNames = fieldnames(optVars);
for i = 1:length(optVarNames)
    optVariables = [optVariables optimizableVariable(optVarNames{i}, ...
        optVars.(optVarNames{i}).value, 'Type', optVars.(optVarNames{i}).type)];
end

fun = @(x)opt_fun(models, ...
    dataTrain, ...
    labelsTrain, ...
    dataValTest, ...
    labelsValTest, ...
    dataTest, ...
    labelsTest, ...
    thresholds, ...
    cmpScore, ...
    x, ...
    trainingPlots, ...
    exportLogData);

results = bayesopt(fun, optVariables, Verbose=0,...
    AcquisitionFunctionName='expected-improvement-plus', ...
    MaxObjectiveEvaluations=iterations, ...
    IsObjectiveDeterministic=false);
end