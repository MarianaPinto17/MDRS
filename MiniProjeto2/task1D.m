clear all;
close all;

fprintf("Task 1 - Alinea D\n");
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

co= Nodes(:,1)+j*Nodes(:,2);
L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
for i=1:nLinks
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

% Compute up to n paths for each flow:
n= inf;
[sP nSP]= calculatePaths(L,T,n);

tempo= 10;

fprintf('\nSolution hill climbing using all possible routing paths\n');
%Optimization algorithm with multi start hill climbing:
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
    %construir uma solucao
    ax2= randperm(nFlows);
    sol= zeros(1,nFlows);
    for i= ax2
        k_best= 0;
        best= inf;
        for k= 1:nSP(i)
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load<best
                k_best= k;
                best= load;
            end
        end
        sol(i)= k_best;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= best;
    
    %HILL CLIMBING:
    %pegar na solucao do greedy e escolher a solucao com o hill climbing
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows %cada fluxo
            for k= 1:nSP(i) %cada percurso -> vamos a cada fluxo e a cada percurso do fluxo
                if k~=sol(i) %se o percurso for diferente do atualmente escolhido
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); % calculo cargas
                    load1= max(max(Loads(:,3:4))); %calculo carga maxima
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux; %repor o fluxo original
                end
            end
        end
        %quando nenhuma das solucoes for melhor, ele para -> i_best=0 (nao
        %houve troca dentro dos fores)
        if i_best>0 
            sol(i_best)= k_best;
            load= best;
        else
            continuar= false;
        end
    end
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
figure(1);
grid on
plot(sort(allValues));
title('Multi Start Hill Climbing - Task 1.D');

fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));

% saltamos para a 1 solucao rapidamente no hill climbing-> mais eficiente

fprintf('\nSolution hill climbing using 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
    %construir uma solucao
    ax2= randperm(nFlows);
    sol= zeros(1,nFlows);
    for i= ax2
        k_best= 0;
        best= inf;
        n = min(10,nSP(i));
        for k= 1:n
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load<best
                k_best= k;
                best= load;
            end
        end
        sol(i)= k_best;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= best;
    
    %HILL CLIMBING:
    %pegar na solucao do greedy e escolher a solucao com o hill climbing
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows %cada fluxo
            for k= 1:nSP(i) %cada percurso -> vamos a cada fluxo e a cada percurso do fluxo
                if k~=sol(i) %se o percurso for diferente do atualmente escolhido
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); % calculo cargas
                    load1= max(max(Loads(:,3:4))); %calculo carga maxima
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux; %repor o fluxo original
                end
            end
        end
        %quando nenhuma das solucoes for melhor, ele para -> i_best=0 (nao
        %houve troca dentro dos fores)
        if i_best>0 
            sol(i_best)= k_best;
            load= best;
        else
            continuar= false;
        end
    end
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on
grid on
plot(sort(allValues));

fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));





fprintf('\nSolution hill climbing using 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
    %construir uma solucao
    ax2= randperm(nFlows);
    sol= zeros(1,nFlows);
    for i= ax2
        k_best= 0;
        best= inf;
        n = min(5,nSP(i));
        for k= 1:n
            sol(i)= k;
            Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
            load= max(max(Loads(:,3:4)));
            if load<best
                k_best= k;
                best= load;
            end
        end
        sol(i)= k_best;
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= best;
    
    %HILL CLIMBING:
    %pegar na solucao do greedy e escolher a solucao com o hill climbing
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows %cada fluxo
            for k= 1:nSP(i) %cada percurso -> vamos a cada fluxo e a cada percurso do fluxo
                if k~=sol(i) %se o percurso for diferente do atualmente escolhido
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); % calculo cargas
                    load1= max(max(Loads(:,3:4))); %calculo carga maxima
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux; %repor o fluxo original
                end
            end
        end
        %quando nenhuma das solucoes for melhor, ele para -> i_best=0 (nao
        %houve troca dentro dos fores)
        if i_best>0 
            sol(i_best)= k_best;
            load= best;
        else
            continuar= false;
        end
    end
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on
grid on
plot(sort(allValues));
legend('Hill climbing using all possible','Hill climbing using 10 shortest','Hill climbing using 5 shortest',Location="southeast");
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));
