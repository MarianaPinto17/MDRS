clear all;
close all;

fprintf('Task 1 - Alinea C\n');
Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;

nLinks= size(Links,1);
nFlows= size(T,1);

B= 625;  %Average packet size in Bytes

co= Nodes(:,1)+j*Nodes(:,2);

L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
C= zeros(nNodes);  %Square matrix with arc capacities (in Gbps)
for i=1:nLinks
    C(Links(i,1),Links(i,2))= 10;  %Gbps
    C(Links(i,2),Links(i,1))= 10;  %Gbps
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

% Compute up to 100 paths for each flow:
n= 100;
[sP nSP]= calculatePaths(L,T,n);

%Compute the link loads using the first (shortest) path of each flow:
%sol= ones(1,nFlows);
%Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
%maxLoad= max(max(Loads(:,3:4)));

fprintf('\nSolution greedy ramdomized using all possible routing paths\n');
%Optimization algorithm resorting to the greedy randomized strategy:
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); % array com numeros aleatórios com tamanho nFlows
    sol= zeros(1,nFlows);
    for i= ax2 %fluxos
        k_best = 0;
        best = inf;
        %calculo do custo minimo para os valores aleatorios do fluxo (origem e destino existem 8 fluxos)
        for k = 1:nSP(i) 
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                k_best = k;
                best = load;
            end
        end
        sol(i) = k_best; %melhor custo para o fluxo i
    end
    %calculo do trafego para o melhor custo -> como no random
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end

hold on 
grid on
plot(sort(allValues)); 
title('Greedy Randomized - Task 1.C')
fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));

fprintf('\nSolution greedy ramdomized using 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); % array numa ordem aleatória
    sol= zeros(1,nFlows);
    for i= ax2
        k_best = 0;
        best = inf;
        % nSP(i) -> numero de percursos queremos 10 desses, se nSP(i) <10
        % queremos nSP(i)
        n = min(10,nSP(i)); %correr so 10 vezes -> os primeiros 10
        for k = 1:n
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                k_best = k;
                best = load;
            end
        end
        sol(i) = k_best;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on 
grid on
plot(sort(allValues));
fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));


fprintf('\nSolution greedy randomized using 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); % array numa ordem aleatória
    sol= zeros(1,nFlows);
    for i= ax2
        k_best = 0;
        best = inf;
        % nSP(i) -> numero de percursos queremos 5 desses, se nSP(i) <5
        % queremos nSP(i)
        n = min(5,nSP(i)); %correr so 5 vezes -> os primeiros 5
        for k = 1:n
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load < best
                k_best = k;
                best = load;
            end
        end
        sol(i) = k_best;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on 
grid on
plot(sort(allValues));
legend('Greedy randomized using all possible','Greedy randomized using 10 shortest','Greedy randomized using 5 shortest',Location="southeast");
fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));
