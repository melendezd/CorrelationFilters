%% Load subjects
sprintf('Loading subjects...')
tic
subjects = 20:25;
subjects = subjects([2,4,5,6])
nSubjects = numel(subjects);
subjIndices;

subj(subjects,:,:) = arrayfun(@(x) getSubjectCropped(x), ... 
    subjects, 'UniformOutput', false);
subjsmall(subjects,:,:) = arrayfun(@(x) getSubjectCropped(x,[64 64]), ... 
    subjects, 'UniformOutput', false);
subjFull(subjects,:,:) = arrayfun(@(x) getSubjectUncropped(x), ... 
    subjects, 'UniformOutput', false);
toc

%load('croppedSubjects.mat');

%% Create testing and training sets
sdfTrain = cell(nSubjects,1);
maceTrain = cell(nSubjects,1);
filtTest = cell(nSubjects,1);
%sdfTest = cell(nSubjects,1);
%maceTest = cell(nSubjects,1);

for i=1:nSubjects
    % Pick 5 random indices
    s=subjects(i);
    nImgs = numel(subjTrain);
    ind = randperm(nImgs,5);

    % Test set sampled from 5 random indices of the high clarity images
    filtTest{i} = subjFull{s}(subjTrain(ind),:,:);
    %maceTest{i} = subjsmall{i}(subjInd.High{s}(ind),:,:);

    % Training set is the rest
    sdfTrain{i} = subj{s}(subjInd.High{s}(setdiff(1:end,ind)),:,:);
    maceTrain{i} = subjsmall{s}(subjInd.High{s}(setdiff(1:end,ind)),:,:);
end

%% Test filters
tic
cSDF = testSDF([sdfTrain; filtTest])
accuracySDF = sum(diag(cSDF))/sum(cSDF(:))
toc

tic
cPOSDF = testPOSDF([sdfTrain; filtTest])
accuracyPOSDF = sum(diag(cPOSDF))/sum(cPOSDF(:))
toc

tic
cMACE = testMACE(64, 64, [maceTrain; filtTest])
accuracyMACE = sum(diag(cMACE))/sum(cMACE(:))
toc
j