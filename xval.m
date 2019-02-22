%% Load Subjects
sprintf('Loading subjects...')
tic
subjects = 20:25;
subjects = subjects([1,2,4,5])

N = size(subjects,2);
%load('croppedSubjects.mat');


subj(subjects,:,:) = arrayfun(@(x) getSubjectCropped(x), ... 
    subjects, 'UniformOutput', false);
subjsmall(subjects,:,:) = arrayfun(@(x) getSubjectCropped(x,[64 64]), ... 
    subjects, 'UniformOutput', false);
subjFull(subjects,:,:) = arrayfun(@(x) getSubjectUncropped(x), ... 
    subjects, 'UniformOutput', false);
toc

%% Generate 10-fold cross-val indices
sprintf('Generating 10-fold cross-val indices...')
tic
% Cell con
cvIndices = cellfun(@(s)(crossvalind('Kfold', size(s,1), 10)), ... 
    subj(subjects), 'UniformOutput', false);
toc

%% Phase Only SDF Filter 10-fold cross-validation
sprintf('Doing POSDF 10-fold cross validation...')
tic

cPOSDF = zeros(N); 

train = cell(N, 1);
test = cell(N, 1);
for i=1:10
    for j=1:N
        test{j} = subjFull{subjects(j)}((cvIndices{j} == i), :, :);
        train{j} = subj{subjects(j)}((cvIndices{j} ~= i), :, :);
    end
    %cSDF = cSDF + testSDF(192, 168, [train(subjects); test(subjects)]);
    cPOSDF = cPOSDF + testPOSDF([train(1:N); test(1:N)]);
end

cPOSDF
accuracyPOSDF = sum(diag(cPOSDF))/sum(cPOSDF(:))

toc


%% SDF Filter 10-fold cross-validation
sprintf('Doing SDF 10-fold cross validation...')
tic

cSDF = zeros(N); 

train = cell(N, 1);
test = cell(N, 1);
for i=1:10
    for j=1:N
        test{j} = subjFull{subjects(j)}((cvIndices{j} == i), :, :);
        train{j} = subj{subjects(j)}((cvIndices{j} ~= i), :, :);
    end
    %cSDF = cSDF + testSDF(192, 168, [train(subjects); test(subjects)]);
    cSDF = cSDF + testSDF([train(1:N); test(1:N)]);
end

cSDF
accuracySDF = sum(diag(cSDF))/sum(cSDF(:))

toc

%% MACE Filter 10-fold cross-validation

sprintf('Doing MACE 10-fold cross validation...')
tic

cMACE = zeros(N); 

train = cell(N, 1);
test = cell(N, 1);
for i=1:10
    for j=1:N
        test{j} = subjFull{subjects(j)}((cvIndices{j} == i), :, :);
        train{j} = subjsmall{subjects(j)}((cvIndices{j} ~= i), :, :);
    end
    cMACE = cMACE + testMACE(64, 64, [train(1:N); test(1:N)]);
end

cMACE
accuracyMACE = sum(diag(cMACE))/sum(cMACE(:))

toc


%cSDF = reshape(sum(cSDF, 1), round(sqrt(numel(cSDF(1,:)))), [])
