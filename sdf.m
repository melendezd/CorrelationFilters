function [ h ] = sdf( t, u )
%SDF Synthetic Discriminant Function filter
%   t : Training set, [N r c] array containing N images of size [r c].
%   u : Response vector, u(i) is the filter's specified response to image i in t
    [nfaces, r, c] = size(t);

    % Place faces in columns of x
    x = zeros(r*c, nfaces);
    for i=1:nfaces
        x(:,i) = t(i,:);
    end

    h = reshape(x * inv(x' * x) * u, [r c]);
end
