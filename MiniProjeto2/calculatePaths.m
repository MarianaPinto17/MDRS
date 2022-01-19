function [sP nSP]= calculatePaths(L,T,n)
    nFlows= size(T,1);
    nSP= zeros(1,nFlows);
    for i=1:nFlows
        [shortestPath, totalCost] = kShortestPath(L,T(i,1),T(i,2),n); 
        % com n = 1 o kShortestPath danos o percurso com custo minimo = 1º percurso
        sP{i}= shortestPath;
        nSP(i)= length(totalCost);
    end
end