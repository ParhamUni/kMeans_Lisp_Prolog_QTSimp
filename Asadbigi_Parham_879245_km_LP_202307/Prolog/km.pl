%Asadbigi Parham 879245
%Bernasconi Giorgio Luigi Maria 885948
%Cambiago Silvia 879382



%kmeans viene eseguito solo la prima volta e permette di trovare i
%primi centroidi e le loro partizioni, per poi chiamare la vera
%funziona kmeans ricorsiva
kmeans(Obs,K,Cluster):-
     random_k_from_Obs(Obs,K,RandCs),
     partition(Obs,RandCs,NewCluster),
     kmeans_Figo(Obs,[],NewCluster,Cluster).



kmeans_Figo(_,Cluster,NewCluster,NewCluster):-
     same_clusters(Cluster,NewCluster).
kmeans_Figo(Obs,_,Cluster,RCluster):-
     prepare_centroid(Cluster,Cs),
     partition(Obs,Cs,NewCluster),
     kmeans_Figo(Obs,Cluster,NewCluster,RCluster).



centroid(List,Cs):-
     length(List,L),
     media(List,L,Cs).



vplus([],[],[]):-!.
vplus([A|Ar], [B|Br], [N|R]):-
     N is A+B,
     vplus(Ar,Br,R).

vminus([],[],[]):-!.
vminus([A|Ar], [B|Br], [N|R]):-
     N is A-B,
     vminus(Ar,Br,R).

innerprod([],[],0):-!.
innerprod([A|Ar],[B|Br],InnerProd):-
     innerprod(Ar,Br,R),
     InnerProd is R+(A*B).

norm(A,R):-
     innerprod(A,A,I),
     sqrt(I,R).



%new_vector/2


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



partition(Obs,Cs,Pa):-
     pair_With_The_Closest(Obs,Cs,Pair),
     make_partition(Pair,Cs,Pa).



make_partition([], _, []).
make_partition(A, [X|Xr], [List|R]) :-
    fill_list_and_remuve_frs(A, X, List, RestInput),
    make_partition(RestInput, Xr, R).



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




closest(_,[X],X):-!.
closest(E,[H|T],R):-
     distance(H,E,D),
     closest(E,T,R),
     distance(E,R,D1),
     D > D1,
     !.
closest(_,[H|_],H).



distance(A,B,Dist):-
     vminus(A,B,Sub),
     norm(Sub,Dist).



prepare_centroid([],[]):-!.
prepare_centroid([A|Ar],[Cs|R]):-
     centroid(A,Cs),
     prepare_centroid(Ar,R).



same_clusters([],[]):-!.
same_clusters([A|Ar],[B|Br]):-
     same_cluster(A,B),
     same_clusters(Ar,Br).



same_cluster([],[]):-!.
same_cluster([A|Ar],[B|Br]):-
     same_vector(A,B),
     same_cluster(Ar,Br).



media(A,L,R):-
     sum_all(A,Summ),
     media0(Summ,L,R).


media0([],_,[]):-!.
media0([A|Ar],L,[M|R]):-
     M is A/L,
     media0(Ar,L,R).



sum_all([A],A):-!.
sum_all([A|Ar],R):-
     sum_all(Ar,Vs),
     vplus(A,Vs,R).



same_vector([],[]):-!.
same_vector([A|Ar],[A|Ar1]):-
     same_vector(Ar,Ar1).

