%faces = getFaces(192, 168);

sPath='yale/yaleB11/yaleB11_P00A+000E+00.pgm';
fPath='CroppedYale/yaleB11/yaleB11_P00A+000E+00.pgm';

s = double(imread(sPath));
f = double(imread(fPath));
%s=mat2gray(s);
%f=mat2gray(f);
sS = size(s);
sF = size(f);
sz = size(s) + size(f) - 1;
sw = sS(2);
sh = sS(1);
fw = sF(2);
fh = sF(1);

M=sz(1);
N=sz(2);

o1 = fxcorr2(s, f);

[m n] = max(o1(:));
[y x] = ind2sub(size(o1), n);
%x = x - (N - sw);
%y = y - (M - sh);
pos1 = [x y fw fh];
s = mat2gray(s);

%imagesc(o1)
imshow(s)
hold on;
rectangle('Position', pos1, 'EdgeColor', 'red');
%rectangle('Position', pos2, 'EdgeColor', 'green');
imshow(mat2gray(f))
hold off;
