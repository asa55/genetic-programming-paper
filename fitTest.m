function [ fitnessScores ] = fitTest( stringPopulation, primitives, truthTableOutputs )
%fitTest() takes a structure of logic in string form, converts the string
%to a function handle, then uses each handle to test the complete set of IO
%characteristics against the desired operability given a truth table

fitnessScores = [];
primString = [];
truthTableInputs = num2cell(de2bi(0:(length(truthTableOutputs)-1)));                                                % this line is critically important. If you're wondering why all these conversions are here it has to do with letting the inputs to generated function handles have a variable size. Not an easy task once you sit down and really think about how to implement this.

for i = 1:(length(primitives) - 2)
    primString = [primString primitives{i+1} ', '];
end

primString = [primString primitives{length(primitives)}];
for i = 1:length(stringPopulation)
    currentScore = 0;
    for j = 1:(length(truthTableOutputs))
        fh = str2func(['@(' primString ') (' num2str(truthTableOutputs(j)) '== ' stringPopulation{i} ')']);
        currentScore = currentScore + fh(truthTableInputs{j,:});
    end
    fitnessScores(i) = currentScore;
end
    
end

