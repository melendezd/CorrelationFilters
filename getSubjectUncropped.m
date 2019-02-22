function [ faces ] = getSubjectUncropped( n, rc )
%GETSUBJECTUNCROPPED Returns a size [N, r, c] array containing N cropped images of subject n from the Extended Yale Face Database B
%   n  : Subject ID
%   rc : Request images be resized to rc = [r c]

    fPathC=sprintf('CroppedYale/yaleB%02d/',n);
    fPathE=sprintf('ExtendedYaleB/yaleB%02d/',n);
    files = dir(strcat(fPathC, '*.pgm'));

    N=size(files);
    N=N(1);
    
    r = 480;
    c = 640;

    if exist('rc', 'var')
        faces=zeros([N rc(1) rc(2)]);
    else
        faces=zeros([N r c]);
    end


    for i=1:N
        face = imread(strcat(fPathE,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end
        %files(i).name
        %size(face)
        faces(i,:,:) = face;
    end
end


