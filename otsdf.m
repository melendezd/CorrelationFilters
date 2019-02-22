function [ h ] = otsdf( t, u, l )
%OTSDF Optimal Tradeoff Synthetic Discriminant Function Filter
%   t : Training set, [N r c] array containing N images of size [r c].
%   u : Response vector, u(i) is the filter's specified response to image i in t
    [nfaces r c] = size(t);

    % Number of pixels in image
    N = r * c;

    % X : Columns are the DFTs of the face column vectors
    % D : Diagonal entries of D(i,:,:) are the squares of the entries of X(:,i).
    x = zeros(N, nfaces);
    X = zeros(N, nfaces);
    D = zeros(N);
    u = ones(nfaces, 1);
    %l = 1; % Tradeoff value; 0 -> MACE, 1 -> Minimum Variance SDF
    C = eye(N);

    for i=1:nfaces
        tf = imresize(squeeze(t(i,:,:)), [r c]);
        x(:,i) = tf(:);
        X(:,i) = fft(x(:, i));
        D = D + diag(abs(X(:,i)).^2);
    end

    T = l*C + (1 - l)*D;

    %H = inv(D) * X * inv(X' * inv(D) * X) * u;
    h = inv(T) * x * inv(x' * inv(T) * x) * u;
    %h = real(ifft(H));
    h = reshape(h, [r c]);
end
