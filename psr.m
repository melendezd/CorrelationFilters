function [ o ] = psr( s, rPeak, rSidelobe )
%PSR Finds the peak-to-sidelobe ratio of a 2d signal s given the peak width r1 and the sidelobe width r2

    % Find the peak
    [peak, ind] = max(s(:));
    [r c] = ind2sub(size(s),ind);


    r1 = max(1,r-rSidelobe);
    r2 = max(r1, r-rPeak);
    r3 = min(r+rPeak,size(s,1));
    r4 = min(r+rSidelobe,r3);
    c1 = max(1,c-rSidelobe);
    c2 = max(c1, c-rPeak);
    c3 = min(c+rPeak,size(s,2));
    c4 = min(c+rSidelobe,c3);

    ann1 = s([r1:r4], [c1:c2]);
    ann2 = s([r1:r2, r3:r4], [c2:c3]);
    ann3 = s([r1:r4], [c3:c4]);
    ann = [ann1(:); ann2(:); ann3(:)];

    o = (peak - mean(ann(:))) / std(ann(:));

end

