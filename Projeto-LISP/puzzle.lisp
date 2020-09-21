;;;; puzzle.lisp
;;;; Disciplina de IA - 2016 / 2017
;;;; 1� Projeto
;;;; Programador: Andr� Bastos - 140221017, Lu�s Mestre - 140221002

;;; Operadores
;; operadores
(defun operadores ()
"Devolve uma lista com os operadores do nosso puzzle"
  (list 'arco-horizontal 'arco-vertical)
)

;;; Construtor
;; cria-no
(defun cria-no (tabuleiro &optional (g 0) (heuristica 9999) (pai nil))
"Devolve uma lista com as caracteristicas do no que recebe"
  (list tabuleiro g heuristica pai)
)

;;; Criacao do tabuleiro
;; tabuleiro-vazio
(defun tabuleiro-vazio (n m)
"Cria um tabuleiro com as dimensoes que recebe nos parametros"
  (list (horizontal-vazio n m) (vertical-vazio n m))
)

;; vertical-vazio
(defun vertical-vazio (n m)
"Cria um conjunto de linhas verticais vazias de acordo com os parametros introduzidos"
  (cond
    ((eq m 0) (list (linha-vazia n)))
    (t (cons (linha-vazia n) (horizontal-vazio (1- m) n)))
  )
)

;; horizontal-vazio
(defun horizontal-vazio (n m)
"Cria um conjunto de linhas horizontais vazias de acordo com os parametros introduzidos"
  (cond
    ((eq n 0) (list (linha-vazia m)))
    (t (cons (linha-vazia m) (horizontal-vazio (1- n) m)))
  )
)

;; linha-vazia
(defun linha-vazia (n)
"Cria uma linha vazia com a dimensao recebida"
  (cond
    ((eq n 0) nil)
    (t (cons nil (linha-vazia (1- n))))
  )
)

;;; Heuristica
;; heuristica
(defun heuristica (tabuleiro obj)
"Retorna a avaliacao do tabuleiro, de acordo com a heuristica definida no enunciado do projeto. A funcao recebe um tabuleiro e um valor inteiro que representa o objetivo: o numero de caixas a fechar"
  (cond
    ((null tabuleiro) nil)
    ((eq obj 0) 0)
    (t (1- (- obj (numero-caixas-fechadas tabuleiro))))
  )
)

;; heuristica-nova
(defun heuristica-nova (tabuleiro obj)
"Retorna a avaliacao do tabuleiro, de acordo com uma heuristica definida pelos programadores por sugestao do enunciado. A funcao recebe um tabuleiro e um valor inteiro que representa o objetivo: o numero de caixas a fechar"
  (cond
    ((null tabuleiro) nil)
    ((eq obj 0) 0)
    (t (let ((h (- obj (numero-caixas-fechadas tabuleiro) (numero-caixas-quase-fechadas tabuleiro)))) (cond ((< h 0) (abs h)) (t h))))
  )
)

;; heuristica-nova2
(defun heuristica-nova2 (tabuleiro obj)
"Retorna a avaliacao do tabuleiro, de acordo com uma segunda heuristica definida pelos programadores por sugestao do enunciado. A funcao recebe um tabuleiro e um valor inteiro que representa o objetivo: o numero de caixas a fechar"
  (cond
    ((null tabuleiro) nil)
    ((eq obj 0) 0)
    (t (- obj (max (numero-caixas-fechadas tabuleiro) (numero-caixas-quase-fechadas tabuleiro))))
  )
)

;;; Metodos seletores
;; get-tabuleiro
(defun get-tabuleiro (no)
"Devolve o tabuleiro do no recebido"
  (car no)
)

;; get-tabuleiro
(defun get-profundidade (no)
"Devolve a profundidade do no recebido"
  (second no)
)

;; get-tabuleiro
(defun get-heuristica (no)
"Devolve a heuristica do no recebido"
  (third no)
)

;; get-tabuleiro
(defun get-pai (no)
"Devolve o pai do no recebido"
  (fourth no)
)

