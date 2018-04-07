
% define the total population size. This will never change throughout the
% experiment. If multiple high performers are desired to be pulled from a
% given generation, they will be pulled from a subset of
% the total population satisfying two conditions:
% (1) the reference truth table is satisfied completely
% (2) the scores are all equal to the maximum score
N = 5000;
firstGeneration = 1; % this parameter is used to start a new experiment.
                     % each time main is run, a new generation or next
                     % generation is created depending on the setting of
                     % this bit. If a new generation is desired, I
                     % recommend using the clear all command from the
                     % command window interface to guarantee everything is
                     % starting fresh at the start of the new experiment

% first define the logic primitive, then all inputs. NAND is chosen as it
% can be used to generate all possible logic gates. Interestingly, the way
% I have decided to code the mutate function enables the possibility of
% adding new input-type primitives during an experimental run. What I mean
% by this is that when a new population is generated, if you stop the
% process, add an input primitive to the list below, then create a new
% generation, the new input will appear per expectations randomly
% throughout the logic population. This is intuitively useul from a
% biological standpoint as it enables the population to learn how to
% respond to new stimuli they may never have been subject to previously.
primitives{1} = '~and';
primitives{2} = 'x1';
primitives{3} = 'x2';
primitives{4} = 'x3';
alfa = 0.075;                                                        % proportion of fit individuals that live to next generation
beta = 0.2;                                                             % proportion of mutations at the start of each new generation
alfaN = ceil(alfa*N);

truthTableOutputs = [0 1 1 0 0 1 0 1];                               % this truth table assumes the primitive inputs count up in normal order (these are calculated in the fitTest() function). For 2 inputs, this is x1=x2=0, x1=0 x2=1, x1=1 x2=0, and x1=x2=1.

if (firstGeneration == 1)
    currentGeneration = 1;
    for i = 1:N
        logicPopulation{i} = tree();
    end
else
    currentGeneration = currentGeneration + 1;
end

for i = 1:length(logicPopulation)
    if (firstGeneration == 1)
        logicPopulation{i}=mutate(logicPopulation{i},primitives);
    else
        x=rand;
        if x<beta
            logicPopulation{i}=mutate(logicPopulation{i},primitives);
        end
    end
    
stringPopulation{i} = logicTree2String(logicPopulation{i});                      % delete semicolon to show logic string
disp(logicPopulation{i}.tostring)                                               % uncomment to show trees. I recommend uncommenting this and the line above together to easily compare trees to strings

end

fitnessScores = fitTest(stringPopulation, primitives, truthTableOutputs);

if ~(firstGeneration == 1)
    [bestFit, bestFitIndexes] = maxk(fitnessScores, alfaN);
    
    for l = 1:alfaN % the index is a lower case L
        nextGenLogicPopulation{l} = logicPopulation{bestFitIndexes(l)};                                                                     % the best fit from the previous population fill the first entries of the next generation's population
    end
    for m = (alfaN+1):N                                                                                                                   % the remainder of the next gen's population consists of children, which in the strict sense of programming best practices should not be hard coded in Main.m but it is here for now. Possible update in future rev of code.
        parentIndexes = (randi(alfaN, [2,1]));
        nextGenLogicPopulation{m} = childGenerator(nextGenLogicPopulation{parentIndexes(1)},nextGenLogicPopulation{parentIndexes(2)});
    end
    for n = 1:length(nextGenLogicPopulation)
        nextGenStringPopulation{n} = logicTree2String(nextGenLogicPopulation{n});
    end
nextGenFitnessScores = fitTest(nextGenStringPopulation, primitives, truthTableOutputs);
logicPopulation = nextGenLogicPopulation;
end
    