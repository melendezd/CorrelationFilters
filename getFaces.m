function [imgs] = getFaces(w, h)
    path='C:/Users/Mapa/Documents/MATLAB/CroppedYale/';
    N=38;

    imgs=zeros(N,w,h);

    % read face images, store in imgs cell
    for l=1:N
        % subject 14 is not included in the database I downloaded for some reason
        k = l;
        if l >= 14
            k = l + 1;
        end

        % read image
        filePath = sprintf('%syaleB%02d/yaleB%02d_P00A+000E+00.pgm',path,k,k);
        temp = imread(filePath,'pgm');
        temp = imresize(double(temp), [w h]);

        % fix value range from 0-1
        %low=min(temp(:));
        %high=max(temp(:));
        %temp = (temp - low)/(high-low);

        imgs(l,:,:) = temp;
    end
end

