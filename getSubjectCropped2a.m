function [ faces ] = getSubjectCropped2( n, rc )
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
    faces = cell(5, 1);

    for i=1:N
        fileName = files(i).name; % yaleBXX_PXXX+0XXE+XX.pgm
        angle1 = abs(str2num(fileName(13:16)));
        angle2 = abs(str2num(fileName(18:20)));
        face = imread(strcat(fPath,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end


        % Determine category of face 
        % (greater lighting angle -> worse lighting conditions
        % -> higher class number)
        angle = sqrt(angle1^2 + angle2^2);
        if angle2 == 90
            continue;
        end

        if angle < 20
            s = 1;
        elseif angle <= 30
            s = 2;
        elseif angle <= 50
            s = 3;
        elseif angle <= 80
            s = 4;
        elseif angle <= 130
            s = 5;
        end

        faces{s} = [faces{s}; permute(face, [3 1 2])];
    end
    faces
end

