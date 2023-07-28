Componenti del gruppo:

-Cambiago Silvia 879382
-Asadbigi Parham 879245
-Bernasconi Giorgio Luigi Maria 885948

------------------------------------------------------------------------------------------------------------------------------------------

Parametri ricorrenti:

V_: vettore numerico
OBS, centroids: liste di vettori numerici aventi dimensioni consistenti tra loro
K: rappresenta il numero di centroidi (cluster) desiderato
clusters: lista di liste di vettori numerici rappresentanti i cluster ottenuti

------------------------------------------------------------------------------------------------------------------------------------------

Uso delle funzioni

Queste sono le funzioni dell'interfaccia, ovvero quelle pensate per essere accessibili all'esterno e/o utilizzate dall'utente. 
È fondamentale che gli input forniti all'algoritmo siano corretti e rispettino i vincoli di dimensionalità dei vettori e dei centroidi, altrimenti la query darà risposta "false". Assicurarsi che gli input siano formattati in modo corretto per evitare errori nell'esecuzione dell'algoritmo.

- kmeans(Obs, K, Cluster): prende in input tre parametri Obs, K e Cluster. Controlla che corrispondano ad una lista di vettori numerici tra loro consistenti (Obs) e ad un numero intero non negativo maggiore o uguale del numero di vettori presenti in Obs (K), fallendo in caso contrario. Restituisce la lista Cluster che contiene i K cluster ottenuti applicando l'algoritmo delle k-medie, quindi raggruppando gli elementi di Obs in K cluster. Genera inoltre i primi K centroidi, presi in modo casuale tra le osservazioni. Nello specifico kmeans/3 è solo la funzione che avvia l'algoritmo.

- centroid(List, Cs): prende in input una lista List, che rappresenta un cluster, quindi una lista di vettori numerici, e restituisce il vettore del centroide Cs, ottenuto calcolando la media delle coordinate dei vettori nel cluster. Questa funzione calcola solo un centroide alla volta, pertanto, quando vengono ricalcolati i centroidi, viene chiamata la funzione prepare_centroid che chiama centroid K volte. //correggere

- vplus(V1, V2, V): prende in input tre parametri V1, V2 e V. Controlla che i primi due siano vettori numerici aventi le stesse dimensioni (la stessa lunghezza), ne esegue la somma vettoriale e la restituisce nel terzo vettore V.

- vminus(V1, V2, V): prende in input tre parametri V1, V2 e V. Controlla che i primi due siano vettori numerici aventi le stesse dimensioni (la stessa lunghezza), ne esegue la differenza vettoriale e la restituisce nel terzo vettore V.

- innerprod(V1, V2, InnerProd):  prende in input tre parametri V1, V2 e InnerProd. Controlla che i primi due siano vettori numerici aventi le stesse dimensioni (la stessa lunghezza), ne esegue il prodotto interno e lo restituisce nel terzo parametro InnerProd (scalare).

- norm(V, R): prende in input due parametri V ed R. Chiama innerprod per calcolare il prodotto interno tra V e se stesso e, ottenuto il risultato, esegue la radice quadrata dello stesso, che verrà restituita nel parametro R.

- new_vector(Name, Vector): prende in input due parametri Name e Vector. Controlla che Name sia un atomo e che Vector corrisponda ad un vettore numerico e, in caso di successo, associa Vector al nome Name e lo inserisce nella lista di vettori disponibili.

------------------------------------------------------------------------------------------------------------------------------------------

Funzioni ausiliarie

Queste funzioni non sono pensate per l'utilizzo esterno a questa libreria e non gestiscono eventuali parametri non validi. Si limitano a fornire logica addizionale necessaria per l'esecuzione dell'algoritmo delle k-medie.

- kmeans_recursive(Obs, Cluster, NewCluster, RCluster): prende in input quattro parametri Obs, Cluster, NewCluster e RCluster. È una funzione ricorsiva composta da un caso base che prevede che Cluster e NewCluster siano uguali (il controllo è effettuato attraverso la chiamata della funzione same_clusters_), ed un caso passo che porta a ricalcolare i centroidi in base all'attuale Cluster, riassegnare le osservazioni ai centroidi più vicini, aggiornare NewCluster di conseguenza e chiamare nuovamente kmeans_recursive con NewCluster aggiornato.

- random_k_from_Obs(Obs, K, RandCs): prende in input tre parametri Obs, K e RandCs. Seleziona casualmente K vettori dalla lista di osservazioni Obs, restituendo una lista di centroidi iniziali in RandCs.

- _distanza: prende come parametri due vettori numerici V1 e V2, ottiene il vettore differenza e ne restituisce la norma (quindi la sua lunghezza).

