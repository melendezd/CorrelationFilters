
%% Load subjects
N = 4;
sprintf('Loading in subjects...')
tic
subj = arrayfun(@(x) getSubjectCropped(x), [1:N], 'UniformOutput', false);
subjsmall = arrayfun(@(x) getSubjectCropped(x, [64 64]), [1:N], 'UniformOutput', false);
toc

%% Synthesize filters
sprintf('Synthesizing filters...')
tic
hSDF = cell(N);
hMatched = cell(N);
hMACE = cell(N);
for k=1:N 
    [M r c] = size(subj{k});
    u = ones(M, 1);
    hSDF{k} = sdf(subj{k}, u);
    hMatched{k} = squeeze(subj{k}(1,:,:));
    hMACE{k} = mace(subjsmall{k}, u);
end
toc

%% SDF Filter Confusion Matrix
% Create SDF confusion matrix 
% (row <=> predicted, column <=> actual, each entry is the number of hits
sprintf('Creating SDF Filter confusion matrix...')
cSDF = zeros(N);

tic
% Filter for subject i
for i=1:N 
    % Test filter against subject j
    for j=1:N 
        [M rs cs] = size(subj{j});
        % Run filter against image k of subject j
        for k=1:M 
            cout = fxcorr2(squeeze(subj{j}(k,:,:)), hSDF{i});
            % Get index of correlation peak
            [m mi] = max(cout(:)); 
            [r c] = ind2sub(size(cout), mi);
            cSDF(i,j) = cSDF(i,j) + (r == 1 && c == 1);
        end
    end
end
toc

%% Matched Filter Confusion Matrix
% Create Matched Filter confusion matrix 
% (row <=> predicted, column <=> actual, each entry is the number of hits
sprintf('Creating Matched Filter confusion matrix...')
cMatched = zeros(N);

tic
% Filter for subject i
for i=1:N 
    % Test filter against subject j
    for j=1:N 
        [M rs cs] = size(subj{j});
        % Run filter against image k of subject j
        for k=1:M 
            cout = fxcorr2(squeeze(subj{j}(k,:,:)), hMatched{i});
            % Get index of correlation peak
            [m mi] = max(cout(:)); 
            [r c] = ind2sub(size(cout), mi);
            cMatched(i,j) = cMatched(i,j) + (r == 1 && c == 1);
        end
    end
end
toc

%% MACE Filter Confusion Matrix
% Create MACE confusion matrix 
% (row <=> predicted, column <=> actual, each entry is the number of hits
sprintf('Creating MACE Filter confusion matrix...')
cMACE = zeros(N);

tic
% Filter for subject i
for i=1:N 
    % Test filter against subject j
    for j=1:N 
        [M rs cs] = size(subjsmall{j});
        % Run filter against image k of subject j
        for k=1:M 
            cout = fxcorr2(squeeze(subjsmall{j}(k,:,:)), hMACE{i});
            % Get index of correlation peak
            [m mi] = max(cout(:)); 
            [r c] = ind2sub(size(cout), mi);
            cMACE(i,j) = cMACE(i,j) + (r == 1 && c == 1);
        end
    end
end
toc
