function [ corr ] = fxcorr2( s, f, dim )
%FXCORR2 Fast 2D cross-correlation using Fast Fourier Transform (FFT)
%   s   : Scene
%   f   : Filter
%   dim : Dimension [r c] of 2D Fourier transform

scene = squeeze(s);
filt = squeeze(f);
sizeCorr = size(scene) + size(filt) - 1;

if ~exist('dim', 'var')
    M = sizeCorr(1);
    N = sizeCorr(2);
else
    M = dim(1);
    N = dim(2);
end

corrFreq = fft2(scene, M, N) .* conj(fft2(filt, M, N));

[w h] = size(corrFreq);

% Get correlation output from FT
corr = ifft2(corrFreq,M,N);

% Do circular shift on output image
corr = circshift(corr, [M-size(scene,1) N-size(scene,2)]);

end

