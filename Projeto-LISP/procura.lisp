;;;; procura.lisp
;;;; Disciplina de IA - 2016 / 2017
;;;; 1� Projeto
;;;; Programador: Andr� Bastos - 140221017, Lu�s Mestre - 140221002

;;; Procura Generica
;; procura-generica
(defun procura-generica (objetivo no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores f-heuristica &optional (abertos (list no-inicial)) (fechados nil) (nos-gerados-aux 0) (tempo-inicial (get-universal-time)))
"Permite procurar a solucao de um problema usando a procura no espaco de estados. A partir de um estado inicial, de uma funcao que gera os sucessores e de um dado algoritmo. De acordo com o algoritmo pode ser usada um limite de profundidade, uma heuristica e um algoritmo de ordenacao"
	(cond
		((null abertos) nil)
		((funcall f-solucao (car abertos) objetivo)  (list (car abertos) (- (get-universal-time) tempo-inicial) nos-gerados-aux (list-length fechados) (cond ((and (> (second (car abertos)) 0) (> nos-gerados-aux 0)) (/ (second (car abertos)) nos-gerados-aux)) (t 0)))); se o primeiro dos abertos e solucao este no e devolvido com o tempo de exe
		((existep (first abertos) fechados f-algoritmo) (procura-generica objetivo no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores f-heuristica (cdr abertos) fechados nos-gerados-aux tempo-inicial))
		(T
			(let* ((lista-sucessores (funcall f-sucessores (first abertos) lista-operadores f-algoritmo prof-max f-heuristica objetivo))
                               (nos-gerados (+ nos-gerados-aux (list-length lista-sucessores)))
			       (solucao (existe-solucao lista-sucessores f-solucao objetivo f-algoritmo)))
		          (cond
		            (solucao (list solucao (- (get-universal-time) tempo-inicial) nos-gerados (1+ (list-length fechados)) (/ (second (car lista-sucessores)) nos-gerados))); devolve a solucao, com o tempo de execucao, nos-gerados, nos-expandidos e penetrancia
					(T (procura-generica objetivo no-inicial prof-max f-solucao f-sucessores f-algoritmo lista-operadores f-heuristica (funcall f-algoritmo (rest abertos) lista-sucessores) (cons (car abertos) fechados) nos-gerados tempo-inicial)); expande a arvore se o primeiro dos abertos nao for solucao
					)
                                        
			)
		)
                ;; fazer aqui a chamada de uma nova procura gen�rica que ser� especialmente s� para o RBFS, de forma a que nao haja os problemas de mem�ria
          
	)
)

;;; Algoritmos
;;bfs
(defun bfs (abertos sucessores)
"Algoritmo de procura em largura"
  (append abertos sucessores)
)

;; dfs
(defun dfs (abertos sucessores)
"Algoritmo de procura em profundidade"
  (append sucessores abertos)
)

;; a*
(defun a* (abertos sucessores)
"Algoritmo de procura em profundidade"
  (ordenar-nos (append sucessores abertos))
)

;; procura-rbfs
(defun procura-rbfs (no-inicial objetivo f-solucao f-heuristica f-sucessores lista-operadores &optional (g_alt 9999) (h_alt 9999) (nos-gerados-aux 0) (nos-expandidos-aux 0) (tempo-inicial (get-universal-time)))
"Permite procurar a solucao de um problema usando a procura no espaco de estados usando o algortimo RBFS. Este algoritmo era supsoto receber um f_limite mas fizemos de maneira a que este esteja dividido em duas vari�veis, para representar o G e H individualmente, j� que o nosso n� guarda estes individualmente tamb�m."
  (let (
        (sucs nil)
        (sucs-aux nil)
        (s nil)
        (f_alt_g g_alt)
        (f_alt_h h_alt)
        (nos-gerados 0)
        (nos-expandidos 0)
        (tempo tempo-inicial)
        )
    (cond
     ((funcall f-solucao no-inicial objetivo) (return-from procura-rbfs (list no-inicial (- (get-universal-time) tempo-inicial) nos-gerados-aux nos-expandidos-aux (cond ((> nos-gerados-aux 0) (/ (second no-inicial) nos-gerados-aux)) (t 0)) g_alt h_alt)))
     (t 
      (setf sucs (ordenar-nos (funcall f-sucessores no-inicial lista-operadores 'rbfs 9999 f-heuristica objetivo)))
      (setf sucs-aux (mapcar #'(lambda (no) (list no (get-profundidade no) (get-heuristica no))) sucs))
      (setf nos-gerados (+ (list-length sucs) nos-gerados-aux))
      (setf nos-expandidos (1+ nos-expandidos-aux))
      (cond 
       ((null sucs) (return-from procura-rbfs (list nil (- (get-universal-time) tempo-inicial) nos-gerados nos-expandidos-aux 0 9999 9999)))
       (t (loop
           ;(setf s (car sucs) )
           (setf s (car sucs-aux) )
           (cond ((> (fcusto s) (+ g_alt h_alt)) (return (list nil tempo-inicial nos-gerados nos-expandidos 0 (second s) (third s))))
                 (t 
                  ;(setf f_alt_g (get-profundidade (second sucs)))
                  ;(setf f_alt_h (get-heuristica (second sucs)))
                  (setf f_alt_g (second (second sucs-aux)))
                  (setf f_alt_h (third (second sucs-aux)))
                  (let
                    (	
                     (lista-aux 
                      (cond	((= (list-length sucs) 1)
                                 (procura-rbfs (car s) objetivo f-solucao f-heuristica f-sucessores lista-operadores g_alt h_alt nos-gerados nos-expandidos tempo-inicial))

                                ((< (+ g_alt h_alt) (+ f_alt_g f_alt_h)) 
                                 (procura-rbfs (car s) objetivo f-solucao f-heuristica f-sucessores lista-operadores g_alt h_alt nos-gerados nos-expandidos tempo-inicial))
                                (t 
                                 (procura-rbfs (car s) objetivo f-solucao f-heuristica f-sucessores lista-operadores f_alt_g f_alt_h nos-gerados nos-expandidos tempo-inicial))
                                )
                      )
                     )
                    (setf f_alt_g (sixth lista-aux))
                    (setf f_alt_h (seventh lista-aux))
                    (cond
                     ((not (null (car lista-aux))) (return lista-aux))
                     (t
                      ;(setf s (list (car s) f_alt_g f_alt_h (fourth s)))
                      ;(setf sucs (ordenar-nos (cons s (rest sucs))))
                      (setf s (list (car s) f_alt_g f_alt_h))
                      (setf sucs-aux (ordenar-nos-rbfs (cons s (rest sucs-aux))))
                      (setf nos-gerados (third lista-aux))
                      (setf nos-expandidos (fourth lista-aux))
                      (setf tempo (second lista-aux))
                      )
                     )
                    )
                  )
                 )
           ))
       )
      )
     )     
    )
)

