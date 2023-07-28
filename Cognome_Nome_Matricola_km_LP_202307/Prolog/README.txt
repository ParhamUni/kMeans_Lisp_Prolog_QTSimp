Componenti del gruppo:

-Cambiago Silvia 879382
-Asadbigi Parham 879245
-Bernasconi Giorgio Luigi Maria 885948

------------------------------------------------------------------------------------------------------------------------------------------

Parametri ricorrenti:

V_: vettore numerico
Obs: lista di vettori numerici aventi dimensioni consistenti tra loro che rappresentano le observations
K: rappresenta il numero di centroidi

------------------------------------------------------------------------------------------------------------------------------------------

Uso delle funzioni

Queste sono le funzioni dell'interfaccia, ovvero quelle pensate per essere accessibili all'esterno e/o utilizzate dall'utente. 
È fondamentale che gli input forniti all'algoritmo siano corretti e rispettino i vincoli di dimensionalità dei vettori e dei centroidi,
altrimenti la query darà risposta "false". Assicurarsi che gli input siano formattati in modo corretto per evitare errori nell'esecuzione 
dell'algoritmo.

- kmeans(Obs, K, Cluster): prende in input tre parametri Obs, K e Cluster. Controlla che corrispondano ad una lista di vettori numerici 
tra loro consistenti (Obs) e ad un numero intero non negativo maggiore o uguale del numero di vettori presenti in Obs (K), fallendo in 
caso contrario. Restituisce la lista Cluster che contiene i K cluster ottenuti applicando l'algoritmo delle k-medie, quindi raggruppando 
gli elementi di Obs in K cluster. Genera inoltre i primi K centroidi, presi in modo casuale tra le osservazioni. Nello specifico, è solo 
la funzione che avvia l'algoritmo.

- centroid(List, Cs): prende in input due parametri List e Cs. List è una lista che rappresenta un cluster, quindi una lista di vettori 
numerici. Cs è un centroide. Restituisce il vettore del centroide Cs, ottenuto calcolando la media delle coordinate dei vettori nel 
cluster. Questa funzione calcola solo un centroide alla volta, pertanto, quando vengono ricalcolati i centroidi, viene chiamata la 
funzione prepare_centroid_ che chiama centroid K volte. 

- vplus(V1, V2, V): prende in input tre parametri V1, V2 e V. Controlla che i primi due siano vettori numerici aventi le stesse dimensioni
(la stessa lunghezza), ne esegue la somma vettoriale e la restituisce nel terzo vettore V.

- vminus(V1, V2, V): prende in input tre parametri V1, V2 e V. Controlla che i primi due siano vettori numerici aventi le stesse
dimensioni (la stessa lunghezza), ne esegue la differenza vettoriale e la restituisce nel terzo vettore V.

- innerprod(V1, V2, InnerProd):  prende in input tre parametri V1, V2 e InnerProd. Controlla che i primi due siano vettori numerici aventi 
le stesse dimensioni (la stessa lunghezza), ne esegue il prodotto interno e lo restituisce nel terzo parametro InnerProd (scalare).

- norm(V, R): prende in input due parametri V ed R. Chiama innerprod per calcolare il prodotto interno tra V e se stesso e, ottenuto il 
risultato, esegue la radice quadrata dello stesso, che verrà restituita nel parametro R.

- new_vector(Name, Vector): prende in input due parametri Name e Vector. Controlla che Name sia un atomo e che Vector corrisponda ad un 
vettore numerico e, in caso di successo, associa Vector al nome Name e lo inserisce nella lista di vettori disponibili. Per utilizzare dei 
vettori aggiunti alla base di conoscenza mediante new_vector è necessario chiamare la funzione Vector/2, che serve 
a memorizzare e accedere ad informazioni relative a vettori all'interno del programma. 
Es. new_vector('Vector1', [1,2,3]).
new_vector('Vector2', [4,5,6]).
vector('Vector1', V1), vector('Vector2', V2), vplus(V1, V2, V).
output:
V1 = [1,2,3],
V2 = [4,5,6],
V = [5,7,9].

------------------------------------------------------------------------------------------------------------------------------------------

Funzioni ausiliarie

Queste funzioni non sono pensate per l'utilizzo esterno a questa libreria e non gestiscono eventuali parametri non validi. Si limitano a 
fornire logica addizionale necessaria per l'esecuzione dell'algoritmo delle k-medie.

