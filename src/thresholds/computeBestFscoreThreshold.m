function thr = computeBestFscoreThreshold(anomalyScores, labels, type)
%COMPUTEBESTFSCORETHRESHOLD Comput the best F-Score threshold
%   Computes either the point-wise, event-wise, point-adjusted
%   or composite best F-Score threshold

thresholdCandidates = uniquetol(anomalyScores, 0.0001);
numThresholdCandidates = numel(thresholdCandidates);

for cand_idx = 1:numThresholdCandidates
    predictedLabels(:, cand_idx) = any(anomalyScores > thresholdCandidates(cand_idx), 2);
end

F1Scores = zeros(numThresholdCandidates, 1);

% Calculate F1-Scores for all candidate thresholds
switch type
    case "point-wise"
        for cand_idx = 1:numThresholdCandidates
            [~, ~, f1, ~] = computePointwiseMetrics(predictedLabels(:, cand_idx), labels);
            F1Scores(cand_idx) = f1;
        end
    case "event-wise"   
        for cand_idx = 1:numThresholdCandidates
            [~, ~, f1, ~] = computeEventwiseMetrics(predictedLabels(:, cand_idx), labels);
            F1Scores(cand_idx) = f1;
        end
    case "point-adjusted"
        for cand_idx = 1:numThresholdCandidates
            [~, ~, f1, ~] = computePointAdjustedMetrics(predictedLabels(:, cand_idx), labels);
            F1Scores(cand_idx) = f1;
        end
    case "composite"
        for cand_idx = 1:numThresholdCandidates
            [f1, ~] = computeCompositeMetrics(predictedLabels(:, cand_idx), labels);
            F1Scores(cand_idx) = f1;
        end
end

if isempty(F1Scores) || ~any(F1Scores)
    thr = NaN;
    return;
end

maxFScore = max(F1Scores);
thr_idx = find(F1Scores == maxFScore, 1);

thr = thresholdCandidates(thr_idx);
end