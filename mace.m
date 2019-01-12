function [ h ] = mace( t, u, SIZE )
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
        tf = imresize(squeeze(t(i,:,:)), [r c]);
        x(:,i) = tf(:);
        X(:,i) = fft(x(:, i));
        D = D + diag(abs(X(:,1)).^2);
    end

    H = inv(D) * X * inv(X' * inv(D) * X) * u;
    h = real(ifft(H));
    h = reshape(h, [r c]);
end
