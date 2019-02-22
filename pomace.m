function [ h ] = pomace( t, u, SIZE )
%MACE Minimum Average Correlation Energy filter
%   t : Training set, [N r c] array containing N images of size [r c].
%   u : Response vector, u(i) is the filter's specified response to image i in t
    [nfaces r c] = size(t);

    % Number of pixels in image
    N = r * c;

    % X : Columns are the DFTs of the face column vectors
    % D : Diagonal entries of D(i,:,:) are the squares of the entries of X(:,i).
    x = zeros(N, nfaces);
    X = zeros(N, nfaces);
    D = zeros(N, N);
    u = ones(nfaces, 1);

    for i=1:nfaces
        tf = fft2(imresize(squeeze(t(i,:,:)), [r c]));
        tf = ifft2(tf ./ abs(tf));
        x(:,i) = tf(:);
        X(:,i) = fft(x(:, i));
        D = D + diag(abs(X(:,i)).^2);
    end

    H = inv(D) * X * inv(X' * inv(D) * X) * u;

    h = real(ifft(H));
    h = reshape(h, [r c]);
end
