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
     obs_more_than_k_(Obs,K),
     random_k_from_Obs_(Obs,K,RandCs),
     partition_(Obs,RandCs,NewCluster),
     kmeans_recursive(Obs,[],NewCluster,Cluster).

%Trova il centroide di una lista (cluster)
centroid(List,Cs):-
     length(List,L),
     media_(List,L,Cs).

%Esegue la somma vettoriale tra due vettori
vplus([],[],[]):-!.
vplus([A|Ar], [B|Br], [N|R]):-
     number(A),
     number(B),
     N is A + B,
     vplus(Ar,Br,R).

%Esegue la differenza vettoriale tra due vettori
vminus([],[],[]):-!.
vminus([A|Ar], [B|Br], [N|R]):-
     number(A),
     number(B),
     N is A - B,
     vminus(Ar,Br,R).

%Esegue il prodotto interno tra due vettori
innerprod([],[],0):-!.
innerprod([A|Ar],[B|Br],InnerProd):-
     innerprod(Ar,Br,R),
     number(A),
     number(B),
     InnerProd is R + (A * B).

%Calcola la norma di un vettore 
norm(V,R):-
     innerprod(V,V,I),
     sqrt(I,R).

%Crea un nuovo vettore associando ad esso un nome
new_vector(Name, Vector) :-
	atom(Name),
	is_vector_(Vector),
	assert(vector(Name, Vector)).


% Funzioni ausiliarie impiegate nell'uso interno


% L'effettivo algoritmo ricorsivo kmeans. Esegue un controllo su 
% Cluster e NewCluster nel  caso base: si controlla se i nuovi 
% cluster sono uguali a quelli precedenti e, in caso positivo,
% si termina la procedura

kmeans_recursive(_,Cluster,NewCluster,NewCluster):-
     same_clusters_(Cluster,NewCluster).
kmeans_recursive(Obs,_,Cluster,RCluster):-
     prepare_centroid_(Cluster,Cs),
     partition_(Obs,Cs,NewCluster),
     kmeans_recursive(Obs,Cluster,NewCluster,RCluster).

% Calcola i K centroidi prendendoli casualmente tra le osservazioni.
% Lavora su una lista Obs, che viene ogni volta accorciata
% rimuovendo l'elemento preso casualmente
random_k_from_Obs_(_,0,[]):-!.
random_k_from_Obs_(Obs,K,[Centroid|Cr]):-
     length(Obs,L),
     random(0,L,R),
     nth0(R,Obs,Centroid),
     delete(Obs,Centroid,ObsRest),
     K1 is K - 1,
     random_k_from_Obs_(ObsRest,K1,Cr).

%Chiama le funzioni che creano i cluster
partition_(Obs,Cs,Pa):-
     pair_With_The_Closest_(Obs,Cs,Pair),
     make_partition_(Pair,Cs,Pa).

% Riceve una lista di coppie (tuple) e, confrontandole
% con un centroide alla volta, forma i cluster.
% Per diminuire i controlli con la lista di coppie, gli elementi
% gia' inseriti nei cluster vengono rimossi dalla lista
make_partition_([], _, []).
make_partition_(A, [X|Xr], [List|R]) :-
    fill_list_and_remove_frs_(A, X, List, RestInput),
    make_partition_(RestInput, Xr, R).

% Riempie il cluster associato ad ogni centroide e restituisce
% la lista di coppie senza gli elementi che hanno
% l'associazione con il centroide gia analizzato
fill_list_and_remove_frs_([], _, [], []):- !.
fill_list_and_remove_frs_([(X, E)|Ar], X, [E|Lr], R):-
    fill_list_and_remove_frs_(Ar, X, Lr, R).
fill_list_and_remove_frs_([(Y, E)|Ar], X, L, [(Y,E)|Rr]):-
    dif(X, Y),
    fill_list_and_remove_frs_(Ar, X, L, Rr).

% Crea una lista di coppie (Centroide|Osservazione) con il centroide
% piu' vicino
pair_With_The_Closest_([],_,[]):-!.
pair_With_The_Closest_([A|Ar],Cs,[(C,A)|R]):-
     closest_(A,Cs,C),
     pair_With_The_Closest_(Ar,Cs,R).

%Calcola il centroide più vicino
closest_(_,[X],X):-!.
closest_(E,[H|T],R):-
     distance_(H,E,D),
     closest_(E,T,R),
     distance_(E,R,D1),
     D > D1,
     !.
closest_(_,[H|_],H).

%Calcola la distanza tra due vettori
distance_(A,B,Dist):-
     vminus(A,B,Sub),
     norm(Sub,Dist).

%Permette di chiamare k volte la funzione centroid
prepare_centroid_([],[]):-!.
prepare_centroid_([A|Ar],[Cs|R]):-
     centroid(A,Cs),
     prepare_centroid_(Ar,R).

% Verifica se due liste di cluster sono uguali chiamando, per
% ogni cluster, la funzione che li analizza singolarmente
same_clusters_([],[]):-!.
same_clusters_([A|Ar],[B|Br]):-
     same_cluster_(A,B),
     same_clusters_(Ar,Br).

%Verifica che un cluster sia uguale ad un altro
same_cluster_([],[]):-!.
same_cluster_([A|Ar],[B|Br]):-
     same_vector_(A,B),
     same_cluster_(Ar,Br).

% Prepara il calcolo per trovare il centroide, chiamando la
% funzione sum_all. Dopo aver ottenuto il risultato, chiama
% l'effettiva funzione per il calcolo della media (media0_)
media_(A,L,R):-
     sum_all_(A,Summ),
     media0_(Summ,L,R).

%Calcola le coordinate per un centroide
media0_([],_,[]):-!.
media0_([A|Ar],L,[M|R]):-
     M is A / L,
     media0_(Ar,L,R).

%Applica la funzione vplus a tutti gli elementi del cluster
sum_all_([A],A):-!.
sum_all_([A|Ar],R):-
     sum_all_(Ar,Vs),
     vplus(A,Vs,R).

%Verifica se due vettori sono uguali
same_vector_([],[]):-!.
same_vector_([A|Ar],[A|Ar1]):-
     same_vector_(Ar,Ar1).

% Verifica se un vettore è corretto in termini di
% struttura e composto unicamente da numeri
is_vector_([]):-!.
is_vector_([X | Vector]) :-
	number(X),
	is_vector_(Vector).

% Controlla che le osservazioni siano maggiori del
% numero di cluster
obs_more_than_k_([_],K):-
     K < 0.
obs_more_than_k_([_|Ar],K):-
     K1 is K - 1,
     obs_more_than_k_(Ar,K1).
