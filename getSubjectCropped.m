function [ faces ] = getSubjectCropped( n, rc )
%GETSUBJECTCROPPED Returns a size [N, r, c] array containing N cropped images of subject n from the Extended Yale Face Database B
%   n  : Subject ID
%   rc : Request images be resized to rc = [r c]
    fPath=sprintf('CroppedYale/yaleB%02d/',n);
    files = dir(strcat(fPath, '*.pgm'));

    N=size(files,1);
    
    r = 192;
    c = 168;

    if exist('rc', 'var')
        faces=zeros([N rc(1) rc(2)]);
    else
        faces=zeros([N r c]);
    end
    
    for i=1:N
        fileName = files(i).name;
        face = imread(strcat(fPath,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end
        faces(i,:,:) = face;
    end

end

