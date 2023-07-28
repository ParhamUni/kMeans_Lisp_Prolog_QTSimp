%Bernasconi Giorgio Luigi Maria 885948
%Asadbigi Parham 879245
%Cambiago Silvia 879382


%kmeans viene eseguito solo la prima volta e permette di trovare i
%primi centroidi e le loro partizioni, per poi chiamare la vera
%funziona kmeans ricorsiva
% kmeans/3 applica l'algoritmo kmeans a una lista di osservazioni
% racchiudendoli in k cluster
kmeans(Obs,K,Cluster):-
     obs_more_than_k(Obs,K),
     random_k_from_Obs(Obs,K,RandCs),
     partition(Obs,RandCs,NewCluster),
     kmeans_recursive(Obs,[],NewCluster,Cluster).

% il vero algoritmo ricorsivo kmeans che ha un parametro in più, infatti
% Cluster e NewCluster che nel caso base vengono controllati se i nuovi
% cluster sono uguali a quelli precedenti e quindi se la procedura può
% terminare
kmeans_recursive(_,Cluster,NewCluster,NewCluster):-
     same_clusters(Cluster,NewCluster).
kmeans_recursive(Obs,_,Cluster,RCluster):-
     prepare_centroid(Cluster,Cs),
     partition(Obs,Cs,NewCluster),
     kmeans_recursive(Obs,Cluster,NewCluster,RCluster).

%centroid(L,Cs) trova il centroide di una lista(cluster)
centroid(List,Cs):-
     length(List,L),
     media(List,L,Cs).

%vplus(V1,V2,Vplus) aggiunge V1 and V2
vplus([],[],[]):-!.
vplus([A|Ar], [B|Br], [N|R]):-
     N is A+B,
     vplus(Ar,Br,R).

%vminus(V1,V2,Vminus) sottrae V2 to V1
vminus([],[],[]):-!.
vminus([A|Ar], [B|Br], [N|R]):-
     N is A-B,
     vminus(Ar,Br,R).

%innerprod(V1, V2, InnerProd) fa il prodotto tra V1 e V2
innerprod([],[],0):-!.
innerprod([A|Ar],[B|Br],InnerProd):-
     innerprod(Ar,Br,R),
     InnerProd is R+(A*B).

%norm(V, Norm) calcola la norma del vettore V
norm(A,R):-
     innerprod(A,A,I),
     sqrt(I,R).


new_vector(Name, Vector) :-
	atom(Name),
	is_vector(Vector),
	assert(vector(Name, Vector)).





% Da qui in poi ci sono solo funzioni che utilizzo per eseguire il
% programma


random_k_from_Obs(_,0,[]):-!.
random_k_from_Obs(Obs,K,[Centroid|Cr]):-
     length(Obs,L),
     random(0,L,R),
     nth0(R,Obs,Centroid),
     delete(Obs,Centroid,ObsRest),
     K1 is K-1,
     random_k_from_Obs(ObsRest,K1,Cr).


%partition/3 chiama le funzioni che creano i cluster
partition(Obs,Cs,Pa):-
     pair_With_The_Closest(Obs,Cs,Pair),
     make_partition(Pair,Cs,Pa).


% make_partition riceve una lista di coppie(tuple) e confrontando con un
% centroide alla volta forma i cluster, per diminuire i controlli con la
% lista di coppie gli elementi gia inseriti nei cluster vengono rimossi
% dalla lista di tuple
make_partition([], _, []).
make_partition(A, [X|Xr], [List|R]) :-
    fill_list_and_remuve_frs(A, X, List, RestInput),
    make_partition(RestInput, Xr, R).


% fill_list_and_remuve frs si occupa di riempire il cluster associato a
% ogni centroide e di restituire la lista di coppie senza gli elementi
% che hanno l'associazione con il centroide gia analizzato
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



%closest calcola il centroide più vicino
closest(_,[X],X):-!.
closest(E,[H|T],R):-
     distance(H,E,D),
     closest(E,T,R),
     distance(E,R,D1),
     D > D1,
     !.
closest(_,[H|_],H).


%distance calcola la distanza tra due vettori
distance(A,B,Dist):-
     vminus(A,B,Sub),
     norm(Sub,Dist).


%prepare_centroid permette di chiamare k volte la funzione centroid
prepare_centroid([],[]):-!.
prepare_centroid([A|Ar],[Cs|R]):-
     centroid(A,Cs),
     prepare_centroid(Ar,R).


% same_cluster verifica se due liste di cluster sono uguli chiamando per
% ogni cluster la funzione che li analizza singolarmente
same_clusters([],[]):-!.
same_clusters([A|Ar],[B|Br]):-
     same_cluster(A,B),
     same_clusters(Ar,Br).


%same_cluster verifica che un cluster sia uguale a un altro
same_cluster([],[]):-!.
same_cluster([A|Ar],[B|Br]):-
     same_vector(A,B),
     same_cluster(Ar,Br).


% media prepara il calcolo per trovare il centroide, chiamando la
% funzione summ_all e dopo aver ottenuto il risultato chiama l'effettiva
% funzione media(media0)
media(A,L,R):-
     sum_all(A,Summ),
     media0(Summ,L,R).


%calcola le cordinate per un centroide
media0([],_,[]):-!.
media0([A|Ar],L,[M|R]):-
     M is A/L,
     media0(Ar,L,R).



%sum_all applica la funzione vplus su tutti gli elementi del cluster
sum_all([A],A):-!.
sum_all([A|Ar],R):-
     sum_all(Ar,Vs),
     vplus(A,Vs,R).


%same_vector verifica se due vttori sono uguali
same_vector([],[]):-!.
same_vector([A|Ar],[A|Ar1]):-
     same_vector(Ar,Ar1).


% is_vector verifica se un vettore è, oltre che corretto nella
% struttura, composto da numeri
is_vector([]):-!.
is_vector([X | Vector]) :-
	number(X),
	is_vector(Vector).


% obs_more_than_k controlla che le osservazioni siano maggiori del
% numero di cluster che si desidera avere
obs_more_than_k([_],K):-
     K < 0.
obs_more_than_k([_|Ar],K):-
     K1 is K - 1,
     obs_more_than_k(Ar,K1).
