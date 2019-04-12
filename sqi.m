function [ SQI ] = sqi( img )
  %SQI Summary of this function goes here
  %   Detailed explanation goes here

  % Compute Gaussian Kernels
  kernelSizes = [4 8 16 32, 64, 128];
  gaussians = arrayfun(@(N) fspecial('gaussian', [N N], N/5), kernelSizes, ...
    'UniformOutput', false);

  % Smooth image with kernels
  smoothed_imgs = cellfun(@(g) anisotropic_smooth(img, g), gaussians, 'UniformOutput', false);
  quotients = cellfun(@(smoothed_img) (double(img)) ./ (double(smoothed_img)), ... 
    smoothed_imgs, 'UniformOutput', false);

  % Fix and transform quotients
  for i=1:numel(quotients)
    % Obtain max and min, ignoring infinite values
    % Replace Inf values with max
    Q = quotients{i};
    q_min = min(Q(:));
    Q(isinf(Q(:))) = -Inf;
    q_max = max(Q(:));
    Q(isinf(Q(:))) = q_max;

    % Fix NaN values and transform
    Q(isnan(Q(:))) = 1;
    Q = atan(Q);
    transformed_quotients{i} = Q;
  end
  SQI = sum(cat(3,transformed_quotients{:}), 3);
end

% Precondition: size(h) = [n n] where n,n even
function [img_smoothed] = anisotropic_smooth( img, h )
  % Pad image with zeros
  filt_size = size(h,1);
  pad_size = size(img,1)/2;
  img_padded = padarray(img, [pad_size pad_size], 'both');

  % Perform convolution
  img_smoothed = zeros(size(img));
  for r = (1+pad_size) : (size(img_padded,1) - pad_size)
    for c = (1+pad_size) : (size(img_padded, 2) - pad_size);
      conv_region_inds_r = [(r - filt_size/2):(r + filt_size/2-1)];
      conv_region_inds_c = [(c - filt_size/2):(c + filt_size/2-1)];
      conv_region = img_padded(conv_region_inds_r, conv_region_inds_c);

      % Separate convolution region into two regions based on threshold t
      % M1 and M2 contain indices corresponding to the regions
      % M1 is the larger region
      t = mean(conv_region(:));
      M1 = find(conv_region <= t);
      M2 = find(conv_region > t);
      if size(M1(:)) < size(M2(:))
        [M1 M2] = deal(M2, M1);
      end

      % Apply weights to filter and normalize
      weights = zeros(size(h));
      weights(M1) = 1;
      % Normalization factor
      w = h .* weights;
      w = w / sum(w(:));

      img_smoothed(r-pad_size,c-pad_size) = dot(double(conv_region(:)), double(w(:)));
    end
  end
end
