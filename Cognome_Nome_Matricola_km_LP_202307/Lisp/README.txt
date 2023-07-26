Componenti del gruppo:

-Cambiago Silvia 879382
-Asadbigi Parham 879245
-Bernasconi Giorgio Luigi Maria 885948

------------------------------------------------------------------------------------------------------------------------------------------

Parametri ricorrenti:

V_: vettore numerico
OBS, centroids: liste di vettori numerici aventi dimensioni tra loro consistenti (ovvero aventi lo stesso numero di elementi). OBS sono sempre le observations. centroids è sempre una lista di centroidi.
N, k: numeri interi non negativi. k è sempre il numero di centroidi
C: lista di cons-cells nelle quali il car è un vettore numerico ed il cdr un intero non negativo (che rappresenta il centroide associato al vettore)
clusters: lista di liste di vettori numerici con dimensioni consistenti

------------------------------------------------------------------------------------------------------------------------------------------

Uso delle funzioni

Queste sono le funzioni dell'interfaccia, ovvero quelle pensate per essere accessibili all'esterno e/o utilizzate dall'utente. Sono funzioni wrapper per i loro corrispettivi "privati".
Si occupano di controllare la validità dei parametri e restituiscono un messaggio di errore nel caso in cui questi siano invalidi.

- kmeans: prende in input due parametri OBS e k. Controlla che corrispondano ad una lista di vettori numerici tra loro consistenti (OBS) e ad un numero intero non negativo maggiore o uguale del numero di vettori presenti in OBS (k). 
Chiama poi la funzione interna _kmeans su questi due parametri, la quale chiama a sua volta l'iteratore dell'algoritmo
delle k-medie su una lista di centroidi inizializzati casualmente tra i vettori di OBS.

- centroid: prende in input un parametro OBS. Controlla che corrisponda ad una lista di vettori numerici tra loro consistenti.
Chiama poi la funzione interna _centroid su questo parametro, la quale calcola il vettore avente come coordinate le medie delle rispettive coordinate dei vettori in OBS.
Es. OBS = ((1 2 5) (7 9 0))
VM = (((1 + 7)/2) ((2 + 9)/2) ((5 + 0)/2)))

- vplus: prende in input due parametri V1 e V2. Controlla che siano entrambi vettori numerici e che abbiano le stesse dimensioni (la stessa lunghezza) e chiama _vplus su V1 e V2, la quale calcola la somma vettoriale di V1 e V2.
Es. V1 = (v1_1, v1_2, ..., v1_k)
V2 = (v2_1, v2_2, ..., v2_k)
output = (v1_1 + v2_1, v1_2 + v2_2, ..., v1_k + v2_k)

- vminus: prende in input due parametri V1 e V2. Controlla che siano entrambi vettori numerici e che abbiano le stesse dimensioni (la stessa lunghezza) e chiama _vminus su V1 e V2, la quale calcola la differenza vettoriale di V1 e V2.
Es. V1 = (v1_1, v1_2, ..., v1_k)
V2 = (v2_1, v2_2, ..., v2_k)
output = (v1_1 - v2_1, v1_2 - v2_2, ..., v1_k - v2_k)

- innerprod: prende in input due parametri V1 e V2. Controlla che siano entrambi vettori numerici e che abbiano le stesse dimensioni (la stessa lunghezza) e chiama _innerprod su V1 e V2, la quale calcola il prodotto interno fra i vettori, ossia la somma di tutte le coordinate del vettore risultante in seguito all'esecuzione del prodotto elemento per elemento tra V1 e V2.

- norm: prende in input un parametro V. Controlla che sia un vettore numerico e chiama _norm su V, che restituisce la norma del vettore, ovvero la radice quadrata del prodotto interno applicato tra V e se stesso, corrispondente alla lunghezza del vettore.

------------------------------------------------------------------------------------------------------------------------------------------

Funzioni ausiliarie

Queste funzioni non sono pensate per l'utilizzo esterno a questa libreria e non gestiscono eventuali parametri non validi. Si limitano a gestire la logica dell'algoritmo delle k-medie.

- _somma-interna: prende come parametro un vettore numerico V ed applica la funzione reduce sulla funzione somma e V. Così facendo esegue la somma di tutte le coordinate di V.
Es. V = (v_1, v_2, ..., v_k)
output = v_1 + v_2 + ... + v_k

- _prodotto-elem-per-elem: prende come parametri due vettori numerici V1 e V2 e restituisce un vettore avente come coordinate il prodotto tra ogni coordinata di V1 e la sua corrispettiva in V2.
Es. V1 = (v1_1, v1_2, ..., v1_k)
V2 = (v2_1, v2_2, ..., v2_k)
output = (v1_1 * v2_1, v1_2 * v2_2, ..., v1_k * v2_k)

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
























