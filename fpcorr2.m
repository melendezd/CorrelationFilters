function [ o1 ] = fpcorr2( s, f, dim )
%FPCORR2 Fast 2D phase-only cross-correlation using Fast Fourier Transform (FFT)
%   s   : Scene
%   f   : Filter
%   dim : Dimension [r c] of 2D Fourier transform

s=squeeze(s); % scene
f=squeeze(f); % filter

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
o1f = o1f / abs(o1f);

[w h] = size(o1f);
a=size(o1f);
w = a(1);
h = a(2);

% Get image from FT
o1 = ifft2(o1f,M,N);

% Do circular shift on output image
%o1 = circshift(o1, [M-sh N-sw]);

end

