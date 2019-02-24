function [ organizedFaces ] = getSubjectCropped3( n, rc )
%GETSUBJECTCROPPED2 Returns a 5-element cell array containing the five illumination clasees of the cropped images of subject n
%   Categorizes by mean pixel value comparison to brightest image
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

    % Load faces and calculate illumination indices
    for i=1:N
        fileName = files(i).name; % yaleBXX_PXXX+0XXE+XX.pgm
        face = imread(strcat(fPath,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end

        illum(i) = mean(face(:));
        
        faces(i,:,:) = permute(face, [3 1 2]);
    end

    % Organize faces by lighting
    minIllum = min(illum(:));
    maxIllum = max(illum(:));
    normalizedIllum = illum./maxIllum;

    organizedFaces = cell(5,1);
    for i=1:N
        threshold = 1/5;
        currentIllum = normalizedIllum(i);
        if currentIllum==1
            s = 1;
        else
            s = 5 - floor(currentIllum/threshold);
        end
        organizedFaces{s} = [organizedFaces{s} ; faces(i,:,:)];
    end
    organizedFaces
end