;; get-arcos-horizontais
(defun get-arcos-horizontais (tabuleiro)
"Recebe um tabuleiro e devolve o conjunto de linhas horizontais"
  (cond
    ((null tabuleiro) ())
    (t (car tabuleiro))
  )
)

;; get-arcos-verticais
(defun get-arcos-verticais (tabuleiro)
"Recebe um tabuleiro e devolve o conjunto de linhas verticais"
  (cond
    ((null tabuleiro) ())
    (t (second tabuleiro))
  )
)

;; fcusto
(defun fcusto (no)
"Funcao que recebe um n� e devolve o custo F do mesmo."
  (+ (get-profundidade no) (get-heuristica no))
)




;;; Operadores do problema
;; arco-vertical
(defun arco-vertical (linha coluna tabuleiro)
"Recebe um tabuleiro e poe a T um arco vertical de acordo com a linha e coluna recebidas, devolve o tabuleiro com o arco adicional"
  (cond
    ((or (zerop linha) (zerop coluna)) tabuleiro)
    (t (list (get-arcos-horizontais tabuleiro) (arco-aux linha coluna (get-arcos-verticais tabuleiro))))
  )
)

;; arco-horizontal
(defun arco-horizontal (linha coluna tabuleiro)
"Recebe um tabuleiro e poe a T um arco horizontal de acordo com a linha e coluna recebidas, devolve o tabuleiro com o arco adicional"
  (cond
    ((or (zerop linha) (zerop coluna)) tabuleiro)
    (t (list (arco-aux linha coluna (get-arcos-horizontais tabuleiro)) (get-arcos-verticais tabuleiro)))
  )
)

;;; Funcao auxiliar dos operadores do problema
;; arco-aux
(defun arco-aux (linha coluna conjunto)
"Recebe um conjunto de arcos e mete a T de acordo com a linha e coluna recebida como parametros"
  (cond
    ((= coluna 1) (cons (arco-na-posicao linha (car conjunto)) (cdr conjunto)))
    (t (cons (car conjunto) (arco-aux linha (1- coluna) (cdr conjunto))))
  )
)

;; arco-na-posicao
(defun arco-na-posicao (num linha)
"Recebe uma linha de arcos e poe a T no numero recebido como parametro"
  (cond
    ((= num 1) (cons T (cdr linha)))
    (t (cons (car linha) (arco-na-posicao (1- num) (cdr linha))))
  )
)

;;; Funcoes Auxiliares da procura
;; solucaop
(defun solucaop (no valor)
"Recebe um valor que representa o objetivo a atingir e verifica se o no recebido atingiu esse mesmo objetivo, neste caso sao numero de caixas fechadas"
  (cond
    ((null no) nil)
    ((eq (numero-caixas-fechadas (get-tabuleiro no)) valor) t)
    (t nil)
  )
)

