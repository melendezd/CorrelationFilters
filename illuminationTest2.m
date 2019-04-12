%% Load subjects
fprintf('Loading subjects...\n')
tic

% subjID = list of subjects we are using for training and testing
%subjIDs = 19:28;
subjIDs = 20:25
nSubjects = numel(subjIDs);
%subjIDs = subjIDs([2 3 4 5 6]);

subj(subjIDs,:,:) = arrayfun(@getSubjectCropped4, ... 
    subjIDs, 'UniformOutput', false);
subjFull(subjIDs,:,:) = arrayfun(@getSubjectUncropped4, ... 
    subjIDs, 'UniformOutput', false);
toc
fprintf('\n');

%% Create training/testing inputs

fprintf('\nGenerating inputs...\n')
tic
train = cell(5,38);
test= cell(5,38);
trainInp = cell(5);
testInp = cell(5);

% Train and test on ICs 1-2, plus IC>2 images with hAngle btwn 50 and 85
% Create array of indices for our pool
t = 1;
desc{t} = 'Train & test w/ ICs 1-2 plus IC>2 images with hAngle btwn 50 and 85';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] <= 2 | ...
        ([s.ic] > 2 & [s.hAngle] >= 50 & [s.hAngle] <= 85));

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,13,14,16];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}(trainInds{t,sid}).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train and test on ICs 1-2, plus IC>2 images with hAngle btwn -50 and -85
% Create array of indices for our pool
t = 2;
desc{t} = 'Train & test w/ ICs 1-2, plus IC>2 images with hAngle btwn -50 and -85';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] <= 2 | ...
        ([s.ic] > 2 & [s.hAngle] <= -50 & [s.hAngle] >= -85));


    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,21,24,27];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}(trainInds{t,sid}).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% ==================================================================== %
% ==================================================================== %

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% Train and test on ICs 1-2, plus IC>2 images with |hAngle| btwn 50 and 85
% Create array of indices for our pool
t = 3;
desc{t} = 'Train & test w/ ICs 1-2, plus IC>2 images with |hAngle| btwn 50 and 85';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] <= 2 | ...
        ([s.ic] > 2 & abs([s.hAngle]) >= 50 & abs([s.hAngle]) <= 85));

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,14,15,35,37];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}(trainInds{t,sid}).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% Train and test on ICs 1-2
% Create array of indices for our pool
t = 4;
desc{t} = 'Train & test ICs 1-2';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] <= 2);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,3,10];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}(trainInds{t,sid}).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train ICs 1,2,3 test IC 3
% Create array of indices for our pool
t = 5;
desc{t} = 'Train ICs 1-3, test IC 3';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 3);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,6,10];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}([trainInds{t,sid}, ...
        trainInds{4,sid}([1,2])]).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train ICs 1,2,4, test IC 4
% Create array of indices for our pool
t = 6;
desc{t} = 'Train ICs 1,2,4, test IC 4';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 4);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,5,10,12];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}([trainInds{t,sid}, ...
        trainInds{4,sid}([1,2])]).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train and test on IC 5
% Create array of indices for our pool
t = 7;
desc{t} = 'Train ICs 1,2,5, test IC 5';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 5);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,3,8,11,13];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set
    trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}([trainInds{t,sid}, ...
        trainInds{4,sid}([1,2])]).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% Train and test on ICs 1-2
% Create array of indices for our pool
t = 8;
desc{t} = 'Train & test ICs 1-2';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] <= 2);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    trainInds{t,sid} = [1];
    trainInds{t,sid} = ismember(1:numel(poolInds{t}), trainInds{t,sid});
    testInds{t,sid} = [2,3,4,5,8,10,11,16,17,18];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});
    trainInds{t,sid} = poolInds{t}(trainInds{t,sid});

    train{t,sid} = vertcat(subj{sid}(trainInds{t,sid}).face);
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train with 1 image, test IC 3
% Create array of indices for our pool
t = 9;
desc{t} = 'Train with 1 image, test IC 3';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 3);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    %testInds{t,sid} = [1,2,6,10];
    %testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});
    testInds{t, sid} = poolInds{t};

    % Training set is everything not in the testing set
    %trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    %testInds{t,sid} = poolInds{t}(testInds{t,sid});

    train{t,sid} = subj{sid}(1).face;
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train 1 image, test IC 4
% Create array of indices for our pool
t = 10;
desc{t} = 'Train 1 image, test IC 4';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 4);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,3,4,5,6,7,8,9,10,];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});
    %testInds{t, sid} = poolInds{t};

    % Training set is everything not in the testing set
    %trainInds{t,sid} = ~testInds{t,sid};

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});

    train{t,sid} = subj{sid}(1).face;
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

