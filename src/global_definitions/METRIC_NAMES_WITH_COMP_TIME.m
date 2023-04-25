function metricNames = METRIC_NAMES()
%METRIC_NAMES Returns all metric names used by the tsad platform

metricNames = ["Mean Computation Time per Window (seconds)"; ...
                "F1 Score (point-wise)"; ...
                "F1 Score (event-wise)"; ...
                "F1 Score (point-adjusted)"; ...
                "F1 Score (composite)"; ...
                "F0.5 Score (point-wise)"; ...
                "F0.5 Score (event-wise)"; ...
                "F0.5 Score (point-adjusted)"; ...
                "F0.5 Score (composite)"; ...
                "Precision (point-wise)"; ...
                "Precision (event-wise)"; ...
                "Precision (point-adjusted)"; ...
                "Recall (point-wise)"; ...
                "Recall (event-wise)"; ...
                "Recall (point-adjusted)"; ...
                "AUC"];
end