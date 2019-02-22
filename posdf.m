function [ h ] = posdf( t, u )
%POSDF Phase-Only Synthetic Discriminant Function filter
%   t : Training set, [N r c] array containing N images of size [r c].
%   u : Response vector, u(i) is the filter's specified response to image i in t
    [nfaces, r, c] = size(t);

    % Place faces in columns of x
    x = zeros(r*c, nfaces);
    for i=1:nfaces
        img = fft2(squeeze(t(i,:,:)));
        img = ifft2(img ./ abs(img));
        x(:,i) = img(:);
    end

    h = reshape(x * inv(x' * x) * u, [r c]);
end
