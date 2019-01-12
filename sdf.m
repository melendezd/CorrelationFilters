function [ h ] = sdf( t, u )
    [nfaces, r, c] = size(t);

    % Place faces in columns of x
    x = zeros(r*c, nfaces);
    for i=1:nfaces
        x(:,i) = t(i,:);
    end

    h = reshape(x * inv(x' * x) * u, [r c]);
end
