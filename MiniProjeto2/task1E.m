clear all;
close all;

fprintf('Task 1 - Alinea E\n');

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

co= Nodes(:,1)+j*Nodes(:,2); %calculo para a distancia de cada no

L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
C= zeros(nNodes);  %Square matrix with arc capacities (in Gbps)
for i=1:nLinks
    %capacidade ou carga do link na pode ser maior que os 10 gigabits por segundo
    C(Links(i,1),Links(i,2))= 10;  %Gbps
    C(Links(i,2),Links(i,1))= 10;  %Gbps
    d= abs(co(Links(i,1))-co(Links(i,2)));
    %matriz L da nos o tamanho do link
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

% Compute up to 100 paths for each flow:
n= 100;
[sP nSP]= calculatePaths(L,T,n); 

%Optimization algorithm resorting to the random strategy:
fprintf('\nSolution random with all possible routing paths\n');
t= tic; 
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    for i= 1:nFlows
        sol(i)= randi(nSP(i)); 
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4)));
    allValues= [allValues load]; 
    if load<bestLoad
        bestSol= sol; 
        bestLoad= load;
    end
end
figure(1)
grid on
plot(sort(allValues));
title('Compare the algorithms - Task 1.E')

fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));


fprintf('\nSolution greedy ramdomized using all possible routing paths\n');
%Optimization algorithm resorting to the greedy randomized strategy:
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); 
    sol= zeros(1,nFlows);
    for i= ax2 
        k_best = 0;
        best = inf;
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

tempo= 10;
fprintf('\nSolution hill climbing using all possible routing paths\n');
%Optimization algorithm with multi start hill climbing:
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
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
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows 
            for k= 1:nSP(i) 
                if k~=sol(i)
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); 
                    load1= max(max(Loads(:,3:4))); 
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux;
                end
            end
        end
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
legend('Random using all possible','Greedy randomized using all possible','Hill climbing using all possible',Location="southeast");

fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));


fprintf('\nSolution random with 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
   
    for i= 1:nFlows
        n = min(10,nSP(i));
        sol(i)= randi(n);
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4))); 
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
figure(2);
grid on

plot(sort(allValues));
title('Compare the algorithms - Task 1.E')
fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));

fprintf('\nSolution greedy ramdomized using 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); % array numa ordem aleat??ria
    sol= zeros(1,nFlows);
    for i= ax2
        k_best = 0;
        best = inf;
        n = min(10,nSP(i)); 
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

fprintf('\nSolution hill climbing using 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
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
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows 
            for k= 1:nSP(i) 
                if k~=sol(i)
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); 
                    load1= max(max(Loads(:,3:4))); 
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux; 
                end
            end
        end
       
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


fprintf('\nSolution random with 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    for i= 1:nFlows
        n = min(5,nSP(i)); 
        sol(i)= randi(n);
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4))); 
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
figure(3)
grid on
plot(sort(allValues));
title('Compare the algorithms - Task 1.E')

fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));

fprintf('\nSolution greedy randomized using 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    ax2 = randperm(nFlows); 
    sol= zeros(1,nFlows);
    for i= ax2
        k_best = 0;
        best = inf;
        n = min(5,nSP(i)); 
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


fprintf('\nSolution hill climbing using 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
allValues= [];
contadortotal= [];
while toc(t)<tempo
    
    %GREEDY RANDOMIZED:
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
    continuar= true;
    while continuar
        i_best= 0;
        k_best= 0;
        best= load;
        for i= 1:nFlows 
            for k= 1:nSP(i) 
                if k~=sol(i) 
                    aux= sol(i);
                    sol(i)= k;
                    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); 
                    load1= max(max(Loads(:,3:4))); 
                    if load1<best
                        i_best= i;
                        k_best= k;
                        best= load1;
                    end
                    sol(i)= aux;
                end
            end
        end
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
legend('Random with 5 shortest','Greedy randomized with 5 shortest','Hill climbing with 5 shortest',Location="southeast");
fprintf('   Best load = %.2f Gbps\n',bestLoad);
fprintf('   No. of solutions = %d\n',length(allValues));
fprintf('   Av. quality of solutions = %.2f Gbps\n',mean(allValues));







