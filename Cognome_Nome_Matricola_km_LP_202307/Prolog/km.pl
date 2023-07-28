%Bernasconi Giorgio Luigi Maria 885948
%Asadbigi Parham 879245
%Cambiago Silvia 879382

%Funzioni dell'interfaccia pensate per l'uso esterno

%kmeans viene eseguito solo la prima volta e permette di trovare i
%primi centroidi e le loro partizioni, per poi chiamare la vera
%funziona kmeans ricorsiva

% Applica l'algoritmo kmeans a una lista di osservazioni
% racchiudendole in k cluster
kmeans(Obs,K,Cluster):-
     obs_more_than_k(Obs,K),
     random_k_from_Obs(Obs,K,RandCs),
     partition(Obs,RandCs,NewCluster),
     kmeans_recursive(Obs,[],NewCluster,Cluster).

% L'effettivo algoritmo ricorsivo kmeans che ha un parametro 
% in più. Esegue un controllo su Cluster e NewCluster nel 
% caso base: si controlla se i nuovi cluster sono uguali a 
% quelli precedenti e, in caso positivo, 
% si termina la procedura

kmeans_recursive(_,Cluster,NewCluster,NewCluster):-
     same_clusters(Cluster,NewCluster).
kmeans_recursive(Obs,_,Cluster,RCluster):-
     prepare_centroid(Cluster,Cs),
     partition(Obs,Cs,NewCluster),
     kmeans_recursive(Obs,Cluster,NewCluster,RCluster).

%Trova il centroide di una lista (cluster)
centroid(List,Cs):-
     length(List,L),
     media(List,L,Cs).

%Esegue la somma tra V1 e V2
vplus([],[],[]):-!.
vplus([A|Ar], [B|Br], [N|R]):-
     N is A+B,
     vplus(Ar,Br,R).

%Esegue la sottrazione tra V1 e V2
vminus([],[],[]):-!.
vminus([A|Ar], [B|Br], [N|R]):-
     N is A-B,
     vminus(Ar,Br,R).

%Esegue il prodotto interno tra V1 e V2
innerprod([],[],0):-!.
innerprod([A|Ar],[B|Br],InnerProd):-
     innerprod(Ar,Br,R),
     InnerProd is R+(A*B).

%Calcola la norma del vettore V
norm(A,R):-
     innerprod(A,A,I),
     sqrt(I,R).

%Crea un nuovo vettore associando ad esso un nome
new_vector(Name, Vector) :-
	atom(Name),
	is_vector(Vector),
	assert(vector(Name, Vector)).


% Funzioni ausiliarie impiegate nell'uso interno


random_k_from_Obs(_,0,[]):-!.
random_k_from_Obs(Obs,K,[Centroid|Cr]):-
     length(Obs,L),
     random(0,L,R),
     nth0(R,Obs,Centroid),
     delete(Obs,Centroid,ObsRest),
     K1 is K-1,
     random_k_from_Obs(ObsRest,K1,Cr).

%Chiama le funzioni che creano i cluster
partition(Obs,Cs,Pa):-
     pair_With_The_Closest(Obs,Cs,Pair),
     make_partition(Pair,Cs,Pa).

% Riceve una lista di coppie (tuple) e, confrontando 
% con un centroide alla volta, forma i cluster.
% Per diminuire i controlli con la lista di coppie, gli elementi 
% gia' inseriti nei cluster vengono rimossi dalla lista
make_partition([], _, []).
make_partition(A, [X|Xr], [List|R]) :-
    fill_list_and_remuve_frs(A, X, List, RestInput),
    make_partition(RestInput, Xr, R).

% Riempie il cluster associato ad ogni centroide e restituisce
% la lista di coppie senza gli elementiche hanno l'associazione 
% con il centroide gia analizzato
fill_list_and_remuve_frs([], _, [], []):- !.
fill_list_and_remuve_frs([(X, E)|Ar], X, [E|Lr], R):-
    fill_list_and_remuve_frs(Ar, X, Lr, R).
fill_list_and_remuve_frs([(Y, E)|Ar], X, L, [(Y,E)|Rr]):-
    dif(X, Y),
    fill_list_and_remuve_frs(Ar, X, L, Rr).

% Crea una lista di coppie (Centroide|Osservazione) con il centroide più
% vicino
pair_With_The_Closest([],_,[]):-!.
pair_With_The_Closest([A|Ar],Cs,[(C,A)|R]):-
     closest(A,Cs,C),
     pair_With_The_Closest(Ar,Cs,R).

%Calcola il centroide più vicino
closest(_,[X],X):-!.
closest(E,[H|T],R):-
     distance(H,E,D),
     closest(E,T,R),
     distance(E,R,D1),
     D > D1,
     !.
closest(_,[H|_],H).

%Calcola la distanza tra due vettori
distance(A,B,Dist):-
     vminus(A,B,Sub),
     norm(Sub,Dist).

%Permette di chiamare k volte la funzione centroid
prepare_centroid([],[]):-!.
prepare_centroid([A|Ar],[Cs|R]):-
     centroid(A,Cs),
     prepare_centroid(Ar,R).

% Verifica se due liste di cluster sono uguli chiamando, per
% ogni cluster, la funzione che li analizza singolarmente
same_clusters([],[]):-!.
same_clusters([A|Ar],[B|Br]):-
     same_cluster(A,B),
     same_clusters(Ar,Br).

%Verifica che un cluster sia uguale ad un altro
same_cluster([],[]):-!.
same_cluster([A|Ar],[B|Br]):-
     same_vector(A,B),
     same_cluster(Ar,Br).

% Prepara il calcolo per trovare il centroide, chiamando la
% funzione sum_all. Dopo aver ottenuto il risultato, chiama 
% l'effettiva funzione per il calcolo della media (media0)
media(A,L,R):-
     sum_all(A,Summ),
     media0(Summ,L,R).

%Calcola le coordinate per un centroide
media0([],_,[]):-!.
media0([A|Ar],L,[M|R]):-
     M is A/L,
     media0(Ar,L,R).

%Applica la funzione vplus a tutti gli elementi del cluster
sum_all([A],A):-!.
sum_all([A|Ar],R):-
     sum_all(Ar,Vs),
     vplus(A,Vs,R).

%Verifica se due vettori sono uguali
same_vector([],[]):-!.
same_vector([A|Ar],[A|Ar1]):-
     same_vector(Ar,Ar1).

% Verifica se un vettore è corretto in termini di 
% struttura e composto unicamente da numeri
is_vector([]):-!.
is_vector([X | Vector]) :-
	number(X),
	is_vector(Vector).

% Controlla che le osservazioni siano maggiori del
% numero di cluster 
obs_more_than_k([_],K):-
     K < 0.
obs_more_than_k([_|Ar],K):-
     K1 is K - 1,
     obs_more_than_k(Ar,K1).