- kmeans_recursive_(Obs, Cluster, NewCluster, RCluster): prende in input quattro parametri Obs, Cluster, NewCluster e RCluster. Obs è la 
lista di osservazioni, Cluster è  il cluster attuale, ovvero una lista di osservazioni che sono state assegnate a un centroide specifico, 
NewCluster è il nuovo cluster, ovvero una lista di osservazioni risultanti dall'assegnazione delle osservazioni ai centroidi più vicini e 
RClust è il cluster risultante, ovvero il cluster finale che conterrà le osservazioni assegnate ai centroidi dopo la convergenza 
dell'algoritmo k-means. Controlla se Cluster e NewCluster sono uguali (il controllo è effettuato attraverso la chiamata della funzione
same_clusters_). Se sì, la ricorsione termina e vengono restituiti i cluster attuali attraverso il parametro RCluster. Altrimenti, vengono 
ricalcolati i centroidi in base all'attuale Cluster, si riassegnano le osservazioni ai centroidi più vicini, NewCluster viene aggiornato 
di conseguenza e si chiama  kmeans_recursive con NewCluster aggiornato.

- random_k_from_Obs_(Obs, K, RandCs): prende in input tre parametri Obs, K e RandCs. Obs è la lista di osservazioni, K un intero non 
negativo e RandCs è la lista dei centroidi selezionati casualmente da Obs. 
Seleziona casualmente K vettori da Obs e calcola i centroidi iniziali restituendoli in RandCs. Si assicura inoltre di non scegliere più 
volte lo stesso vettore rimuovendo, ad ogni passo, il vettore estratto da Obs.

- partition_(Obs,Cs,Pa): prende in input tre parametri Obs, Cs e Pa. Obs è la lista di osservazioni e Cs è la lista di centroidi. 
Partiziona Obs assegnando le osservazioni ai centroidi più vicini presenti in Cs, creando così i cluster iniziali, chiamando le funzioni 
pair_With_The_Closest_ e make_partition_. Restituisce poi i cluster formati attraverso Pa, dove ogni cluster sarà una lista di 
osservazioni assegnate ad un determinato centroide.

- make_partition_(Pair,Cs,Pa): prende in input tre parametri Pair, Cs e Pa. Pair è una lista di coppie [Centroide|Osservazione], Cs è la 
lista di centroidi. Ogni coppia indica l'associazione di un'osservazione al centroide più vicino. Viene chiamata fill_list_and_remove_frs_ 
per riempire il cluster Pa associato al centroide di Cs corrente X con le osservazioni ad esso assegnate, e rimuove la coppia corrente
dalla lista delle coppie. Alla fine di ogni passo ricorsivo, il cluster Pa conterrà le osservazioni assegnate al centroide di Cs corrente, 
e la lista delle coppie rimanenti. Questo cluster sarà inserito nella lista dei cluster e diventerà parte del risultato finale.

- fill_list_and_remove_frs_(A, Centroid, Cluster, RestInput): prednde in input quattro parametri A, Centroid, Cluster e RestInput. A è una
lista di coppie [Centroide|Osservazione]. Queste coppie rappresentano l'associazione tra un centroide e un'osservazione assegnata a quel 
centroide. Centroid è il centroide corrente con cui si stanno confrontando le coppie nella lista A, ovvero quello per il quale si sta 
formando il cluster. Cluster è il cluster associato al centroide corrente. È una lista che viene costruita man mano riempiendo le 
osservazioni assegnate a Centroid. RestInput è la lista delle coppie rimanenti dopo aver eseguito il processo di riempimento del cluster. 
Sarà il risultato di fill_list_and_remove_frs_ e conterrà le coppie che non sono state utilizzate per formare il cluster associato a 
Centroid. Riempie il cluster associato a un centroide prendendo solo l'elemento dell'osservazione e restituisce la lista di coppie senza 
gli elementi che hanno già l'associazione con il centroide analizzato.

- pair_With_The_Closest_(Obs,Cs,Pair): prende in input tre parametri Obs, Cs e Pair. Obs è la lista di osservazioni, Cs è la lista di
centroidi e Pair è una lista di coppie [Centroide|Osservazione]. Queste coppie rappresentano l'associazione tra un centroide e 
un'osservazione assegnata a quel centroide. Associa ciascuna osservazione di Obs al centroide più vicino di Cs, quindi calcola il 
centroide più vicino per ciascuna osservazione di Obs. Restituisce poi la lista Pair.