- _media: prende come parametro un vettore V e restituisce la media delle coordinate di V.
Es. V = (v_1, v_2, ..., v_k)
output = ((v_1 + v_2 + ... + v_k) / k)

- _minimo: prende come parametro un vettore V e restituisce il valore minimo fra le sue coordinate.
Es. V = (3 5 6 9)
output = 3

- _distances: prende come parametri un vettore V e una lista di vettori centroids e restituisce una lista avente come elementi le distanze tra V ed ogni elemento di centroids.

- _nclust: prende come parametri un vettore V, una lista di vettori centroids e un intero non negativo acc (opzionale), che non viene passato alla chiamata esterna alla funzione ma è usato solo nelle chiamate ricorsive interne alla funzione stessa. Restituisce l'indice del vettore di centroids avente minima distanza con V.

- _cluster1: prende come parametri due liste di vettori OBS e centroids e costruisce una lista di cons-cells associando ad ogni elemento di OBS l'indice del vettore di centroids dal quale ha distanza minima.

- _filter: prende come parametri un predicato pred ed una lista L. Ritorna la lista di tutti gli elementi di L che soddisfano pred. 

- _elimina: prende come parametri una lista L, un numero intero non negativo n ed un intero non negativo acc (opzionale), che non viene passato alla chiamata esterna alla funzione ma è usato solo nelle chiamate ricorsive interne alla funzione stessa. Elimina da L l'elemento di indice n.

- _grab-group: prende come parametri una lista C ed un numero intero non negativo n, indice di un centroide. C è una lista di cons-cells nelle quali il car è un vettore numerico ed il cdr un intero non negativo. Restituisce una lista di cons-cells appartenenti a C ed aventi cdr uguale a n.

- _cluster2: prende come parametri una lista C ed un numero intero non negativo k. C è una lista di di cons-cells nelle quali il car è un vettore numerico ed il cdr un intero non negativo. Prende inoltre un intero non negativo acc (opzionale), che non viene passato alla chiamata esterna alla funzione ma è usato solo nelle chiamate ricorsive interne alla funzione stessa. Ritorna una diversa formattazione delle informazioni contenute in C: invece che avere ogni vettore associato all'indice del suo centroide viene creata e restituita una lista dove ogni elemento è una lista di vettori aventi lo stesso indice di centroide.
Es. C = ((1 2).0 (2 3).0 (3 4).1 (4 5).1 (5 6).2) 
output = (((1 2) (2 3)) ((3 4) (4 5)) ((5 6)))

- _random-points: prende come parametri una lista di vettori numerici OBS, un intero non negativo k ed un intero non negativo acc (opzionale), che non viene passato alla chiamata esterna alla funzione ma è usato solo nelle chiamate ricorsive interne alla funzione stessa. Restituisce una lista contenente k vettori scelti casualmente da OBS, assicurandosi di non scegliere lo stesso vettore due volte.

- _new-centroids: prende come parametro una lista di liste di vettori numerici con dimensioni consistenti clusters e restituisce una lista di vettori, i quali sono i nuovi centroidi derivati da ogni lista contenuta in clusters attraverso l'applicazione della funzione _centroid su ogni elemento di clusters.

- _cluster-ricalcolati: prende come parametri una lista di vettori numerici OBS, una lista di liste di vettori numerici con dimensioni consistenti clusters ed un intero non negativo k. Restituisce una lista di liste di vettori raggruppati mediante i nuovi centroidi ottenuti mediante la funzione _new-centroids applicata a clusters. Questo, nell'algoritmo delle k-medie, è la parte che esegue il passo per il controllo ricorsivo che verrà eseguito nella funzione _kmeans-iterator.

- _kmeans-iterator: prende come parametri una lista di vettori numerici OBS, una lista di liste di vettori numerici con dimensioni consistenti clusters ed un intero non negativo k. Controlla che clusters sia uguale al ritorno della funzione _cluster-ricalcolati applicata a clusters e, se l'uguaglianza è soddisfatta, ritorna clusters, altrimenti esegue un ulteriore passo ricorsivo.
Questo è l'effettivo algoritmo delle k-medie dove, ogni volta che si ricalcolano i clusters, si controlla se sono uguali a quelli calcolati in precedenza. Quando ciò succede, si è raggiunta la configurazione di cluster più efficiente dati i centroidi iniziali.

- _dimensioni-consistenti: prende come parametri una lista di vettori numerici OBS ed un intero non negativo n. È un predicato che controlla che tutti gli elementi di OBS siano n-dimesionali.

- _is-vector: prende come parametro una lista L e si assicura che sia un vettore numerico controllando che L abbia profondità 1, che il suo primo elemento sia un numero e che il resto soddisfi a sua volta il predicato.

- _profondita: prende come parametro una lista L e restituisce la sua profondità.
























