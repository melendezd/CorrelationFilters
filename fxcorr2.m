function [ o1 ] = fxcorr2( s, f, dim )
%FXCORR2 Summary of this function goes here
%   Detailed explanation goes here

%s=mat2gray(s);
%f=mat2gray(f);

sS = size(s);
sF = size(f);
sw = sS(2);
sh = sS(1);
fw = sF(2);
fh = sF(1);
sz = size(s) + size(f) - 1;

if ~exist('dim', 'var')
    M=sz(1);
    N=sz(2);
else
    M = dim(1);
    N = dim(2);
end

o1f = fft2(s, M, N) .* conj(fft2(f, M, N));

[w h] = size(o1f);
a=size(o1f);
w = a(1);
h = a(2);

% Get image from FT
o1 = ifft2(o1f,M,N);

% Do circular shift on output image
%o1 = circshift(o1, [M-sh N-sw]);

end

