function [ accuracy ] = cAccuracy( C )
%cACCURACY Calculates the accuracy of a classifier from a confusion matrix
    accuracy = sum(diag(C))/sum(C(:));
end

