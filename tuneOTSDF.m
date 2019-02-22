%% Load subjects
fprintf('Loading subjects...\n')
tic

% subjID = list of subjects we are using for training and testing
subjIDs = 30:35;
nSubjects = numel(subjIDs);
%subjIDs = subjIDs([2 3 4 5 6]);

subj(subjIDs,:,:) = arrayfun(@getSubjectCropped2, ... 
    subjIDs, 'UniformOutput', false);
subjFull(subjIDs,:,:) = arrayfun(@getSubjectUncropped2, ... 
    subjIDs, 'UniformOutput', false);
toc
fprintf('\n');

%% Create training/testing inputs
fprintf('\nGenerating inputs...\n')
tic
p=0.2;
[trainInp, testInp] = genInput(subj, subjFull, ...
    'subjIDs'  , subjIDs,    ...
    'trainICs' , 1:2,        ...
    'testICs'  , 1:2,        ...
    'pTest'    , [p,p,0,0,0] ...
);

toc

%% === Test OTSDF ===
fprintf('\nTesting OTSDF: Train 1-2, Test 1-2\n');


% Confusion matrix and accuracy for OTSDF filter
for i=0:10
    tic
    l = i*0.1;
    fprintf('l = %d\n', l);
    cOTSDF{i+1} = testFilt(@otsdf, 'train', trainInp, 'test', testInp, ...
        'response', 'ones', 'size', [64 64], 'args', {l});
    accuracyOTSDF{i+1} = cAccuracy(cOTSDF{i+1})
    toc
end

%% === Test without subject 35 ===
%{
fprintf('\nTesting OTSDF: Removed 6th subject');
subjIDs = subjIDs(1:5)
p=0.3;
[trainInp, testInp] = genInput(subj, subjFull, ...
    'subjIDs'  , subjIDs,    ...
    'trainICs' , 1:2,        ...
    'testICs'  , 1:2,        ...
    'pTest'    , [p,p,0,0,0] ...
);


% Confusion matrix and accuracy for OTSDF filter
for i=0:10
    tic
    l = i*0.1;
    fprintf('l = %d\n', l);
    cOTSDF_2{i+1} = testFilt(@otsdf, 'train', trainInp, 'test', testInp, ...
        'response', 'ones', 'size', [64 64], 'args', {l});
    accuracyOTSDF_2{i+1} = cAccuracy(cOTSDF_2{i+1})
    toc
end
%}