% ==================================================================== %
% ==================================================================== %

% Train 1 image, test IC 5
% Create array of indices for our pool
t = 11;
desc{t} = 'Train 1 image, test IC 5';
for sid=subjIDs
    %sid = subjIDs(i);
    s = subj{sid};

    poolInds{t} = find([s.ic] == 5);

    % Pick some clear and unclear images from our pool indices and
    % convert the indices into a logical array
    testInds{t,sid} = [1,2,3,6,7,8,16,17,18,10];
    testInds{t,sid} = ismember(1:numel(poolInds{t}), testInds{t,sid});

    % Training set is everything not in the testing set

    % Convert from pool indices to indices of subj
    testInds{t,sid} = poolInds{t}(testInds{t,sid});

    train{t,sid} = subj{sid}(1).face;
    test{t,sid} = vertcat(subjFull{sid}(testInds{t,sid}).face);
    testCropped{t,sid} = vertcat(subj{sid}(testInds{t,sid}).face);
end

% Each training/testing input is an nSubjects x 1 cell array
% containing training/testing images for each subject
trainInp{t} = train(t,subjIDs)';
testInp{t} = test(t,subjIDs)';
testInpCropped{t} = testCropped(t,subjIDs)';

toc

nTests = t;

%% === POSDF C PSR SQI===
fprintf('\nPOSDF CROPPED PSR SQI\n')
%fprintf('Using PSR classifier\n')
for t=8:nTests
    tic
    fprintf('%s\n', desc{t})
    %rPOSDF_psr(t) = testFilt(@posdf, 'train', trainInp{t}, ...
    %    'test', testInp{t}, 'response', 'ones', 'type', 'psr', 'sqi', true);
    rPOSDF_psr_cropped_sqi(t) = testFilt(@posdf, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'psr', 'sqi', true);
    toc
end

[rPOSDF_psr_cropped_sqi.accuracy]
%% === Test POSDF ===
fprintf('\nTESTING POSDF FILTER\n')
fprintf('Using PSR classifier\n')
for t=1:nTests
    tic
    fprintf('%s\n', desc{t})
    rPOSDF_psr(t) = testFilt(@posdf, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'ones', 'type', 'psr');
    rPOSDF_psr_cropped(t) = testFilt(@posdf, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'psr');
    toc
end

[rPOSDF_psr.accuracy]
[rPOSDF_psr_cropped.accuracy]

fprintf('Using Peak Height classifier\n');
for t=1:nTests
    tic
    fprintf('%s\n', desc{t})
    rPOSDF_ph(t) = testFilt(@posdf, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'ones', 'type', 'PeakHeight');
    rPOSDF_ph_cropped(t) = testFilt(@posdf, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'PeakHeight');
    toc
end

[rPOSDF_ph.accuracy]
[rPOSDF_ph_cropped.accuracy]

%% === Test SDF ===
fprintf('\nTESTING SDF FILTER\n')
fprintf('Using PSR classifier\n')
for t=1:nTests
    tic
    fprintf('%s\n', desc{t})
    rSDF_psr(t) = testFilt(@sdf, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'ones', 'type', 'psr');
    rSDF_psr_cropped(t) = testFilt(@sdf, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'psr');
    toc
end

[rSDF_psr.accuracy]
[rSDF_psr_cropped.accuracy]

fprintf('Using Peak Height classifier\n');
for t=1:nTests
    tic
    fprintf('%s\n', desc{t})
    rSDF_ph(t) = testFilt(@sdf, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'ones', 'type', 'PeakHeight');
    rSDF_ph_cropped(t) = testFilt(@sdf, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'PeakHeight');
    toc
end

[rSDF_ph.accuracy]
[rSDF_ph_cropped.accuracy]

%% === Test MACE PSR ===
fprintf('\nTESTING MACE FILTER\n')
fprintf('Using PSR classifier\n')
for t=4:nTests
    tic
    fprintf('%s\n', desc{t})
    rMACE_psr(t) = testFilt(@mace, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'false', 'type', 'psr', 'size', ... 
        [64 64]);
    rMACE_psr_cropped(t) = testFilt(@mace, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'false', 'type', 'psr', 'size', ...
        [64 64]);   
    toc
end

[rMACE_psr.accuracy]
[rMACE_psr_cropped.accuracy]

%% === MACE PH ===

