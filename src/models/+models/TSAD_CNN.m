classdef TSAD_CNN < TSADModel
    %TSAD_CNN CNN for forecasting

    methods (Access = protected)
        function [XTrain, YTrain, XVal, YVal] = prepareDataTrain(obj, data, labels)
            %PREPAREDATATRAIN Prepares training data

            [XTrain, YTrain, XVal, YVal] = applySlidingWindowForTrain(data, ...
                                                                      obj.parameters.windowSize, ...
                                                                      obj.parameters.stepSize,  ...
                                                                      obj.parameters.valSize, ...
                                                                      "forecasting", ...
                                                                      "CBT");
        end
        
        function [XTest, timeSeriesTest, labelsTest] =  prepareDataTest(obj, data, labels)
            %PREPAREDATATEST Prepares testing data

            [XTest, timeSeriesTest, labelsTest] = applySlidingWindowForTest(data, ...
                                                                            labels, ...
                                                                            obj.parameters.windowSize, ...
                                                                            "forecasting", ...
                                                                            "CBT");
        end
        
        function Mdl = fit(obj, XTrain, YTrain, XVal, YVal, plots, verbose)
            %FIT Trains the model

            network = obj.getNetwork(XTrain, YTrain);
            trainOptions = obj.getTrainOptions(XVal, YVal, size(XTrain, 1), plots, verbose);
            Mdl = trainnet(XTrain, YTrain, network, "mean-squared-error", trainOptions);
        end
        
        function [anomalyScores, windowComputationTime] = predict(obj, Mdl, XTest, timeSeriesTest, labelsTest, getWindowComputationTime)
            %PREDICT Makes prediction on test data using the Mdl
            
            [prediction, windowComputationTime] = predictWithDNN(Mdl, XTest, getWindowComputationTime);
            anomalyScores = getForecastingErrors(prediction, timeSeriesTest, "CBT");
        end

        function network = getNetwork(obj, XTrain, YTrain)
            %GETNETWORK Returns the dlnetwork architecture

            numFeatures = size(XTrain, 1);
            numResponses = numFeatures;

            firstLayerFilter = obj.parameters.firstLayerFilter;
    
            layers = [inputLayer([numFeatures, obj.parameters.minibatchSize, obj.parameters.windowSize], "CBS")
                        
                        convolution1dLayer(5, firstLayerFilter, Stride=1, Padding="same")
                        reluLayer()
                        maxPooling1dLayer(3, Padding="same")
                        convolution1dLayer(5, firstLayerFilter * 2, Stride=1, Padding="same")
                        reluLayer()
                        maxPooling1dLayer(3, Padding="same")
                        convolution1dLayer(5, firstLayerFilter * 4, Stride=1, Padding="same")
                        reluLayer()
                        maxPooling1dLayer(3, Padding="same")
            
                        flattenLayer()
                        fullyConnectedLayer(32)
                        reluLayer()
                        fullyConnectedLayer(numResponses)];

            network = dlnetwork(layers);
        end
    end

    methods (Access = private)
        function trainOptions = getTrainOptions(obj, XVal, YVal, numWindows, plots, verbose)
            %GETTRAINOPTIONS Gets training options for neural network

            if gpuDeviceCount > 0
                device = "gpu";
            else
                device = "cpu";
            end
            
            % Set different training options according to use of validation
            % data during training
            if obj.parameters.valSize == 0
                trainOptions = trainingOptions("adam", ...
                                                Plots=plots, ...
                                                Verbose=verbose, ...
                                                MaxEpochs=obj.parameters.epochs, ...
                                                MiniBatchSize=obj.parameters.minibatchSize, ...
                                                GradientThreshold=1, ...
                                                InitialLearnRate=obj.parameters.learningRate, ...
                                                Shuffle="every-epoch",...
                                                ExecutionEnvironment=device);
            else
                trainOptions = trainingOptions("adam", ...
                                                OutputNetwork="best-validation-loss", ...
                                                Plots=plots, ...
                                                Verbose=verbose, ...
                                                MaxEpochs=obj.parameters.epochs, ...
                                                MiniBatchSize=obj.parameters.minibatchSize, ...
                                                GradientThreshold=1, ...
                                                InitialLearnRate=obj.parameters.learningRate, ...
                                                Shuffle="every-epoch", ...
                                                ExecutionEnvironment=device, ...
                                                ValidationData={XVal, YVal}, ...
                                                ValidationFrequency=floor(numWindows / (3 * obj.parameters.minibatchSize)));
            end
        end
    end
end






