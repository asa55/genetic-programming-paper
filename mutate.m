function [ outTree ] = mutate( inTree, primitives )

numNodes = length(inTree.depthfirstiterator);
nandLeaf = 1;
lenPrim = length(primitives);

rootPrim = primitives(randi(lenPrim));
mutation = tree(rootPrim{1});                                                               % the curly brackets let us access the cell content

while (nandLeaf == 1)                                                         % this loop actually generates the mutation tree every time the function is called. it may be inefficient when the input parameter guves a null tree, but that would throw the whole experiment into error for other reasons so we won't consider the fact that we could cycle the code one too many times in this function's code
    if (rootPrim{1} == 1)                                                      % this is a code bandage since strcmp() won't return anything if the tree is only a single root node
        nandLocations = [1];
    else
        nandLocations = find(strcmp(mutation, '~and'));                       %we need to check all nand locations before knowing if we have nand gates at a leaf location
    end
    nandLeafCounter = 0;                                                        % this keeps the while loop going until there are no nand gates on a leaf node
    for i=1:length(nandLocations)
        if mutation.isleaf(nandLocations(i))                                   % this is where we actually check each nand location to see if it is a leaf
            nandLeafCounter = nandLeafCounter + 1;                              % if we have any nand gates on a leaf, this will keep the loop going for at least another cycle
            for j=1:2
                leafPrim = primitives(randi(lenPrim));
                mutation = mutation.addnode(nandLocations(i), leafPrim{1});  % we run this twice because it is a binary tree
            end
        end
    end
    if (nandLeafCounter == 0)                                                 % let the while loop close if there are no nand gates on a leaf. technically we don't check to verify that the tree is in fact a binary tree, but we can do that by inspection using a disp(outTree.totext) command during debugging, not to mention the logic would throw an error at runtime
        nandLeaf = 0;
    end
end

if (numNodes > 1)                                                            % we can add a mutation to a pre-existing tree
    mutPoint = randi(numNodes-1)+1;                                           % this ensures the mutation point won't be the root node, which caused unexpected behaviors during testing
    mutPointParent = inTree.getparent(mutPoint);
    outTree = inTree.chop(mutPoint);
    outTree = outTree.graft(mutPointParent, mutation);   
elseif (numNodes == 1)                                                        % or we can use this function to help us randomly generate an initial population
    outTree = mutation;    
else                                                                               % we may have already generated a mutation, but as for right now I am going to assume that if a valid tree was not passed in as an argument, we want to know about it so the code doesn't behave unexpectedly (by design there is no situation where we intend to pass no tree in but get a tree out)
    disp('arguments must contain a tree with at least one node')
end

end