fprintf('Using Peak Height classifier\n');
for t=1:nTests
    tic
    fprintf('%s\n', desc{t})
    rMACE_ph(t) = testFilt(@mace, 'train', trainInp{t}, ...
        'test', testInp{t}, 'response', 'ones', 'type', 'PeakHeight', ...
        'size', [64 64]);
    rMACE_ph_cropped(t) = testFilt(@mace, 'train', trainInp{t}, ...
        'test', testInpCropped{t}, 'response', 'ones', 'type', 'PeakHeight', ...
        'size', [64 64]);
    toc
end

[rMACE_ph.accuracy]
[rMACE_ph_cropped.accuracy]

%% == Find lambda for OTSDF ==

%{
fprintf('\nTESTING OTSDF FILTER\n')
fprintf('Using PSR classifier\n')
for i=0:10
    tic
    l = i*0.1;
    fprintf('l = %d\n', l);
    rOTSDF_psr(i+1) = testFilt(@otsdf, 'train', trainInp{4}, 'test', ...,
    testInp{4}, 'response', 'ones', 'size', [64 64], 'args', {l}, 'type', 'psr');
    toc
end

[rOTSDF_psr.accuracy]

fprintf('Using Peak Height classifier\n');
for i=0:10
    ticjjjjjjjjj
    l = i*0.1;
    fprintf('l = %d\n', l);
    rOTSDF_ph(i+1) = testFilt(@otsdf, 'train', trainInp{4}, 'test', ..., 
    testInp{4}, 'response', 'ones', 'size', [64 64], 'args', {l}, 'type', ...,
    'PeakHeight');
    toc
end

[rOTSDF_ph.accuracy]
%}

%% === Visualize Matched Filter ===
hM = squeeze(trainInp{4}{1}(1,:,:));
hM2 = squeeze(trainInp{4}{2}(1,:,:));
sM = squeeze(testInp{4}{1}(1,:,:));
cM = fxcorr2(sM, hM);

[rows cols] = size(cM);

k = 10;
X = 1:k:rows;
Y = 1:k:cols;

%imshow(mat2gray(hM2));
surf(cM(X,Y));
%set(gca,'YTickLabel', [], 'XTickLabel', [], 'ZTickLabel', [], ...
%    'XGrid', 'Off', 'YGrid', 'Off', 'ZGrid', 'Off');

%% === Visualize POSDF Filter ===
nImgs1 = size(trainInp{4}{3},1);
nImgs2 = size(trainInp{5}{2},1);
train1 = trainInp{4}{3};
train2 = trainInp{5}{2};
test1 = squeeze(testInp{4}{3}(1,:,:));
test2 = squeeze(testInp{4}{4}(1,:,:));
sus1 = squeeze(trainInp{4}{3}(1,:,:));
sus2 = squeeze(trainInp{4}{2}(1,:,:));
scene = squeeze(testInp{4}{3}(1,:,:));

filt1 = posdf(train1, ones(nImgs1, 1));
filt2 = posdf(train2, ones(nImgs2, 1));

corr1 = fxcorr2(test1, filt1);
corr2 = fxcorr2(test1, filt2);
c = corr2;
psr1 = psr(corr1, 2, 9);
psr2 = psr(corr2, 2, 9);
ph1 = max(corr1(:));
ph2 = max(corr2(:));

[rows cols] = size(c);
k = 7;
X = 1:k:rows;
Y = 1:k:cols;
%gaf = surf(c(X,Y));
imshow(mat2gray(sus2))
%set(gca,'YTickLabel', [], 'XTickLabel', [], 'ZTickLabel', [], ...
%    'XGrid', 'Off', 'YGrid', 'Off', 'ZGrid', 'Off');

%% === Visualize MACE True vs. False Class Response ===
tic
rMACE = testFilt(@mace, 'train', trainInp{4}, ...
    'test', testInpCropped{4}, 'response', 'ones', 'type', 'psr', 'size', ... 
    [64 64]);
rSDF = testFilt(@sdf, 'train', trainInp{4}, ...
    'test', testInpCropped{4}, 'response', 'ones', 'type', 'psr');
rPOSDF = testFilt(@posdf, 'train', trainInp{4}, ...
    'test', testInpCropped{4}, 'response', 'ones', 'type', 'psr');

toc

%% vis mace
%r = rMACE_psr_cropped(4);
r = rPOSDF;
ct = r.corrOut{2,1,2};
cf = r.corrOut{1,1,2};
c = cf;
[rows cols] = size(c);
k = 3;
X = 1:k:rows;
Y = 1:k:cols;
gaf = surf(c(X,Y));
set(gca,'YTickLabel', [], 'XTickLabel', [], 'ZTickLabel', [], ...
    'XGrid', 'Off', 'YGrid', 'Off', 'ZGrid', 'Off');
