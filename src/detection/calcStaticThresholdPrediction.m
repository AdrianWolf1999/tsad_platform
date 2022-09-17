function labels_pred = calcStaticThresholdPrediction(anomalyScores, staticThreshold, pd, useGaussianScores)
labels_pred_tmp = logical([]);
numChannels = size(anomalyScores, 2);


for j = 1:numChannels
    if useGaussianScores
        anomalyScores = pdf(pd, anomalyScores);
        labels_pred_tmp(:, j) = anomalyScores(:, j) < staticThreshold;
    else
        labels_pred_tmp(:, j) = anomalyScores(:, j) > staticThreshold;
    end
end
labels_pred = any(labels_pred_tmp, 2);

% This commented section was just for testing plots, DON'T UNCOMMENT!
% labels_pred(:) = 1;
% labels_pred(310) = 0;
% f = figure;
% f.Position = [100 100 1000 200];
% 
% plot(labels_pred);
% %xlabel('Timestamp', FontSize=14);
% ylim([-0.1 1.1]);
% xlim([0 3300]);
% %xlabel('Timestamp', FontSize=14);
% set(gca, ytick=[0 1]);
% set(gca, xtick=[]);

% anoms = combineAnomsAndStatic(anomalyScores, anoms);
end
