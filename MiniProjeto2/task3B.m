
clear all;
close all;

Nodes= [20 60
       250 30
       550 150
       310 100
       100 130
       580 230
       120 190
       400 220
       220 280];
   
Links= [1 2
        1 5
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        7 8
        7 9
        8 9];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  3.4 2.5
    3  4  2.4 2.1
    4  9  2.0 1.4
    5  6  1.2 1.5
    5  8  2.1 2.7
    5  9  2.6 1.9];

nNodes= 9;
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

fprintf("Task 3 - Alinea A\n");
MTBF = (450*360*24)./L;
A = MTBF./(MTBF+24); % a= availability
A(isnan(A))=0; % quando a matriz a tiver Nan mete essa posicao a 0 em vez do Nan

AuxL = -log(A)*100;
[sP nSP]= calculatePaths(L,T,1); %retorna o 1º caminho para cada link que e o melhor

for i=1:nFlows
    aux = cell2mat(sP{1});
    arr = size(aux);
    for j=2:length(aux)
        %AuxL(aux(j),aux(j+1))=inf;
        AuxL(aux(j),aux(j-1))= inf;
        AuxL(aux(j-1),aux(j))= inf;
    end
end

[sP2 nSP2]= calculatePaths(AuxL,T,1); %retorna o 1º caminho para cada link que e o melhor

%sP sao os caminhos e o nSp sao os custos dos caminhos sP
av = ones(1,nFlows); %avalibility tudo a 1 - inicializacao
for i = 1:nFlows
    
    aux = cell2mat(sP2{i}); %transforma o {...} num array para conseguirmos aceder ao que esta dentro dos {}
    arr = size(aux); % n de linhas n de colunas -> nos queremos os nos = n de colunas
    fprintf('Fluxo %d:\n',i);

    if ~isempty(sP2{i}{1})
        fprintf('\n   Second path: %d',sP2{i}{1}(1));
        for j= 2:length(sP2{i}{1})
            fprintf('-%d',sP2{i}{1}(j));
        end
       
        for j = 1:arr(1,2)-1  %percorre o fluxo i -> o array aux
            av(i) = av(i) * A(aux(j),aux(j+1));
            %estao sempre em serie, pois da sempre o caminho mais curto no
            %calculatePaths
        end
        aux = av(i)*100;
        fprintf("Disponibilidade= %f = %f%%\n",av(i),aux);
        

    end

    
end
