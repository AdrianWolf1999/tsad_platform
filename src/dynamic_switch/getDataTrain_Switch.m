function [XTrain, labelName] = getDataTrain_Switch(datasetPath)
%GETDATATRAIN_SWITCH
%
% Prepares the training data for the dynamic switch ba extracting the time
% series features

labelName = 'best_model';

trainSwitchPath = fullfile(datasetPath, 'train_switch');

fid = fopen(fullfile(datasetPath, 'preprocParams.json'));
raw = fread(fid, inf);
str = char(raw');
fclose(fid);
preprocParams = jsondecode(str);


labelFile = fullfile(trainSwitchPath, 'best_models.json');
fid = fopen(labelFile);
raw = fread(fid, inf);
str = char(raw');
fclose(fid);
labels = jsondecode(str);

fields = fieldnames(labels);

XTrain = [];

for i = 1:numel(fields)    
    dataFile = fullfile(trainSwitchPath, sprintf('%s.csv', fields{i}));    

    data = readtable(dataFile);
    
    % Preprocessing
    trainData = cell(1, 1);
    trainData{1, 1} = data{:, 2};
    [trainData, ~] = preprocessData(trainData, {}, preprocParams.method, true, preprocParams);    
    
    % Convert time series to feature vector
    XTrain_tmp = diagnosticFeatures(trainData{1, 1});
    XTrain_tmp.(labelName) = convertCharsToStrings(labels.(fields{i}));
    XTrain = [XTrain; XTrain_tmp];
end

XTrain = convertvars(XTrain, labelName, 'categorical');
end