;; sucessores
(defun sucessores (no operadores algoritmo prof-max heuristica objetivo)
"Funcao que recebe um no, operadores, algoritmo e prof-max e gera os nos sucessores"
  (cond
    ((and (eq algoritmo 'dfs) (>= (get-profundidade no) prof-max)) nil)
    (t (append 
      (mapcar #'(lambda (pos) (sucessores-aux no (car operadores) (car pos) (cadr pos) heuristica objetivo)) (car (posicoes-dos-sucessores (get-tabuleiro no))))
      (mapcar #'(lambda (pos) (sucessores-aux no (cadr operadores) (car pos) (cadr pos) heuristica objetivo)) (cadr (posicoes-dos-sucessores (get-tabuleiro no)))))
    )
  )
)

;; sucessores-aux
(defun sucessores-aux (no funcao linha coluna f-heuristica objetivo)
"Funcao auxiliar a funcao sucessores"
  (let ((tabAtual (funcall funcao linha coluna (get-tabuleiro no))))
  (list tabAtual (1+ (get-profundidade no)) (cond ((eq f-heuristica 9999) 9999) (t (funcall f-heuristica tabAtual objetivo))) no)
)
)


;; existep
(defun existep (no lista-nos algoritmo)
"Funcao que verifica se o no recebido como parametros existe numa lista tambem recebida como parametros, tendo em conta o algoritmo recebido"
  (cond
    ((null lista-nos) nil)
    ((and (eq algoritmo 'dfs) (equal (get-tabuleiro no) (get-tabuleiro (car lista-nos))) (>= (get-profundidade no) (get-profundidade (car lista-nos)))) t)
    ((and (not (eq algoritmo 'dfs)) (equal (get-tabuleiro no) (get-tabuleiro (car lista-nos)))) t)
    (t (existep no (cdr lista-nos) algoritmo))
  )
)

;; existe-solucao
(defun existe-solucao (lista f-solucao objetivo f-algoritmo)
"Verifica se existe uma solucao ao problema numa lista de sucessores para o algoritmo dfs"
  (cond
	 ((not (eql f-algoritmo 'dfs)) nil)
     ((null lista) nil)
     ((funcall f-solucao (car lista) objetivo) (car lista))
     (T (existe-solucao (cdr lista) f-solucao objetivo f-algoritmo)))
)

;; posicoes-dos-sucessores
(defun posicoes-dos-sucessores (tabuleiro)
"Recebe um tabuleiro e devolve uma lista com listas que teem as linhas e colunas das jogadas"
  (list 
    (lista-posicao 0 (get-arcos-horizontais tabuleiro)) 
    (lista-posicao 0 (get-arcos-verticais tabuleiro)))
)

;; lista-posicao
(defun lista-posicao (num linhas)
"Recebe um conjunto de linhas e devolve listas com o numero da lista em que se encontra e a posicao dentro desta"
  (cond
    ((null linhas) nil)
    (t (append (posicao (1+ num) 0 (car linhas)) (lista-posicao (1+ num) (cdr linhas))))
  )
)

;; posicao
(defun posicao (num pos linha)
"Recebe um numero e uma linha e devolve listas com a informacao do numero e a posicao da jogada"
  (cond
    ((null linha) nil)
    ((null (car linha)) (cons (list (1+ pos) num) (posicao num (1+ pos) (cdr linha))))
    (t (posicao num (1+ pos) (cdr linha)))
  )
)

;; numero-caixas-fechadas
(defun numero-caixas-fechadas (tabuleiro)
"Recebe um tabuleiro e devolve o numero de caixas ja fechadas"
  (let ((linhas (car tabuleiro)) (colunas (cadr tabuleiro)))
    (cond
      ((or (eq (length linhas) 1) (eq (length colunas) 1)) 0)
      (t (+ (numero-caixas-fechadas-horizontal tabuleiro) 
        (numero-caixas-fechadas (list (cdr linhas) (tira-primeiras colunas)))))
    )
  )
)

;; tira-primeiras
(defun tira-primeiras (colunas)
"Recebe um conjunto de linhas de um tabuleiro e retira os primeiros arcos"
  (mapcar #'(lambda (coluna) (cdr coluna)) colunas)
)

;; numero-caixas-fechadas-horizontal
(defun numero-caixas-fechadas-horizontal (tabuleiro)
"Recebe um tabuleiro e verifica quantas caixas ja estao fechadas entre os dois primeiros conjuntos de linhas horizontais"
  (let ((linhas (car tabuleiro)) (colunas (cadr tabuleiro)))
    (cond
      ((or (eq (length linhas) 1) (eq (length colunas) 1)) 0)
      ((ver-caixa-fechada (car linhas) (cadr linhas) (car colunas) (cadr colunas)) 
        (1+ (numero-caixas-fechadas-horizontal (list (tira-primeiras linhas) (cdr colunas)))))
      (t (numero-caixas-fechadas-horizontal (list (tira-primeiras linhas) (cdr colunas))))
    )
  )
)

;; ver-caixa-fechada
(defun ver-caixa-fechada (linha1 linha2 linha3 linha4)
"Recebe 4 listas (linhas) e ve se a primeira caixa esta fechada, devolve t se tiver"
  (cond
    ((and (ver-se-1a-caixa-potencial linha1 linha2) (ver-se-1a-caixa-potencial linha3 linha4)) t)
    (t nil)
  )
)

;; ver-se-1a-caixa-potencial
(defun ver-se-1a-caixa-potencial (linha1 linha2)
"Recebe 2 linhas e devolve se a primeira caixa e uma possivel caixa fechada"
  (cond
    ((eq (car (intersecao (ver-pos-lista-ligadas linha1) (ver-pos-lista-ligadas linha2))) 1) t)
    (t nil)
  )
)

;; ver-pos-lista-ligadas
(defun ver-pos-lista-ligadas (lista-horizontal)
"Recebe uma lista (linha) de nils e t's e devolve uma lista com as posicoes dos t's"
  (cond
    ((null lista-horizontal) nil)
    ((eq (car lista-horizontal) t) (cons 1 (ver-pos-lista-ligadas-aux 2 (cdr lista-horizontal))))
    (t (ver-pos-lista-ligadas-aux 2 (cdr lista-horizontal)))
  )
)

;; ver-pos-lista-ligadas-aux
(defun ver-pos-lista-ligadas-aux (num lista-horizontal)
"Funcao auxiliar a funcao ver-pos-lista-ligadas"
  (cond
    ((null lista-horizontal) nil)
    ((eq (car lista-horizontal) t) (cons num (ver-pos-lista-ligadas-aux (1+ num) (cdr lista-horizontal))))
    (t (ver-pos-lista-ligadas-aux (1+ num) (cdr lista-horizontal)))
  )
)

;; intersecao
(defun intersecao (c1 c2)
"Funcao generica que devolve a intersecao entre dois conjuntos"
  (cond
    ((null c2) nil)
    ((esta-no-conjunto (car c2) c1) (cons (car c2) (intersecao c1 (cdr c2))))
    (t (intersecao c1 (cdr c2)))
  )
)

;; esta-no-conjunto
(defun esta-no-conjunto (elem conjunto)
"Funcao que verifica se um elemento recebido esta dentro do conjunto recebido, devolve t se estiver"
  (cond
    ((null conjunto) nil)
    ((equal elem (car conjunto)) t)
    (t (esta-no-conjunto elem (cdr conjunto)))
  )
)

;; verifica o numero de caixas quase fechadas
(defun numero-caixas-quase-fechadas (tabuleiro)
"Recebe um tabuleiro e devolve o numero de caixas quase fechadas do mesmo"
  (let ((linhas (car tabuleiro)) (colunas (cadr tabuleiro)))
    (cond
      ((or (eq (length linhas) 1) (eq (length colunas) 1)) 0)
      (t (+ (numero-caixas-quase-fechadas-horizontal tabuleiro) 
        (numero-caixas-quase-fechadas (list (cdr linhas) (tira-primeiras colunas)))))
    )
  )
)

;; numero-caixas-quase-fechadas-horizontal
(defun numero-caixas-quase-fechadas-horizontal (tabuleiro)
"Recebe um tabuleiro e verifica quantas caixas estao quase fechadas entre os dois primeiros conjuntos de linhas horizontais"
  (let ((linhas (car tabuleiro)) (colunas (cadr tabuleiro)))
    (cond
      ((or (eq (length linhas) 1) (eq (length colunas) 1)) 0)
      ((ver-caixa-quase-fechada (car linhas) (cadr linhas) (car colunas) (cadr colunas)) 
        (1+ (numero-caixas-quase-fechadas-horizontal (list (tira-primeiras linhas) (cdr colunas)))))
      (t (numero-caixas-quase-fechadas-horizontal (list (tira-primeiras linhas) (cdr colunas))))
    )
  )
)

;; ver-caixa-quase-fechada
(defun ver-caixa-quase-fechada (linha1 linha2 linha3 linha4)
"Recebe 4 listas (linhas) e ve se a primeira caixa esta quase fechada, devolve t se tiver"
  (cond
    ((or (and (ver-se-1a-caixa-tem-possivel-quase-caixa linha1 linha2) (ver-se-1a-caixa-potencial linha3 linha4)) 
         (and (ver-se-1a-caixa-potencial linha1 linha2) (ver-se-1a-caixa-tem-possivel-quase-caixa linha3 linha4)) )
t)
    (t nil)
  )
)

;; ver-se-1a-caixa-tem-possivel-quase-caixa
(defun ver-se-1a-caixa-tem-possivel-quase-caixa (linha1 linha2)
"Recebe 2 linhas e devolve se a primeira caixa e uma possivel caixa quase fechada"
  (cond
    ((eq (car (intersecao (ver-pos-lista-ligadas linha1) (ver-pos-lista-ligadas linha2))) 1) nil)
    ((or (and (eq (car (ver-pos-lista-ligadas linha1)) 1) (not (eq (car (ver-pos-lista-ligadas linha2)) 1)))
     (and (eq (car (ver-pos-lista-ligadas linha2)) 1) (not (eq (car (ver-pos-lista-ligadas linha1)) 1)))) t)
    (t nil)
  )
)

;; ordenar-nos
(defun ordenar-nos (lista-nos)
"Metodo que recebe uma lista de nos e ordena os elementos de acordo com as suas heuristicas e as suas profundidades"
  (sort lista-nos #'(lambda (no1 no2) (cond ((<= (+ (get-heuristica no1) (get-profundidade no1)) (+ (get-heuristica no2) (get-profundidade no2))) t) (t nil))))
)

;; ordenar-nos-rbfs
(defun ordenar-nos-rbfs(lista-nos)
"Metodo que recebe uma lista de nos e verifica se esta em condicao de ordenar para o rbfs ou n�o, devolvendo t ou nil"
(sort lista-nos #'(lambda (no1 no2) (cond ((<= (+ (second no1) (third no1)) (+ (second no2) (third no2))) t) (t nil))))
)


;; numero-de-nos-gerados
(defun numero-de-nos-gerados (tabuleiro)
"Recebe um tabuleiro e devolve o numero de nos gerados do mesmo"
  (list-length (sucessores tabuleiro (operadores) 'bfs 9999 9999 1))
)

;; fator-ramificacao-close-guess
(defun fator-ramificacao-close-guess (nos-gerados profundidade)
"recebe o numero de nos gerados e a profundidade e devolve uma aproximacao do que seria o fator de ramificacao"
  (expt nos-gerados (/ 1 profundidade))
)

;; fator-ramificacao
(defun fator-ramificacao (no-inicial no-final)
"Recebe o no inicial e o no final e devolve o fator de ramificacao"
  (fator-ramificacao-aux (third no-final) (second (car no-final)) (numero-de-nos-gerados no-inicial) (1+ (numero-de-nos-gerados (car no-final))))
)

;; fator-ramificacao-aux
(defun fator-ramificacao-aux (nos-gerados profundidade x-esquerda x-direita &optional (iteracoes-maximas 20) (tolerancia-erro 0.05))
  "Funcao auxiliar a funcao fator-ramificacao que recebe como argumentos tudo o necessario para calcular o fator de ramificacao"
  (cond
   ((= nos-gerados 0) 0)
   ((<= profundidade 1) nos-gerados)
   (t
    (let*
        ((estimativa-media (/ (+ x-esquerda x-direita) 2))
         (nos-gerados-aux (fator-ramificacao-medio estimativa-media profundidade))
         (calculo (- nos-gerados-aux nos-gerados))
         )
      (cond
       ((< (abs calculo) tolerancia-erro) estimativa-media)
       ((= iteracoes-maximas 0) estimativa-media)
       ((> calculo 0) (fator-ramificacao-aux nos-gerados profundidade x-esquerda estimativa-media (1- iteracoes-maximas)))
       ((< calculo 0) (fator-ramificacao-aux nos-gerados profundidade estimativa-media x-direita (1- iteracoes-maximas)))
       )
      )))
)

;; fator-ramificacao-medio
(defun fator-ramificacao-medio (valor profundidade)
  "Recebe um valor e uma profundidade e calcula o fator de ramificacao medio de acordo com o valor recebido"
  (cond
   ((> valor 1) (* (/ valor (1- valor)) (1- (expt valor profundidade))))
   (t (1- (expt valor profundidade)))
   )
  )