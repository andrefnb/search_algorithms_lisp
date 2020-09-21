;;;; projeto.lisp
;;;; Disciplina de IA - 2016 / 2017
;;;; 1� Projeto
;;;; Programador: Andr� Bastos - 140221017, Lu�s Mestre - 140221002

;; iniciar
(defun iniciar()
"Funcao que da inicio ao programa"
(progn
  (format t "Seja muito bem-vindo ao projeto LISP dos alunos Andre Bastos, 140221017~%")
  (format t "& Luis Mestre, 140221002. Este projeto ser� um teste de algoritmos e da~%")
  (format t "nossa capacidade de programacao em LISP.~%")
  (format t "Vamos comecar :-) ~%~%")
  (let* ((diretorio (load-files))
         (no (ler-escolha-utilizador))
         (algoritmo (ler-algoritmo))
         (profundidade (cond ((eq algoritmo 'dfs) (ler-profundidade)) (T 9999)))
         (heuristica (cond ((or (eq algoritmo 'a*) (eq algoritmo 'rbfs)) (ler-heuristica)) (T 9999)))
         (caixas-fechadas (ler-numero-caixas-fechadas no))
         (valor-heuristica (cond ((equal heuristica 9999) 9999) (t (funcall heuristica no caixas-fechadas))))
         (no-final (cond
                    ((eq algoritmo 'rbfs) (procura-rbfs (cria-no no 0 valor-heuristica) caixas-fechadas 'solucaop heuristica 'sucessores (operadores)))
                    (t (procura-generica caixas-fechadas (cria-no no 0 valor-heuristica) profundidade 'solucaop 'sucessores algoritmo (operadores) heuristica)))))
    (escreve (cria-no no 0 valor-heuristica) algoritmo caixas-fechadas no-final diretorio heuristica profundidade)
    
    )
  )
)


;; load-files
;diretorio - "C:/Users/luism/Desktop/EI/3� Ano/1� Semestre/IA/Projeto/Projeto-LISP/"
(defun load-files()
"Load-files � um metodo que far� a leitura dos ficheiros com os metodos de procura, dos algoritmos e dos restantes operadores"
(progn
  (format t "Escreva o path da localizacao do projeto entre aspas~%")
  (format t "Exemplo: ''C:/Users/username/Desktop/''~%")
  (let ((path (read)))
    (load (compile-file (concatenate 'string path "puzzle.lisp")))
    (load (compile-file (concatenate 'string path "procura.lisp")))
    path
    )
  )
)

;; ler-heuristica
(defun ler-heuristica ()
"Funcao que pede ao utilizador qual heuristica deseja utilizar"
  (progn
    (format t "Prefere qual das heuristicas?:~%")
    (format t "1-Heuristica do enunciado~%")
    (format t "2-Heuristica nova~%")
    (format t "3-Heuristica nova 2~%")
    (let ((valor (read)))
      (cond
       ((= valor 1) 'heuristica)
       ((= valor 2) 'heuristica-nova)
       ((= valor 3) 'heuristica-nova2)
       (t (progn (format t "Valor invalido~%") (ler-heuristica)))
       ))
    )
)

;; ler-escolha-utilizador
(defun ler-escolha-utilizador()
"Funcao que pede ao utilizador que modalidade de tabuleiro deseja escolher"
  (progn
    (format t "Prefere:~%")
    (format t "1-Criar Tabuleiro Vazio~%")
    (format t "2-Dar um Tabuleiro Pre-definido~%")
    (format t "3-Escolher um tabuleiro criado num ficheiro~%")
    (let ((valor (read)))
      (cond
       ((= valor 1) (ler-tabuleiro-vazio))
       ((= valor 2) (ler-tabuleiro-definido))
       ((= valor 3) (ler-tabuleiro-ficheiro))
       (t (progn (format t "Valor invalido~%") (ler-escolha-utilizador)))
       ))
    )
)

;; ler-tabuleiro-ficheiro
(defun ler-tabuleiro-ficheiro()
"Funcao que le um ficheiro com tabuleiros"
  (progn
    (format t "Escreva o nome do ficheiro juntamente com o seu path~%")
    (format t "Exemplo ''C:/Users/username/Desktop/problema.dat''~%")
    (let ((ficheiro (read)))
      (ler-tabuleiro-ficheiro-aux ficheiro)
      )
    )
)

;; ler-tabuleiro-ficheiro-aux
(defun ler-tabuleiro-ficheiro-aux (f)
"Funcao auxiliar a funcao ler-tabuleiro-ficheiro"
  (progn
    (format t "~%Escolha o tabuleiro que quer usar (insira um numero)~%")
    (let* ((lista-tabuleiros (read (open f))) (escolha (read)) (tabuleiro-escolhido (escolher-tabuleiro lista-tabuleiros escolha)))
      (cond
       ((null tabuleiro-escolhido) (progn (format t "O tabuleiro que escolheu n�o existe~%") (ler-tabuleiro-ficheiro-aux f)))
       (t tabuleiro-escolhido)
       )
      )
    )
)

;; escolher-tabuleiro
(defun escolher-tabuleiro (no escolha)
"Funcao que recebe uma lista de tabuleiros (no) e a escolha do utilizador e devolve o tabuleiro correspondente"
  (cond
   ((null no) nil)
   ((= escolha 1) (car no))
   (t (escolher-tabuleiro (cdr no) (1- escolha)))
   )
)

;; ler-tabuleiro-vazio
(defun ler-tabuleiro-vazio ()
"Metodo que cria o tabuleiro de acordo com as dimensoes inseridas pelo utilizador"
  (let ((num-linhas (ler-dimensoes "linhas")) (num-colunas (ler-dimensoes "colunas")))
    (tabuleiro-vazio num-linhas num-colunas))
)

;; ler-tabuleiro-definido
(defun ler-tabuleiro-definido()
"Funcao pede ao utilizador um tabuleiro e devolve o mesmo"
  (progn
    (format t "Insira o tabuleiro definido:~%")
    (read)
    )
)

;; ler-dimensoes
(defun ler-dimensoes (dimensoes)
"Funcao que pede utilizador as dimensoes de linha ou coluna de um tabuleiro dependendo do parametro que recebe (dimensoes)"
  (progn
    (format t "Insere a dimensao das ~A do tabuleiro~%" dimensoes)
    (let ((valor (read)))
      (cond
       ((< valor 1) (progn (format t "Valor invalido~%") (ler-dimensoes dimensoes)))
       (t valor)))
    )
)

;; ler-algoritmo
(defun ler-algoritmo ()
"Funcao que pede ao utilizador que algoritmo pretende utilizar e devolve o mesmo"
  (progn
    (format t "~%Que algoritmo quer utilizar?~%")
    (format t "1 - Procura na largura (Breadth First)~%")
    (format t "2 - Procura em profundidade (Depth First)~%")
    (format t "3 - Procura com heuristica (A*)~%")
    (format t "4 - Procura recursive best first search (RBFS)~%")
    (let ((resposta (read)))
      (cond
       ((= resposta 1) 'bfs)
       ((= resposta 2) 'dfs)
       ((= resposta 3) 'a*)
       ((= resposta 4) 'rbfs)
       (t (progn (format t "Insira um valor correto~%~%") (ler-algoritmo))))
      )
    )
)

;; ler-profundidade
(defun ler-profundidade()
"Funcao que pede ao utilizador para introduzir a profundidade limite para o algoritmo"
  (progn
    (format t "Qual a profundidade limite para o algoritmo dfs?~%")
    (read))
)

;; ler-numero-caixas-fechadas
(defun ler-numero-caixas-fechadas (tabuleiro)
"Metodo que pede ao utilizador quantas caixas fechadas o algoritmo tem de fazer"
  (progn
    (format t "Qual o numero de caixas fechadas quer?~%")
    (let ((valor (read)) (limite (limite-numero-caixas-fechadas tabuleiro)))
      (cond
       ((and (> valor 0) (<= valor limite)) valor)
       (t (progn (format t "Insira um valor valido ~%~%") (ler-numero-caixas-fechadas tabuleiro)))
       )
      )
    )
)

;; limite-numero-caixas-fechadas
(defun limite-numero-caixas-fechadas (tabuleiro)
"Metodo que calcula o limite de numero de caixas fechadas no tabuleiro que o utilizador quer usar"
  (let ((horizontais (1- (length (get-arcos-horizontais tabuleiro))))
        (verticais (1- (length (get-arcos-verticais tabuleiro)))))
    (* horizontais verticais))
)

;; Output ecr� e no ficheiro - escrita do estado do problema
;; escreve
(defun escreve (no-problema algoritmo objetivo no-final diretorio heuristica-escolhida prof-max)
"Funcao que recebe o necessario para escrever na consola e no ficheiro as estatisticas da simulacao e cria uma string com o necessario para chamar a funcao escreve-ecra-ficheiro"
  (let* ((resultado-aux
          (cond ((eq algoritmo 'dfs)
                 (format nil "Profundidade Maxima: ~a~%" prof-max))
                ((not (or (eq algoritmo 'dfs) (eq algoritmo 'bfs)))
                 (format nil "Heuristica Escolhida: ~a~%" heuristica-escolhida))
                (t (format nil "F-Limite: ~a~%" (+ (sixth no-final) (seventh no-final))))))
        (resultados (concatenate 'string
                                 (format nil "Problema: ~a~%" (get-tabuleiro no-problema))
                                 (format nil "Algoritmo Escolhido: ~a~%" algoritmo)
                                 (format nil "Numero de Caixas Fechadas (Objetivo): ~a~%" objetivo)
                                 resultado-aux
                                 (format nil "| Linhas: ~a | Colunas: ~a | G: ~a | H: ~a |~%" (get-arcos-horizontais (car (car no-final))) (get-arcos-verticais (car (car no-final))) (second (car no-final)) (third (car no-final)))
                                 (format nil "| Tempo de Execucao (segundos): ~a | Fator-Ramificacao: ~,5f |~%" (second no-final) (float (fator-ramificacao no-problema no-final)))
                                 (format nil "| Nos-Gerados: ~a | Nos-Expandidos: ~a | Penetrancia: ~a |~%" (third no-final) (fourth no-final) (fifth no-final))
                                 (format nil "| Pai: ~a ~%~%" (fourth (car no-final))))))
    (escreve-ecra-ficheiro diretorio resultados))
)

;; escreve-ecra-ficheiro
(defun escreve-ecra-ficheiro (diretorio string)
"Recebe a string a escrever na consola e no ficheiro"
  (with-open-file (stream (concatenate 'string diretorio "resultados.dat")
                          :direction :output :if-exists :append :if-does-not-exist :create)
      (princ string stream))
    (format t string)
)

(defun escreve-rbfs (no-final diretorio)
(let* ((resultados (concatenate 'string
                                 (format nil "| Linhas: ~a | Colunas: ~a | G: ~a | H: ~a |~%" (get-arcos-horizontais (car no-final)) (get-arcos-verticais (car no-final)) (second no-final) (third  no-final))
                                 (format nil "| Pai: ~a ~%~%" (fourth no-final)))))
    (escreve-ecra-ficheiro diretorio resultados))
)






