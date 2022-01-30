clear all;
close all;

fprintf('Task 1 - Alinea B\n');

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

%distancia entre os nos -> ver imagem dos slides
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
%calcula os n caminhos mais curtos calculatePaths
[sP nSP]= calculatePaths(L,T,n); %esta funcao retorna mais que um caminho para cada link (tabela -> sao 8 - 1 a 5, 1 a 2... ver no grafo)
%sP sao os caminhos e o nSp sao os custos dos caminhos sP

%Compute the link loads using the first (shortest) path of each flow:
%sol= ones(1,nFlows);
%Loads= calculateLinkLoads(nNodes,Links,T,sP,sol); %trafego de cada link
%maxLoad= max(max(Loads(:,3:4)));

%Optimization algorithm resorting to the random strategy:
fprintf('\nSolution random with all possible routing paths\n');
t= tic; %contagem de tempo tic (comecar a contar) e top (parar de contar)
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    for i= 1:nFlows
        sol(i)= randi(nSP(i)); %selecionar um custo random para cada fluxo
    end
    %trafego (carga) do link com custo= sol
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    %seleciona o que tem maior trafego
    load= max(max(Loads(:,3:4)));
    allValues= [allValues load]; %adiciona o load a matriz allValues
    %ve qual o caminho com o menor trafego -> link com menor trafego,
    %melhor para enviar pacotes
    if load<bestLoad
        bestSol= sol; %melhor custo random para cada fluxo (tabela dos slides)
        bestLoad= load;
    end
end
figure(1)
grid on
plot(sort(allValues));
title('Random Algorithm - Task 1.B')

fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));

fprintf('\nSolution random with 10 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    %ver os 10 percursos mais pequenos mas se tivermos menos que 10 caminhos
    %queremos todos eles.
    for i= 1:nFlows
        % nSP(i) -> numero de percursos queremos 10 desses, se nSP(i) <10
        % queremos nSP(i) -> todos
        n = min(10,nSP(i)); %correr so 10 vezes -> os primeiros 10
        sol(i)= randi(n);
        %sol = custo para cada fluxo
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4))); %maior trafego (carga) que existe -> o que passa no link
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


fprintf('\nSolution random with 5 shortest routing paths\n');
t= tic;
bestLoad= inf;
sol= zeros(1,nFlows);
allValues= [];
while toc(t)<10
    %ver os 5 percursos mais pequenos mas se tivermos menos que 5 caminhos
    %queremos todos eles.
    for i= 1:nFlows
        % nSP(i) -> numero de percursos queremos 5 desses, se nSP(i) <5
        % queremos nSP(i) -> todos
        n = min(5,nSP(i)); %correr so 5 vezes -> os primeiros 5
        sol(i)= randi(n);
        %sol = custo para cada fluxo
    end
    Loads= calculateLinkLoads(nNodes,Links,T,sP,sol);
    load= max(max(Loads(:,3:4))); %maior trafego (carga) que existe -> o que passa no link
    allValues= [allValues load];
    if load<bestLoad
        bestSol= sol;
        bestLoad= load;
    end
end
hold on
grid on
plot(sort(allValues));
legend('Random with all possible','Random with 10 shortest','Random with 5 shortest',Location="southeast");
fprintf('Worst link load value of the best solution = %.2f Gbps\n', bestLoad);
fprintf('Number of solutions generated = %d \n', length(allValues));
fprintf('Average quality of all solutions generated = %.2f Gbps\n', mean(allValues));
