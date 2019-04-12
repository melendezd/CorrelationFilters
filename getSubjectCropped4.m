function [ output ] = getSubjectCropped4( n, rc )
%GETSUBJECTCROPPED2 Returns a 5-element cell array containing the five illumination clasees of the cropped images of subject n
%   Categorizes by sum of squares of horizontal and vertical lighting angles
%   n  : Subject ID
%   rc : Request images be resized to rc = [r c]

    fPath=sprintf('CroppedYale/yaleB%02d/',n);

    % File names of images of subject n
    files = dir(strcat(fPath, '*.pgm'));

    % N face images for subject n
    N=size(files,1);
    
    % r=rows, c=columns (in an image)
    r = 192;
    c = 168;

    % Faces are categorized into 5 groups 
    % depending on incident lighting angle
    %faces = cell(5, 1);

    output = [];

    for i=1:N
        fileName = files(i).name; % yaleBXX_PXXX+0XXE+XX.pgm
        hAngle = str2num(fileName(13:16));
        vAngle = str2num(fileName(18:20));
        face = imread(strcat(fPath,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end


        % Determine category of face 
        % (greater lighting angle -> worse lighting conditions
        % -> higher class number)
        angle = sqrt(hAngle^2 + vAngle^2);
        if vAngle == 90
            continue;
        end

        if angle < 20
            ic = 1;
        elseif angle <= 30
            ic = 2;
        elseif angle <= 50
            ic = 3;
        elseif angle <= 80
            ic = 4;
        elseif angle <= 130
            ic = 5;
        end

        %faces{ic} = [faces{ic}; permute(face, [3 1 2])];

        output = [output; struct( ...
            'face'  , permute(face,[3 1 2]), ...
            'hAngle', hAngle, ...
            'vAngle', vAngle, ...
            'ic'    , ic)];
    end
end