- closest_(E,Cs,C): prende in input tre parametri E, Cs e C. E è un vettore numerico che rappresenta un'osservazione, Cs è la lista di 
centroidi e C è il centroide più vicino ad E. Esamina il primo elemento di Cs e chiama distance per calcolare la distanza tra E ed il 
centroide corrente. Il predicato chiama se stesso ricorsivamente e il centroide più vicino trovato finora viene memorizzato nella 
variabile R. Restituisce C come risultato finale, che è il centroide più vicino all'osservazione E. Questo valore viene ottenuto dalla 
variabile R dopo aver completato tutte le chiamate ricorsive.

- distance_(A,B,Dist): prende in input tre parametri A, B e Dist. A e B sono vettori numerici. Dist è la distanza euclidea tra A e B. 
Viene chiamata la funzione vminus per calcolare la differenza vettoriale tra A e B, ed in seguito viene chiamata norm, passando in input
alla stessa il vettore differenza. Il risultato finale è memorizzato nel parametro Dist, che viene unificato con il valore ottenuto da
norm. Dist verrà infine restituito.

- prepare_centroid_(Cluster,NewCs): prende in input due parametri Cluster e NewCs. Cluster è una lista di cluster e NewCs è la lista dei 
nuovi centroidi calcolati a partire dai cluster. Calcola i nuovi centroidi a partire dai cluster forniti in Cluster. Utilizza la funzione 
centroid per calcolare il centroide di ciascun cluster e crea una lista contenente i nuovi centroidi calcolati, la quale viene restituita
come risultato nel parametro NewCs.

- media_(Cluster,L,Centroid): prende in input tre parametri Cluster, L e Centroid. Cluster è un singolo cluster, L è la lunghezza del 
cluster, ovvero il numero di osservazioni presenti in esso, e Centroid è il centroide calcolato per il cluster. Viene chiamata la funzione 
sum_all_ per calcolare la somma dei vettori delle osservazioni presenti in Cluster. Viene poi chiamata la funzione media0_ per calcolare
le coordinate del centroide. Il risultato finale, cioè le coordinate di Centroid, viene unificato con il parametro Centroid e restituito.

- media0_(Summ,L,Centroid): prende in input tre parametri Summ, L e Centroid. Summ è la somma dei vettori delle osservazioni nel cluster, 
L è la lunghezza del cluster, ovvero il numero di osservazioni presenti in esso, e Centroid è il centroide calcolato per il cluster.
Ad ogni passo ricorsivo, viene preso il primo elemento di Summ e diviso per L per ottenere il valore medio della coordinata corrispondente 
del centroide. Tale coordinata viene aggiunta alla lista del centroide. Il predicato continua a chiamarsi ricorsivamente finché ci sono 
coordinate rimanenti in Summ. Al termine della ricorsione, Centroid conterrà il vettore delle coordinate del centroide.

- sum_all_(Cluster,Summ): prende in input due parametri Cluster e Summ. Cluster è un singolo cluster e Summ la somma dei vettori delle 
osservazioni presenti in Cluster. Viene applicata la funzione vplus a tutti gli elementi del cluster, ottenendo la somma delle coordinate 
di tutti i vettori.

- same_vector_(A,B): prende in input due parametri A e B, entrambi vettori numerici. Verifica l'uguaglianza tra A e B, controllando le 
coordinate ricorsivamente elemento per elemento.

- same_cluster_(Cluster,OtherCluster): prende in input due parametri, Cluster ed OtherCluster, entrambi cluster, quindi liste di 
osservazioni. Verifica se due cluster sono uguali, richiamando la funzione same_vector_ per verificare l'uguaglianza dei vettori nei 
due cluster.

- same_clusters_(Cluster,NewCluster): prende in input due parametri Cluster e NewCluster, entrambi liste di cluster, quindi liste di liste 
di osservazioni. Chiama ricorsivamente la funzione same_cluster, che controlla se due singoli cluster sono uguali, per ogni elemento di 
Cluster e NewCluster.

- is_vector(Vector): prende in input un parametro Vector, corrispondente ad una lista di elementi. Controlla se è un vettore numerico,
verificando ricorsivamente, per ogni elemento di Vector, che esso sia un numero.

- obs_more_than_k(Obs,K): prende in input due parametri Obs e K. Obs è la lista di osservazioni e K un intero non negativo. 
Controlla che il numero di osservazioni in Obs sia maggiore del numero di cluster K.
























