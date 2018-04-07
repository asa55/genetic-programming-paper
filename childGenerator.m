function [ child ] = childGenerator( mother, father )
%mutate() takes an input tree and outputs the same tree with a random mutation

numNodesMother = length(mother.depthfirstiterator);
numNodesFather = length(father.depthfirstiterator);
nandLeaf = 1;

if (numNodesMother > 1)      % we can add a mutation to a pre-existing tree
    mergePointMother = randi(numNodesMother);
    mergePointFather = randi(numNodesFather);
    mergePointParents = mother.getparent(mergePointMother);
    child = mother.chop(mergePointMother);
    child = child.graft(mergePointParents, father.subtree(mergePointFather));   
elseif (numNodesMother == 1) % or we can use this function to help us randomly generate an initial population
    child = mother;    
else                                                                                                                   % we may have already generated a mutation, but as for right now I am going to assume that if a valid tree was not passed in as an argument, we want to know about it so the code doesn't behave unexpectedly (by design there is no situation where we intend to pass no tree in but get a tree out)
    disp('arguments must contain a tree with at least one node')
end

end

