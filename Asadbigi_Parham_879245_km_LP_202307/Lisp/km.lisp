;;;; Asadbigi Parham 879245
;;;; Cambiago Silvia 879382
;;;; Bernasconi Giorgio Luigi Maria 885948

;;;;---------------------------------------------------------------------------
;;;; Funzioni dell'Interfaccia pensate per l'uso esterno
;;;;---------------------------------------------------------------------------


;;;; Controlla la validita' dei parametri passati alla funzione
;;;; e chiama _kmeans
(defun kmeans (OBS k)
	(cond ((not (= (length OBS) (length (_filter #'_is-vector OBS))))
			(error "OBS deve essere composto solo da vettori numerici"))
		((not (_dimensioni-consistenti OBS (length (first OBS))))
			(error "i vettori di OBS non hanno dimensione consistente"))
		((not (integerp k))
			(error "k deve essere un numero intero"))
		((minusp k)
			(error "k deve essere un numero positivo"))
		((< (length OBS) k)
			(error "k non deve essere maggiore del numero di vettori in OBS"))
		(T (_kmeans OBS k))
	)
)


;;;; Controlla la validita' dei parametri passati alla funzione e
;;;; chiama _centroid
(defun centroid (OBS)
	(cond ((null OBS) NIL)
		((not (= (length OBS) (length (_filter #'_is-vector OBS))))
			(error "OBS deve essere composto solo da vettori numerici"))
		((not (_dimensioni-consistenti OBS (length (first OBS))))
			(error "i vettori di OBS non hanno dimensione consistente"))
		(T (_centroid OBS))
	)
)


;;;; Controlla la validita' dei parametri passati alla funzione e chiama _vplus
(defun vplus (V1 V2)
	(cond ((not (_is-vector V1))
			(error "V1 non e' un vettore numerico"))
		((not (_is-vector V2))
			(error "V2 non e' un vettore numerico"))
		((not (= (length V1) (length V2)))
			(error "V1 e V2 non hanno lo stesso numero di dimensioni"))
		(T (_vplus V1 V2))
	)
)


;;;; Controlla la validita' dei parametri passati alla funzione
;;;; e chiama _vminus
(defun vminus (V1 V2)
	(cond ((not (_is-vector V1))
			(error "V1 non e' un vettore numerico"))
		((not (_is-vector V2))
			(error "V2 non e' un vettore numerico"))
		((not (= (length V1) (length V2)))
			(error "V1 e V2 non hanno lo stesso numero di dimensioni"))
		(T (_vminus V1 V2))
	)
)


;;;; Controlla la validita' dei parametri passati alla funzione e chiama
;;;; _innerprod
(defun innerprod (V1 V2)
	(cond ((not (_is-vector V1))
			(error "V1 non e' un vettore numerico"))
		((not (_is-vector V2))
			(error "V2 non e' un vettore numerico"))
		((not (= (length V1) (length V2)))
			(error "V1 e V2 non hanno lo stesso numero di dimensioni"))
		(T (_innerprod V1 V2))
	)
)


;;;; Controlla la validita' dei parametri passati alla funzione e chiama _norm
(defun norm (V)
	(cond ((not (_is-vector V)) (error "V non e' un vettore numerico"))
		(T (_norm V))
	)
)


;;;;---------------------------------------------------------------------------
;;;; Funzioni ausiliarie pensate per l'uso interno
;;;;---------------------------------------------------------------------------

;;;; Esegue la somma di tutte le coordinate del vettore V
(defun _somma-interna (V)
	(reduce #'+ V)
)


;;;; Esegue il prodotto tra ogni elemento del vettore V1 e il suo
;;;; corrispettivo nel vettore V2
(defun _prodotto-elem-per-elem (V1 V2)
	(if (null V1)
		NIL
		(cons (* (first V1) (first V2))
			  (_prodotto-elem-per-elem (rest V1) (rest V2))
		)
	)
)


;;;; Esegue il prodotto interno di due vettori, ovvero la somma interna del
;;;; prodotto elemento per elemento
(defun _innerprod (V1 V2)
	(_somma-interna (_prodotto-elem-per-elem V1 V2))
)

;;;; Ricava la norma di un vettore facendo la radice del prodotto interno tra
;;;; un vettore e se stesso
(defun _norm (V)
	(sqrt (_innerprod V V))
)


;;;; Esegue la differenza vettoriale tra V1 e V2
(defun _vminus (V1 V2)
	(if (null V1)
		NIL
		(cons (- (first V1) (first V2))
			  (_vminus (rest V1) (rest V2))
		)
	)
)


;;;; Esegue la somma vettoriale tra V1 e V2
(defun _vplus (V1 V2)
	(if (null V1)
		NIL
		(cons (+ (first V1) (first V2))
			  (_vplus (rest V1) (rest V2))
		)
	)
)


;;;; Ricava la distanza tra due vettori ricavando la norma del
;;;; vettore differenza tra V1 e V2
(defun _distanza (V1 V2)
	(_norm (_vminus V1 V2))
)


;;;; Ricava la media dei valori interni di un vettore V dividendone la
;;;; somma interna per il numero di dimensioni (o lunghezza)
(defun _media (V)
	(/ (_somma-interna V) (length V))
)


;;;; Ricava il centroide di un gruppo di vettori OBS componendo in un vettore
;;;; equidimensionale la media di ogni posizione per ogni elemento di OBS
(defun _centroid (OBS) 
	(cond ((null OBS) NIL)
		((null (first OBS)) NIL)
		(T (cons (_media (mapcar #'first OBS))
				 (_centroid (mapcar #'rest OBS))
			)
		)
	)
)


;;;; Ricava il valore minimo tra le coordinate del vettore V
(defun _minimo (V)
	(cond ((null V) 0)
		((= 1 (length V)) (first V))
		((<= (first V) (_minimo (rest V))) (first V))
		((> (first V) (_minimo (rest V))) (_minimo (rest V)))
	)
)


;;;; Ricava le distanze tra il vettore V e tutti i vettori in centroids
;;;; componendoli in una lista
(defun _distances (V centroids)
	(cond ((null centroids) NIL)
		(T (cons (_distanza V (first centroids))
			  (_distances V (rest centroids))
			)
		)
	)
)


;;;; Ricava, dati un vettore ed i centroidi (una lista di vettori), l'indice
;;;; del centroide la cui distanza con V e' minima
(defun _nclust (V centroids &optional (acc 0))
	(cond ((null centroids) 0)
		((= (_distanza V (first centroids))
			(_minimo (_distances V centroids))
		 )
		 acc
		)
		(T (_nclust V (rest centroids) (+ acc 1)))
	)
)


;;;; Associa ad ogni vettore in OBS l'indice del centroide nella lista
;;;; centroids con una cons
(defun _cluster1 (OBS centroids)
	(cond ((null OBS) NIL)
		(T (cons (cons (first OBS) (_nclust (first OBS) centroids))
				(_cluster1 (rest OBS) centroids)
			)
		)
	)
)


;;;; Ricava la lista di tutti gli elementi della lista L che soddisfano
;;;; il predicato pred
(defun _filter (pred L)
	(cond ((null L) nil)
		((funcall pred (first L))(cons (first L) (_filter pred (rest L))))
		(T (_filter pred (rest L)))
	)
)


;;;; Ricava la lista ottenuta eliminando l'elemento nella posizione n
(defun _elimina (L n &optional (acc 0))
	(cond ((null L) NIL)
		((= acc n) (_elimina (rest L) n (+ acc 1)))
		(T (cons (first L)
				(_elimina (rest L) n (+ acc 1))
			)
		)
	)
)


;;;; Ricava, dati C -> *lista di vettori con associato indice di un centroide*
;;;; e n -> *indice di un centroide*, una lista avente come elementi i vettori
;;;; associati al centroide di indice n
(defun _grab-group (C n)
	(mapcar #'first
		(_filter (lambda (x) (= (rest x) n)) C)
	)
)


;;;; Trasforma C -> *lista di vettori con associato indice di un centroide*,
;;;; in una lista di liste, dove ognuna di queste contiene tutti i
;;;; vettori associati ad un determinato centroide
(defun _cluster2 (C k &optional (acc 0))
	(cond ((null C) NIL)
		((= acc k) NIL)
		(T (cons (_grab-group C acc)
				(_cluster2 (_filter (lambda (x) (not (= (rest x) acc))) C)
							k
							(+ acc 1)
				)
			)
		)
	)
)


;;;; Ricava un numero k di vettori distinti dall'insieme di vettori OBS
(defun _random-points (OBS k &optional (acc 0))
	(cond ((= acc k) NIL)
		(T (let ((r (random (length OBS))))
				(cons (nth r OBS)
					  (_random-points (_elimina OBS r) k (+ acc 1))
				)
			)
		)
	)
)


;;;; Ricava una lista di centroidi calcolando i centroidi delle liste di
;;;; clusters -> *lista di liste di vettori* chiamando la funzione
;;;; _centroid, che prende come parametro una lista di vettori 
(defun _new-centroids (clusters)
	(if (null clusters)
		NIL
		(cons (_centroid (first clusters))
			  (_new-centroids (rest clusters))
		)
	)
)


;;;; Ricava una lista di liste di vettori raggruppati mediante i centroidi
;;;; ricavati dalla funzione _new-centroids
(defun _cluster-ricalcolati (OBS clusters k)
	(_cluster2 (_cluster1 OBS (_new-centroids clusters)) k)
)


;;;; Iteratore dell'algoritmo kmeans che controlla se i cluster ricalcolati
;;;; sono uguali a quelli precedenti e, se si, li restituisce, altrimenti
;;;; esegue un altro passo iterativo
(defun _kmeans-iterator (OBS clusters k)
	(let ((clust (_cluster-ricalcolati OBS clusters k)))
		(if (equal clusters clust)
			clusters
			(_kmeans-iterator OBS clust k)
		)
	)
)


;;;; Esegue la funzione _kmeans-iterator su una lista di centroidi presi
;;;; casualmente dalla lista di vettori OBS
(defun _kmeans (OBS k)
	(_kmeans-iterator OBS
					(_cluster2 (_cluster1 OBS (_random-points OBS k)) k)
					k
	)
)


;;;; Controlla se tutti gli elementi di OBS siano vettori di dimensione n
(defun _dimensioni-consistenti (OBS n)
	(cond ((null OBS) T)
		(T (and (= n (length (first OBS)))
				(_dimensioni-consistenti (rest OBS) n)
			)
		)
	)
)


;;;; Controlla se L e' un vettore numerico
(defun _is-vector (L)
	(cond ((null L) T)
		(T (and (= 1 (_profondita L))
				(numberp (first L))
				(_is-vector (rest L))
			)
		)
	)
)


;;;; Ricava la profondita' di una lista
(defun _profondita (L)
	(cond ((null L) 1)
		((atom L) 0)
		(T (max (+ 1 (_profondita (first L)))
				(_profondita (rest L))
			)
		)
	)
)