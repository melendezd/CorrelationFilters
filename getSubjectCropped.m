function [ faces ] = getSubjectCropped( n, rc )
    fPath=sprintf('C:/Users/Mapa/Documents/MATLAB/CroppedYale/yaleB%02d/',n);
    files = dir(strcat(fPath, '*0.pgm'));

    N=size(files);
    N=N(1);
    
    r = 192;
    c = 168;

    if exist('rc', 'var')
        faces=zeros([N rc(1) rc(2)]);
    else
        faces=zeros([N r c]);
    end


    for i=1:N
        face = imread(strcat(fPath,files(i).name));
        if exist('rc', 'var')
            face = imresize(face, rc);
        end
        faces(i,:,:) = face;
    end

end

