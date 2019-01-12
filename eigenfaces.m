clear all

N=38;
%w=192;
%h=168;
w=100;
h=100;

imgs = getFaces(w, h);

% calculate average and subtract it from faces
imgs = bsxfun(@minus, imgs, mean(imgs));

% put faces in columns
F = reshape(imgs, [N w*h])';

% calculate covariance matrix eigenvalues/eigenvectors (columns of U)
C = F' * F;
[V, L] = eig(C);
r=size(L);

% remove garbage
for i = 1:r
    if L(i,i) <= 0
        L(i,:)=[];
        L(:,i)=[];
        V(:,i)=[];
        N = N - 1;
        break;
    end
end

LL=diag(diag(L).^(-1/2));

% the columns of U are the eigenfaces
U = F * V * LL;

% normalize eigenfaces for display
for j=1:N
    temp = reshape(U(:,j), [w h]);
    temp = mat2gray(temp);
    eigen(j,:,:) = temp;
end
eigen = flip(eigen);
eigen = permute(eigen,[2 3 4 1]);

montage(eigen)
