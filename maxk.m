function [ values, indexes ] = maxk( inputVector, k )
%this function exists in later versions of Matlab than I am running...
%(2015b)

values = [];
indexes = [];

for i = 1:k
    [nextMax, nextMaxIndex] = max(inputVector);
    values = [values, nextMax];
    indexes = [indexes, nextMaxIndex];
    inputVector(nextMaxIndex) = [];
end

