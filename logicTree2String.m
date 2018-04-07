function [ logicString ] = logicTree2String( logicTree )
% logicTree2String takes elements of logicPopulation and assembles it as a
% text string (which can then be easily transformed into executable logic)

dfsIterator = logicTree.depthfirstiterator;
logicString = [];
for i=1:(length(dfsIterator) - 1)
    logicString = [logicString logicTree.get(dfsIterator(i))];
    treeNavigator = logicTree.findpath(dfsIterator(i), dfsIterator(i+1));
    if (length(treeNavigator) == 2)  % this trick came by observation --  
        logicString = [logicString '('];% if the path to the next location 
    elseif (length(treeNavigator) > 2) % of  size 1 in a DFS, the move must
        if (length(treeNavigator) > 3) % be 'down' the tree
            for j=1:(length(treeNavigator) - 3)
                logicString = [logicString ')'];
            end
        end
        logicString = [logicString ','];
    else
        disp('something went wrong')
    end
end

treeNavigator = logicTree.findpath(dfsIterator(end), dfsIterator(1));
logicString = [logicString logicTree.get(dfsIterator(end))];
for j=1:(length(treeNavigator) - 1)
    logicString = [logicString ')'];
end
        
end

