function [ faces ] = getSubjectCropped2( n, rc )
%GETSUBJECTCROPPED2 Returns a 5-element cell array containing the five illumination clasees of the cropped images of subject n
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

    %{
    if exist('rc', 'var')
         User specified image size
        for i=1:5
            faces{i}=zeros([N rc(1) rc(2)]);
        end
    else
        % User did not specify image size
        for i=1:5
            faces{i}=zeros([N r c]);
        end
    end
    %}

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
        if angle2 >= 75
            s = 5;
        elseif angle1 <= 12
            s = 1;
        elseif angle1 <= 25
            s = 2;
        elseif angle1 <= 50
            s = 3;
        elseif angle1 <= 70
            s = 4;
        elseif angle1 <= 130
            s = 5;
        else
            fprintf('whyyyyyyyyyyyyyyyy');
        end

        faces{s} = [faces{s}; permute(face, [3 1 2])];
    end

end

