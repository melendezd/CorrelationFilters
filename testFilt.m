function [ C ] = testFilt(filt, varargin)
%testFilt Test a filter
%   Outputs a confusion matrix
    options = struct('train', [], 'test', [], 'response', '', 'size', [], ...
    'args', []);
    optionNames = fieldnames(options);
    nArgs = length(varargin);
    if mod(nArgs,2) ~= 0
        error('testFilt needs name/value pairs')
    end

    for pair = reshape(varargin, 2, [])
        inpName = lower(pair{1});
        if any(strcmp(inpName, optionNames))
            options.(inpName) = pair{2};
        else
            error('[testFilt] %s is not a recognized parameter name',inpName);
        end
    end

    % Obtain training and testing images for each subject
    % Each element of the cell array is a M*r*c matrix containing
    % M images of the subject of size r*c
    subjTrain = options.train;
    subjTest = options.test;
    nTrain = numel(subjTrain);
    nTest = numel(subjTest);

    %sizeTrain = size(squeeze(subjTrain{1}(1,:,:)));
    
    % Create cell array containing SDF filters for each subject,
    % synthesized using the training set

    filts = cell(nTrain,1);
    for i=1:nTrain
        nImgs = size(subjTrain{i},1);
        train = [];
        u = [];

        if strcmp(options.response, 'ones')
            train = subjTrain{i};
            u = ones(nImgs,1);
        elseif strcmp(options.response, 'false')
            for j=1:nTrain
                numTrainingImgs = size(subjTrain{j},1);
                u = [u ; (i==j) * ones(numTrainingImgs,1)];
                train = [train; subjTrain{i}];
            end
        end

        % Resize training images if user provides size
        if ~isempty(options.size)
            for j=1:size(train,1)
                newTrain(j,:,:) = imresize(squeeze(train(j,:,:)), ...
                    options.size);
            end
            train = newTrain;
        end

        filts{i} = filt(train, u, options.args{:});
    end

    % Use filters to classify each image in the testing set
    % Store resulting confusion matrix in C
    C = zeros(nTrain, nTest);
    % M is a vector containing the max values for the output of each filter
    M = zeros(nTrain,1);
    % For each subject in the testing set... 
    for s=1:nTest
        [nImgs r c]= size(subjTest{s});

        % For each testing image of subject s...
        for i=1:nImgs
            % Run each filter over image i of subject s, 
            % and store the peak values in M
            M = zeros(nTrain,1);
            for j=1:nTrain
                imgTest = squeeze(subjTest{s}(i,:,:));
                rTrain = size(subjTest{s}, 2);
                cTrain = size(subjTest{s}, 3);
                if ~isempty(options.size)
                    imgTest = imresize(imgTest, ...
                        [ round(options.size(1)/rTrain*r), ...
                          round(options.size(2)/cTrain*c) ...
                        ] );
                end
                cor=fxcorr2(imgTest,filts{j});
                M(j)=max(cor(:));
            end

            % Classify image
            [maxVal, predictedClass] = max(M);

            % Update confusion matrix (s is the actual class)
            C(predictedClass, s) = C(predictedClass, s) + 1;
        end
    end
end 
