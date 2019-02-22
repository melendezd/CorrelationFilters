function [ trainInp, testInp ] = genInput( trainPool, testPool, varargin )
%GENINPUT Generates inputs for filters
%   trainPool and testPool are n x 5 cells images of n subjects in 
%   5 illumination conditions

    options = struct('pTest', [], 'subjIDs', [], 'trainICs', [], 'testICs', []);
    optionNames = fieldnames(options);
    nArgs = length(varargin);
    if mod(nArgs,2) ~= 0
        error('testFilt needs name/value pairs')
    end

    for pair = reshape(varargin, 2, [])
        %inpName = lower(pair{1});
        inpName = pair{1};
        if any(strcmpi(inpName, optionNames))
            options.(inpName) = pair{2};
        else
            error('[testFilt] %s is not a recognized parameter name',inpName);
        end
    end

    nSubjects = numel(options.subjIDs);

    %% create testing and training sets
    %fprintf('Organizing testing and training sets...\n');
    %tic
    % Number of testing images per illumination class
    %nTest = [4 4 0 0 0];
    %pTest = [0.25, 0.25, 0, 0, 0, 0];

    % Training set for SDF/POSDF
    train = cell(nSubjects,5);
    test = cell(nSubjects,5);
    %maceTrain = cell(nSubjects,5);

    % Set up testing and training set for each illumination class
    for i=1:nSubjects
        s=options.subjIDs(i);
        % Loop through the 5 illumination classes
        for j=1:5
            % nImgs = the number of illumination class j images of subject s
            nImgs = size(trainPool{s}{j},1);

            % ind = the test set indices for illumination class j
            ind = randperm(nImgs,ceil(options.pTest(j)*nImgs));

            % test{i,j} = uncropped test set images of indices ind{j} of subject s
            test{i,j} = testPool{s}{j}(ind,:,:);

            % training images for illumination class j of subject s
            train{i,j} = trainPool{s}{j}(setdiff(1:nImgs,ind),:,:);
            %maceTrain{i,j} = subjsmall{s}{j}(setdiff(1:nImgs,ind),:,:);
        end
    end
    %toc
    %fprintf('\n');

    %% Organize filter test inputs

    % First, train with clear images and test on clear images
    %fprintf('Subjects: ');
    %fprintf('%d ', subjID);
    %fprintf('\n');

    %trainIC = 1:2;
    %testIC = 1:2;

    % Create input for testSDF: {Training images, Testing images}
    %sdfInp1 = cell(nSubjects, 1);
    trainInp = cell(nSubjects,1);
    testInp = cell(nSubjects,1);
    for i=1:nSubjects
        %sdfInp{i} = vertcat(sdfTrain{i,trainIC});
        %sdfInp{i+nSubjects} = vertcat(test{i,testIC});
        trainInp{i} = vertcat(train{i,options.trainICs});
        testInp{i} = vertcat(test{i,options.testICs});
    end
end

