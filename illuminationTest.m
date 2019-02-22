%% Load subjects
fprintf('Loading subjects...\n')
tic

% subjID = list of subjects we are using for training and testing
subjIDs = 30:36;
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
trainInp = cell(5,1);
testInp = cell(5,1);
for i=1:5
    p = 0.4;
    [trainInp{i}, testInp{i}] = genInput(subj, subjFull, ...
        'subjIDs'  , subjIDs,          ...
        'trainICs' , 1:2,              ...
        'testICs'  , [i],              ...
        'pTest'    , [p*ones(i,1); zeros(5-i,1)] ...
        );
end
toc

%% === Test SDF on separate illumination classes ===
fprintf('\nTESTING SDF FILTER\n')
fprintf('Training only for true-class images\n')
for i=1:5
    tic
    fprintf('Train on ICs 1-2, test on IC %d\n', i)
    cSDF_T{i} = testFilt(@sdf, 'train', trainInp{i}, 'test', testInp{i}, ...
        'response', 'ones');
    accuracySDF_T(i) = cAccuracy(cSDF_T{i});
    toc
end
accuracySDF_T

fprintf('\nTraining for true-class images, against false-class images\n')
for i=1:5
    tic
    fprintf('Train on ICs 1-2, test on IC %d\n', i)
    cSDF_TF{i} = testFilt(@sdf, 'train', trainInp{i}, 'test', testInp{i}, ...
        'response', 'false');
    accuracySDF_TF(i) = cAccuracy(cSDF_TF{i});
    toc
end
accuracySDF_TF



%% === Test POSDF on separate illumination classes ===
fprintf('\nTESTING POSDF FILTER\n')
fprintf('Training only for true-class images\n')
for i=1:5
    tic
    fprintf('Train on ICs 1-2, test on IC %d\n', i)
    cPOSDF{i} = testFilt(@posdf, 'train', trainInp{i}, 'test', testInp{i}, ...
        'response', 'ones');
    accuracyPOSDF(i) = cAccuracy(cPOSDF{i});
    toc
end
accuracyPOSDF

%% === Test MACE on separate illumination classes ===
fprintf('\nTESTING MACE FILTER\n')
fprintf('Training only for true-class images\n')
for i=1:5
    tic
    fprintf('Train on ICs 1-2, test on IC %d\n', i)
    cMACE{i} = testFilt(@mace, 'train', trainInp{i}, 'test', testInp{i}, ...
        'response', 'ones', 'size', [64 64]);
    accuracyMACE(i) = cAccuracy(cMACE{i});
    toc
end
accuracyMACE

%% === Test SDF ===
fprintf('\nTesting SDF: Train 1-2, Test 1\n');

tic

% Confusion matrix and accuracy for SDF filter
%cSDF11 = testSDF(sdfInp)
cSDF = testFilt(@sdf, 'train', trainInp, 'test', testInp, ...
    'response', 'ones')
accuracySDF = cAccuracy(cSDF)
toc

%% === Test SDF2 (Training against false-class images) ===
fprintf('\nTesting SDF2: Train 1-2, Test 1\n');

tic

% Confusion matrix and accuracy for SDF filter
cSDF2 = testFilt(@sdf, 'train', trainInp, 'test', testInp, ...
    'response', 'false')
accuracySDF2 = cAccuracy(cSDF2)
toc


%% === Test POSDF (Training with phase-only images) ===
fprintf('\nTesting POSDF: Train clear, test clear\n');
tic
% Confusion matrix and accuracy for POSDF filter
cPOSDF = testFilt(@posdf, 'train', trainInp, 'test', testInp, ...
    'response', 'ones')
accuracyPOSDF = cAccuracy(cPOSDF)
toc

%% === Test POSDF2 (Training for phase-only images, against false-class) ===
fprintf('\nTesting POSDF2: Train clear, test clear\n');
tic
% Confusion matrix and accuracy for POSDF filter
cPOSDF2 = testFilt(@posdf, 'train', trainInp, 'test', testInp, ...
    'response', 'false')
accuracyPOSDF2 = cAccuracy(cPOSDF2)
toc


%% === Test POSDFB (Normalization after multiplication in Fourier domain)  ===
%{
fprintf('\nTesting POSDFB: Train clear, test clear\n');
tic
% Confusion matrix and accuracy for POSDF filter
cPOSDFB11 = testPOSDFB(sdfInp)
accuracyPOSDFB11 = sum(diag(cPOSDFB11))/sum(cPOSDFB11(:))
toc
%}


%% === Test MACE ===
fprintf('\nTesting MACE: Train clear, test clear\n');

tic
% Confusion matrix and accuracy for MACE filter
cMACE = testFilt(@mace, 'train', trainInp, 'test', testInp, ...
    'response', 'ones', 'size', [64 64])
accuracyMACE = cAccuracy(cMACE)
toc

%% === Test MACE2 (Train against false-class images) ===

fprintf('\nTesting MACE2: Train clear, test clear\n');

tic
% Confusion matrix and accuracy for MACE filter
cMACE2 = testFilt(@mace, 'train', trainInp, 'test', testInp, ...
    'response', 'false', 'size', [64 64])
%cMACE2 = testMACE2(64, 64, maceInp)
accuracyMACE2 = cAccuracy(cMACE2)
toc


%% === Test POMACE ===
fprintf('\nTesting POMACE: Train clear, test clear\n');

tic
% Confusion matrix and accuracy for MACE filter
cPOMACE = testFilt(@pomace, 'train', trainInp, 'test', testInp, ...
    'response', 'false', 'size', [64 64])
accuracyPOMACE = cAccuracy(cMACE2)
toc

%% === Test POMACEB ===
%{
fprintf('\nTesting POMACEB: Train clear, test clear\n');

tic
% Confusion matrix and accuracy for MACE filter
cPOMACEB11 = testPOMACEB(64, 64, maceInp)
accuracyPOMACEB11 = sum(diag(cPOMACEB11))/sum(cPOMACE11(:))
toc
%}

%% === Test OTSDF ===
fprintf('\nTesting OTSDF: Train 1-2, Test 1\n');

tic

% Confusion matrix and accuracy for OTSDF filter
cOTSDF = testFilt(@otsdf, 'train', trainInp, 'test', testInp, ...
    'response', 'ones', 'size', [64 64])
accuracyOTSDF = cAccuracy(cOTSDF)
toc

%% === Visualize Something ===
N = size(sdfInp{1},1);
u = ones(N,1);

mySDF1 = sdf(sdfInp{3},u);
mySDF2 = sdf(sdfInp{1},u);
myPOSDF = posdf(sdfInp{2},u);
myMACE = sdf(maceInp{1},u);
csdf1 = fxcorr2(squeeze(sdfInp{7}(1,:,:)),mySDF1);
csdf2 = fxcorr2(squeeze(sdfInp{7}(1,:,:)),mySDF2);
c2 = fxcorr2(squeeze(maceInp{1}(1,:,:)),myMACE);

c = csdf1;
%s = sum(c(:))

[rows cols] = size(c);

k= 5;
X = 1:k:rows;
Y = 1:k:cols;

surf(c(X,Y));
