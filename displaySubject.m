function [ ] = displaySubject( subj )
%DISPLAYSUBJECT Display a 3D array of images
%   Takes in a 3D array subj of size (n,r,c) containing n images
%   of size [r c].

    [N r c] = size(subj);
    for i=1:N
        subj2(i,:,:)=mat2gray(squeeze(subj(i,:,:)));
    end
    montage(permute(subj2,[2,3,4,1]));
end

