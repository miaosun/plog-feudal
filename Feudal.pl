%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Feudal em Prolog       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Miao Sun  &  Jorge Reis   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%       Turma 3 Grupo 1       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    PLOG  MIEIC 2012/2013    %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-compile('Tabuleiro.pl').


start:-
	welcome,
	menu_start.


comeca_jogo(Op):-
       (Op == 1, clear(50),write('\nMode: Humano contra Humano\n'),nl,
	estadoInicial(Tab),pecas_J1(Hand1), pecas_J2(Hand2),
	%insere_todas_pecas(j1,Hand1,Tab,Tab1,_,_),!, clear(50),
	%insere_todas_pecas(j2,Hand2,Tab1,Tab2,_,_),!, clear(50),

	estadoTeste2(Tab2),
	jogador_jogador(j1,Tab2,_,[]),!);

       (Op == 2, clear(50),write('\nMode: Humano contra Computador\n'),nl, %menu_nivel,!
	estadoInicial(Tab), pecas_J1(Hand1), pecas_J2(Hand2),
%	insere_todas_pecas(j1,Hand1,Tab,Tab1,_,_),!, clear(50),
	estado_inPC(Tab1),
	insere_todas_pecas(pc,Hand2,Tab1,Tab2,[],Pos_PC),!,clear(50),

	jogador_computador(j1,Tab2,_,Pos_PC),!);

       (Op == 3, clear(50),write('\nMode: Computador contra Computador\n'),nl, %menu_nivel
        estadoInicial(Tab), pecas_J1(Hand1), pecas_J2(Hand2),
	insere_todas_pecas(pc1,Hand1,Tab,Tab1,[],Pos_PC1),!,clear(50),
	insere_todas_pecas(pc2,Hand2,Tab1,Tab2,[],Pos_PC2),!,clear(50),

	computador_computador(pc1,Tab2,_,Pos_PC1,Pos_PC2),!).


%funcao so serve no inicio do jogo,permite jogador inserir todas as pecas no tabuleiro Tab, e guarda último
%estado do tabuleiro no Tabf.
insere_todas_pecas(_,[],Tab,Tab,Lis,Lis):-!.
insere_todas_pecas(J,Hand,Tab,Tabf,Lis,Pos_PC):-
        vez_jogador(J,Tab),tab(8),write(': insere todas as suas pecas no seu reino!'),nl,nl,
	print_legenda, length(Hand, HandSize),jogador(J,NJ),
	write('Player '), write(NJ), write(' hand: '), printList(Hand),nl,nl,
	write('Escolhe uma peca:'),nl, mostra_hand(Hand,1),nl, write('Peca: '),
	(
	 ((J==pc;J==pc1;J==pc2), Aux is HandSize+1,
	  (random(1,Aux,P), write(P),nl,remove_at(Hand,P,Peca,Hand2)),

	  repeat,((repeat, ((J==pc1,random(1,13,Ln)); random(13,25,Ln)), linha_valida_inserir(J,Ln)),
	          (random(1,25,Cn), coluna_valida(Cn)),colocacao_valida(J,Peca,Ln,Cn,Tab),write('Linha: '),
		  write(Ln),nl, write('Coluna: '),write(Cn),nl,append([[Ln,Cn]],Lis,Acc)),!,
	  sleep(1),insere_peca_no_tab(Peca,Ln,Cn,Tab,Tab1), insere_todas_pecas(J,Hand2,Tab1,Tabf,Acc,Pos_PC)); %operacao para jogador PC

	 ((J==j1;J==j2),read(P),
	  ( (integer(P), P>0, P=<HandSize, remove_at(Hand,P,Peca,Hand2));
	    (write('Opcao invalida, tenta novamente!'),nl,nl,sleep(1),
	     insere_todas_pecas(J,Hand,Tab,Tab1,Lis,Pos_PC)) ),nl,

	  repeat,
	  ((repeat, (write('Linha: '), read(Ln), linha_valida_inserir(J,Ln))),
	   (write('Coluna: '), read(Cn), coluna_valida(Cn)),colocacao_valida(J,Peca,Ln,Cn,Tab)),!,

	  insere_peca_no_tab(Peca,Ln,Cn,Tab,Tab1), insere_todas_pecas(J,Hand2,Tab1,Tabf,Acc,Pos_PC)) %operacao para jogador Humano
	).


%verifica se a colocacao da peca e valida, se a peca for C-Castle ou G-Green, permite colocar em qualquer casa do seu reino,
%outras pecas so podem ser colocadas em casa "vazia"
colocacao_valida(J,Peca,Ln,Cn,Tab):-
	nth(Tab,Ln,LElm),
	nth(LElm,Cn,Casa),
	vizinhos(J,Ln,Cn,Tab,LisV),
        get_peca_do_tab(J,Ln,Cn,Tab,PecaTab),
	(
	 ( (J==j1;J==pc1),
	    ((Peca==aC, ((PecaTab\=aG, \+peca_esta_no_tab(aG,Tab)); member(aG,LisV)));
	     (Peca==aG, ((PecaTab\=aC, \+peca_esta_no_tab(aC,Tab)); member(aC,LisV)));
	     (Peca\=aC, Peca\=aG, Casa==0)) ),!;

	 ( (J==j2;J==pc;J==pc2),
            ((Peca==bC, ((PecaTab\=bG, \+peca_esta_no_tab(bG,Tab)); member(bG,LisV)));
	     (Peca==bG, ((PecaTab\=bC, \+peca_esta_no_tab(bC,Tab)); member(bC,LisV)));
	     (Peca\=bC, Peca\=bG, Casa==0)) ),!;

	 ( ((J==j1;J==j2),(write('Jogada nao valida, tenta novamente!')),!,nl,fail); fail)
	).


nth([H|_],1,H):-!.
nth([_|T],N,X):-
	N1 is N-1, nth(T,N1,X).


%insere peca no tabuleiro na determinada posicao
insere_peca_no_tab(Peca,1,Cn,[H|T],[H2|T]):-
	insere_na_linha(Peca,Cn,H,H2),!.

insere_peca_no_tab(Peca,Ln,Cn,[H|T],[H|T2]):-
	Ln1 is Ln-1,
	insere_peca_no_tab(Peca,Ln1,Cn,T,T2).

%funcao auxiliar
insere_na_linha(Peca,1,[_|T],[Peca|T]):-!.
insere_na_linha(Peca,N,[H|T],[H|T2]):-
	N1 is N-1,
	insere_na_linha(Peca,N1,T,T2).


%mostra todas as pecas o jogador tem no momento
mostra_hand([],_):-!.
mostra_hand([H|T],N):-
	N1 is N+1, write(N),write(': '), draw_casa(H), write(' | '),
	mostra_hand(T,N1),!.


%remover a peca do tabuleiro, a casa fica vazia (0)
remover_do_tab(1,Cn,[H|T],[H2|T]):-
	remover_da_linha(Cn,H,H2),!.

remover_do_tab(Ln,Cn,[H|T],[H|T2]):-
	Ln2 is Ln - 1,
	remover_do_tab(Ln2,Cn,T,T2).

remover_da_linha(1,[_|T],[0|T]):-!.
remover_da_linha(Cn,[H|T],[H|T2]):-
	Cn2 is Cn - 1,
	remover_da_linha(Cn2,T,T2).


%remover a peca da lista com indice N, devolve a Peca e a lista final
remove_at([Peca|Xs],1,Peca,Xs):-!.
remove_at([Y|Xs],N,Peca,[Y|Ys]) :- N > 1,
   N1 is N - 1, remove_at(Xs,N1,Peca,Ys).


linha_valida_inserir(J,Ln):-
	((J==j1;J==pc1), Ln>=1,  Ln=<12),!;
	((J==j2;J==pc;J==pc2), Ln>=13, Ln=<24),!;
	(((J==j1;J==j2),write('Linha invalida, tenta novamente!'),nl,fail); fail).

linha_valida(Ln):-
	Ln>=1, Ln=<24,!;
	write('Linha invalida, tenta novamente!'),nl,fail.

coluna_valida(Cn):-
	Cn>=1, Cn=<24,!;
	write('Coluna invalida, tenta novamente!'),nl,fail.

%cada jogador pode movimentar uma ou varias pecas em cada seria de jogada
mover_mais_pecas(J,Jf,Lpos,Lpos3):-
	write('Pretende mover mais Pecas? (1: Sim | 2: Nao)'),nl,
	write('Opcao: '),read(Op),
	((integer(Op),((Op==1,Jf=J,copy(Lpos,Lpos3)); (Op==2, trocar_vez(J,Jf)),delete(Lpos,_,Lpos3)));
	 write('Opcao invalida, tenta novamente!'),nl,
	 mover_mais_pecas(J,Jf,Lpos,Lpos3)).

copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).


jogador_jogador(J,Tab,Tabf,Lpos):-
       (game_over(Tab), print_tab(Tab2),mensagem_ganhar(J));
	vez_jogador(J,Tab), nl,print_legenda, pecas_J1(Pecas_J1), pecas_J2(Pecas_J2),
	write('Escolhe a posicao da Peca pretende mover'),nl,
        repeat,((repeat,(write('Linha: '),read(Ln1),linha_valida(Ln1))),(write('Coluna: '), read(Cn1), coluna_valida(Cn1),
	       permite_mover(J,Ln1,Cn1,Tab),sem_repeticoes(Ln1,Cn1,Lpos),!)), nl,nl,

        get_peca_do_tab(J,Ln1,Cn1,Tab,Peca),
        opcao_archer(Peca,Opcao),!,  %se a peca nao foi Archer, passa a frente
        ((Opcao==2,  %quando escolher para atacar
	  write('Escolhe a posicao pretende atacar'),nl,
          repeat,((repeat,(write('Linha: '),read(Ln2),linha_valida(Ln2))),(write('Coluna: '), read(Cn2), coluna_valida(Cn2))),!,
	  get_peca_do_tab(J,Ln2,Cn2,Tab,Casa),

	  ((((J==j1, member(Casa,Pecas_J2)); (J==j2, member(Casa,Pecas_J1))),
	    verifica_green(J,Casa,Tab), jogada_valida(J,Peca,Ln1,Cn1,Ln2,Cn2,Tab),
	    remover_do_tab(Ln2,Cn2,Tab,Tab2), %remove a peca doutro jogador qual foi atacada pela Archer
	    nl,posicoes_alteradas(Ln1,Cn1,Lpos,Lpos2), vez_jogador(J,Tab2), %guarda a posicao de Archer, nao pode jogar mais com Archer nesse seria de jogadas
	    ((game_over(Tab2), print_tab(Tab2),mensagem_ganhar(J));
	     (mover_mais_pecas(J,Jf,Lpos2,Lpos3),jogador_jogador(Jf,Tab2,Tabf,Lpos3))));
	   (nl, write('Opcao invalida, tenta novamente!'),nl,sleep(1),clear(10),jogador_jogador(J,Tab,Tabf,Lpos)))
         );

	(%quando escolher para movimentar, ou quando a peca nao foi Archer
	 write('Escolhe a posicao do destino'),nl,
	 repeat,((repeat,(write('Linha: '),read(Ln2),linha_valida(Ln2))),(write('Coluna: '), read(Cn2), coluna_valida(Cn2))),!,
	 get_peca_do_tab(J,Ln2,Cn2,Tab,Casa),
	 ((((J==j1, \+member(Casa,Pecas_J1));(J==j2, \+member(Casa,Pecas_J2))),%verifica se a posicao destino ?uma peca do jogador
	   verifica_green(J,Casa,Tab), jogada_valida(J,Peca,Ln1,Cn1,Ln2,Cn2,Tab),

	   archer_aux(Casa,Pecas_J1,Pecas_J2,Opcao,Saida),
	   ((Saida=yes,remover_do_tab(Ln1,Cn1,Tab,Tab1));  %quando foi um movimento valida, para Archer e outras pecas
	    fail), %quando tiver peca na casa destina, pois Archer so pode atacar com os tiros, nao pode movimentar a atacar

	   insere_peca_no_tab(Peca,Ln2,Cn2,Tab1,Tab2),nl,posicoes_alteradas(Ln2,Cn2,Lpos,Lpos2), vez_jogador(J,Tab2),
	   ((game_over(Tab2), print_tab(Tab2),mensagem_ganhar(J));
	    (mover_mais_pecas(J,Jf,Lpos2,Lpos3),jogador_jogador(Jf,Tab2,Tabf,Lpos3))));
	  (nl, write('Movimento nao valido, tenta novamente!'),nl,sleep(1),clear(10),jogador_jogador(J,Tab,Tabf,Lpos)))
	 ) ).


jogador_computador(J,Tab,Tabf,Pos_PC):-
	(game_over(Tab), print_tab(Tab2),mensagem_ganhar(J));
	pecas_J1(Pecas_J1), pecas_J2(Pecas_J2),

       ((J==pc,
	 repeat,(random_choose(Pos_PC, Peca_PC),nth(Peca_PC,1,Ln1),nth(Peca_PC,2,Cn1), permite_mover(J,Ln1,Cn1,Tab)),
	 get_peca_do_tab(J,Ln1,Cn1,Tab,Peca),
	 (repeat,(jogada_valida(pc,Peca,Ln1,Cn1,Ln2,Cn2,Tab), linha_valida(Ln2), coluna_valida(Cn2)),!,
	  get_peca_do_tab(J,Ln2,Cn2,Tab,Casa),
	 ((\+member(Casa,Pecas_J2),verifica_green(J,Casa,Tab), delete(Pos_PC,[Ln1,Cn1],Pos_PC_aux),
	   remover_do_tab(Ln1,Cn1,Tab,Tab1),insere_peca_no_tab(Peca,Ln2,Cn2,Tab1,Tab2),nl, append([[Ln2,Cn2]],Pos_PC_aux,Pos_PC_f),
	   print_mode_pc(J,Tab,Ln1,Cn1,Ln2,Cn2), sleep(2),
	   ((game_over(Tab2),print_tab(Tab2),mensagem_ganhar(J));
	    (trocar_vez_pc(J,Jf),jogador_computador(Jf,Tab2,Tabf,Pos_PC_f))) );
	  (nl,clear(10),jogador_computador(J,Tab,Tabf,Pos_PC)) ) ) );         %operacao Computador

        (vez_jogador(J,Tab),nl, print_legenda,
	 repeat,((repeat,(write('Linha: '), read(Ln1), linha_valida(Ln1))),
	        (write('Coluna: '), read(Cn1), coluna_valida(Cn1), permite_mover(J,Ln1,Cn1,Tab),!)),nl,nl,
         get_peca_do_tab(J,Ln1,Cn1,Tab,Peca),
	 write('Escolhe a posicao do destino'),nl,
	 repeat,((repeat, (write('Linha: '), read(Ln2), linha_valida(Ln2))),(write('Coluna: '),read(Cn2),coluna_valida(Cn2))),!,
         get_peca_do_tab(J,Ln2,Cn2,Tab,Casa),
	 ((\+member(Casa,Pecas_J1),verifica_green(J,Casa,Tab),jogada_valida(J,Peca,Ln1,Cn1,Ln2,Cn2,Tab),
	   remover_do_tab(Ln1,Cn1,Tab,Tab1),insere_peca_no_tab(Peca,Ln2,Cn2,Tab1,Tab2),nl,
	   ((game_over(Tab2), print_tab(Tab2),mensagem_ganhar(J));
	    (trocar_vez_pc(J,Jf),jogador_computador(Jf,Tab2,Tabf,Pos_PC))) );
	  (nl, write('Movimento nao valido, tenta novamente!'),nl,sleep(1),clear(10),jogador_computador(J,Tab,Tabf,Pos_PC)) )
	 ) ).           %operacao Humano

mensagem_ganhar(J):-
	write('Game over! O jogador '), jogador(J,NJ), write(NJ), write(' ganhou!'), nl,nl,
	write('Obrigado por jogar!'),nl,nl.

computador_computador(J,Tab,Tabf,Pos_PC1,Pos_PC2):-
        (game_over(Tab), write('Obrigado por jogar!'),nl);
	pecas_J1(Pecas_J1), pecas_J2(Pecas_J2),

	(repeat,(((J==pc1,random_choose(Pos_PC1,Peca_PC));(J==pc2,random_choose(Pos_PC2, Peca_PC))),
		 nth(Peca_PC,1,Ln1),nth(Peca_PC,2,Cn1), permite_mover(J,Ln1,Cn1,Tab)),
	 get_peca_do_tab(J,Ln1,Cn1,Tab,Peca),

	 repeat,(jogada_valida(J,Peca,Ln1,Cn1,Ln2,Cn2,Tab), linha_valida(Ln2), coluna_valida(Cn2)),!,
	 get_peca_do_tab(J,Ln2,Cn2,Tab,Casa),

	((((J==pc1,\+member(Casa,Pecas_J1),verifica_green(J,Casa,Tab), delete(Pos_PC1,[Ln1,Cn1],Pos_PC1_aux));
	   (J==pc2,\+member(Casa,Pecas_J2),verifica_green(J,Casa,Tab), delete(Pos_PC2,[Ln1,Cn1],Pos_PC2_aux))),
           remover_do_tab(Ln1,Cn1,Tab,Tab1),insere_peca_no_tab(Peca,Ln2,Cn2,Tab1,Tab2),nl,
	  ((J==pc1, append([[Ln2,Cn2]],Pos_PC1_aux,Pos_PC1_f));
	   (J==pc2, append([[Ln2,Cn2]],Pos_PC2_aux,Pos_PC2_f))),
	  print_mode_pc(J,Tab,Ln1,Cn1,Ln2,Cn2), sleep(1),
	  ((game_over(Tab2), write('Obrigado por jogar!'),nl);
	   (trocar_vez_pcs(J,Jf),
	    ((J==pc1,computador_computador(Jf,Tab2,Tabf,Pos_PC1_f,Pos_PC2));
	     (J==pc2,computador_computador(Jf,Tab2,Tabf,Pos_PC1,Pos_PC2_f)))))
	  );
	  (nl,clear(10),computador_computador(J,Tab,Tabf,Pos_PC1,Pos_PC2)))).


print_mode_pc(J,Tab,Ln1,Cn1,Ln2,Cn2):-
	vez_jogador(J,Tab),nl,
        print_legenda,
	write('Escolhe a posicao da Peca pretende mover'),nl,
	write('Linha: '), write(Ln1),nl, write('Coluna: '), write(Cn1),nl,nl,
	write('Escolhe a posicao do destino'),nl,
        write('Linha: '), write(Ln2),nl, write('Coluna: '), write(Cn2), nl.

%auxiliar para ver se a posicao onde a peca Archer quer movimentar e uma casa com uma peca doutro jogador,
%se tiver nao permite mover, pois Archer so pode atacar com os tiros
archer_aux(_,_,_,no,Saida):-Saida=yes.
archer_aux(Casa,Pecas_J1,Pecas_J2,1,Saida):-
	(\+member(Casa,Pecas_J1), \+member(Casa,Pecas_J2), Saida=yes);
	((write('Archer so pode atacar com os tiros, tenta novamente!'),nl, fail)).

%a peca Archer tem 2 possiveis jogadas, movimentar ou atacar
opcao_archer(Peca,Opcao):-
	(Peca\=aa, Peca\=ba, Opcao=no);
	((write('Pretende mover ou atacar? (1: Mover | 2: Atacar)'),nl, write('Opcao: '), read(Op)),
	 (((Op==1;Op==2), Opcao=Op);
	 (write('Opcao invalida, tenta novamente!'),nl, opcao_archer(Peca,Opcao)))).


%so permite a entrada ao castelo doutro jogador quando tiver entrada no Green doutro jogador
verifica_green(J,Casa,Tab):-
	(Casa\=aC, Casa\=bC);
	((J==j1, Casa==bC,(\+peca_esta_no_tab(bG,Tab); write('Tem que se primeiro entrar a Green para entrar o Castle'),fail,!));
	 (J==j2, Casa==aC, (\+peca_esta_no_tab(aG,Tab); write('Tem que se primeiro entrar a Green para entrar o Castle'),fail,!))).


%lista com posições alteradas em cada jogada
posicoes_alteradas(Ln,Cn,List,List2):-
	append([[Ln,Cn]],List,List2).

%cada jogador numa seria de jogadas pode movimentar varias pecas, mas cada peca so pode ser movimentada uma vez
sem_repeticoes(Ln,Cn,List):-
	\+member([Ln,Cn],List);
	write('A peca ja foi movimentada, tenta novamenta!'), nl, fail.


%cria uma lista de caminho
caminho(Ln1,Cn1,Ln2,Cn2,Tab,Caminho):-
	(Ln1==Ln2, caminho_coluna(Ln1,Cn1,Cn2,Tab,[],Caminho));
	(Cn1==Cn2, caminho_linha(Ln1,Ln2,Cn1,Tab,[],Caminho));
	(abs(Ln1-Ln2)=:=abs(Cn1-Cn2), caminho_diagonal(Ln1,Ln2,Cn1,Cn2,Tab,[],Caminho));
	caminho_squire(Ln1,Ln2,Cn1,Cn2,Tab,[],Caminho).


%cria uma lista de caminho em coluna
caminho_coluna(Ln1,Cn1,Coluna,Tab,Lis,Caminho_Coluna):-
	(Coluna==Cn1, Caminho_Coluna=Lis,!);
	(get_peca_do_tab(_,Ln1,Coluna,Tab,Peca),
	 append([Peca],Lis,Lis1),
	 ((Coluna>Cn1,Coluna2 is Coluna-1);(Coluna<Cn1, Coluna2 is Coluna+1)),
	 caminho_coluna(Ln1,Cn1,Coluna2,Tab,Lis1,Caminho_Coluna)).

%cria uma lista de caminho em linha
caminho_linha(Ln1,Linha,Cn1,Tab,Lis,Caminho_Linha):-
	(Linha==Ln1, Caminho_Linha=Lis,!);
	(get_peca_do_tab(_,Linha,Cn1,Tab,Peca),
	 append([Peca],Lis,Lis1),
	 ((Linha>Ln1, Linha2 is Linha-1); (Linha<Ln1, Linha2 is Linha+1)),
	 caminho_linha(Ln1,Linha2,Cn1,Tab,Lis1,Caminho_Linha)).

%cria uma lista de caminho em diagonal
caminho_diagonal(Ln1,Linha,Cn1,Coluna,Tab,Lis,Caminho_Diagonal):-
	(Linha==Ln1,Coluna==Cn1, Caminho_Diagonal=Lis,!);
	(get_peca_do_tab(_,Linha,Coluna,Tab,Peca),
	 append([Peca],Lis,Lis1),
	 ((Linha>Ln1, Linha2 is Linha-1, ((Coluna>Cn1, Coluna2 is Coluna-1); (Coluna<Cn1, Coluna2 is Coluna+1)));
	  (Linha<Ln1, Linha2 is Linha+1, ((Coluna>Cn1, Coluna2 is Coluna-1); (Coluna<Cn1, Coluna2 is Coluna+1)))),
	 caminho_diagonal(Ln1,Linha2,Cn1,Coluna2,Tab,Lis1,Caminho_Diagonal)).

%cria uma lista de caminho especiais da peca Squire
caminho_squire(Ln1,Linha,Cn1,Coluna,Tab,Lis,Caminho_Squire):-
	(((abs(Linha-Ln1)=:=1,Coluna==Cn1); (Linha==Ln1,abs(Coluna-Cn1)=:=1)),
	  get_peca_do_tab(_,Linha,Coluna,Tab,Peca), append([Peca],Lis,Caminho_Squire),!);
	(get_peca_do_tab(_,Linha,Coluna,Tab,Peca),
	 append([Peca],Lis,Lis1),
	 ((Linha-Ln1 =:= 1, Linha2 is Linha-1, ((Coluna-Cn1=:=2, Coluna2 is Coluna-1); (Coluna-Cn1 =:= -2, Coluna2 is Coluna+1)));
	  (Linha-Ln1 =:= -1, Linha2 is Linha+1, ((Coluna-Cn1=:=2, Coluna2 is Coluna-1); (Coluna-Cn1 =:= -2, Coluna2 is Coluna+1)));
	  (Linha-Ln1 =:= 2, Linha2 is Linha-1, ((Coluna-Cn1=:=1, Coluna2 is Coluna-1); (Coluna-Cn1 =:= -1, Coluna2 is Coluna+1)));
	  (Linha-Ln1 =:= -2, Linha2 is Linha+1, ((Coluna-Cn1=:=1, Coluna2 is Coluna-1); (Coluna-Cn1 =:= -1, Coluna2 is Coluna+1)))),
	 caminho_squire(Ln1,Linha2,Cn1,Coluna2,Tab,Lis1,Caminho_Squire)).

%verifica se uma determinada jogada e valida
jogada_valida(J,Peca,Ln1,Cn1,Ln2,Cn2,Tab):-
	((Ln1\=Ln2; Cn1\=Cn2), caminho(Ln1,Cn1,Ln2,Cn2,Tab,Caminho), move_valida_aux(Caminho),!,
	 (move_valida_king(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_mountedmen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_sergeants(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_pikemen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_squire(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_archer(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho)));

	((J==pc;J==pc1;J==pc2),
	 (move_valida_king(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_mountedmen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_sergeants(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_pikemen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_squire(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho);
	  move_valida_archer(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho))).

%verifica se o movimento da peca King e valida
move_valida_king(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
	(Peca==aK; Peca==bK), \+member(x,Caminho),
	((Ln1==Ln2, abs(Cn1-Cn2)=<2);
	 (Cn1==Cn2, abs(Ln1-Ln2)=<2);
	 (abs(Ln1-Ln2)=<2,abs(Ln1-Ln2)=:=abs(Cn1-Cn2)));

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, AuxCn is Cn1+3,	     Ln2 is Ln1,    random(Cn1,AuxCn,Cn2));
	 (Op_random==1, AuxCn is Cn1-3,	     Ln2 is Ln1,    random(AuxCn,Cn1,Cn2));
	 (Op_random==2,	AuxLn is Ln1+3, random(Ln1,AuxLn,Ln2),	   Cn2 is Cn1	 );
	 (Op_random==3, AuxLn is Ln1-3, random(AuxLn,Ln1,Ln2),	   Cn2 is Cn1	 );
	 (Op_random==4, AuxLn is Ln1+3, random(Ln1,AuxLn,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==5, AuxLn is Ln1+3, random(Ln1,AuxLn,Ln2), Cn2 is Ln1-Ln2+Cn1);
	 (Op_random==6, AuxLn is Ln1-3, random(AuxLn,Ln1,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==7, AuxLn is Ln1-3, random(AuxLn,Ln1,Ln2), Cn2 is Ln1-Ln2+Cn1)).

%verifica se o movimento das peca Mountedmen e valida
move_valida_mountedmen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
	(mountedmen(MountedMen), member(Peca,MountedMen), \+member(x,Caminho), \+member(t,Caminho)),
	 ((Ln1==Ln2;Cn1==Cn2);
	  (abs(Ln1-Ln2)=:=abs(Cn1-Cn2)) );

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, Ln2 is Ln1, random(1,Cn1,Cn2));
	 (Op_random==1, Ln2 is Ln1, random(Cn1,25,Cn2));
	 (Op_random==2, random(1,Ln1,Ln2), Cn2 is Cn1);
	 (Op_random==3,	random(Ln1,25,Ln2), Cn2 is Cn1);
	 (Op_random==4, random(1,Ln1,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==5, random(1,Ln1,Ln2), Cn2 is Ln1-Ln2+Cn1);
	 (Op_random==6, random(Ln1,25,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==7, random(Ln1,25,Ln2), Cn2 is Ln1-Ln2+Cn1)).


%verifica se o movimento da peca Sergeamt e valida
move_valida_sergeants(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
	(Peca==aS; Peca==bS), \+member(x,Caminho),
	((Ln1==Ln2, abs(Cn1-Cn2)=:=1);
	 (Cn1==Cn2, abs(Ln1-Ln2)=:=1);
	 (abs(Ln1-Ln2)=<12, abs(Ln1-Ln2)=:=abs(Cn1-Cn2)));

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, Ln2 is Ln1, Cn2 is Ln1+1);
	 (Op_random==1, Ln2 is Ln1, Cn2 is Ln2-1);
	 (Op_random==2,	Ln2 is Ln1+1, Cn2 is Cn1);
	 (Op_random==3, Ln2 is Ln1-1, Cn2 is Cn1);
	 (Op_random==4, AuxLn is Ln1+13, random(Ln1,AuxLn,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==5, AuxLn is Ln1+13, random(Ln1,AuxLn,Ln2), Cn2 is Ln1-Ln2+Cn1);
	 (Op_random==6, AuxLn is Ln1-13, random(AuxLn,Ln1,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==7, AuxLn is Ln1-13, random(AuxLn,Ln1,Ln2), Cn2 is Ln1-Ln2+Cn1)).


%verifica se o movimento da peca Pikemen e valida
move_valida_pikemen(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
        (Peca==ap; Peca==bp), \+member(x,Caminho),
	((Ln1==Ln2, abs(Cn1-Cn2)=<12);
	 (Cn1==Cn2, abs(Ln1-Ln2)=<12);
	 (abs(Ln1-Ln2)=:=1, abs(Cn1-Cn2)=:=1));

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, Ln2 is Ln1, AuxCn is Cn1+13, random(Cn1,AuxCn,Cn2));
	 (Op_random==1, Ln2 is Ln1, AuxCn is Cn1-13, random(AuxCn,Cn1,Cn2));
	 (Op_random==2, Cn2 is Cn1, AuxLn is Ln1+13, random(Ln1,AuxLn,Ln2));
	 (Op_random==3, Cn2 is Cn1, AuxLn is Ln1-13, random(AuxLn,Ln1,Ln2));
	 (Op_random==4, Ln2 is Ln1+1, Cn2 is Cn1+1);
	 (Op_random==5, Ln2 is Ln1+1, Cn2 is Cn1-1);
	 (Op_random==6, Ln2 is Ln1-1, Cn2 is Cn1+1);
	 (Op_random==7, Ln2 is Ln1-1, Cn2 is Cn1-1)).


%verifica se o movimento da peca Squire e valida
move_valida_squire(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
	(Peca==as; Peca==bs), \+member(x,Caminho),
	((abs(Ln1-Ln2)=:=1, abs(Cn1-Cn2)=:=2);
	 (abs(Ln1-Ln2)=:=2, abs(Cn1-Cn2)=:=1));

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, Ln2 is Ln1+1, Cn2 is Cn1+2);
	 (Op_random==1, Ln2 is Ln1+1, Cn2 is Cn1-2);
	 (Op_random==2, Ln2 is Ln1-1, Cn2 is Cn1+2);
	 (Op_random==3, Ln2 is Ln1+1, Cn2 is Cn1-2);
	 (Op_random==4, Ln2 is Ln1+2, Cn2 is Cn1+1);
	 (Op_random==5, Ln2 is Ln1+2, Cn2 is Cn1-1);
	 (Op_random==6, Ln2 is Ln1-2, Cn2 is Cn1+1);
	 (Op_random==7, Ln2 is Ln1-2, Cn2 is Cn1-1)).


%verifica se o movimento da peca Archer e valida
move_valida_archer(J,Peca,Ln1,Cn1,Ln2,Cn2,Caminho):-
	(Peca==aa; Peca==ba), \+member(x,Caminho),
	((Ln1==Ln2, abs(Cn1-Cn2)=<3);
	 (Cn1==Cn2, abs(Ln1-Ln2)=<3);
	 (abs(Ln1-Ln2)=<3, abs(Ln1-Ln2)=:=abs(Cn1-Cn2)));

        ((J==pc;J==pc1;J==pc2), Op_random is random(8),
	 (Op_random==0, AuxCn is Cn1+4,	     Ln2 is Ln1,    random(Cn1,AuxCn,Cn2));
	 (Op_random==1, AuxCn is Cn1-4,	     Ln2 is Ln1,    random(AuxCn,Cn1,Cn2));
	 (Op_random==2,	AuxLn is Ln1+4, random(Ln1,AuxLn,Ln2),	   Cn2 is Cn1	 );
	 (Op_random==3, AuxLn is Ln1-4, random(AuxLn,Ln1,Ln2),	   Cn2 is Cn1	 );
	 (Op_random==4, AuxLn is Ln1+4, random(Ln1,AuxLn,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==5, AuxLn is Ln1+4, random(Ln1,AuxLn,Ln2), Cn2 is Ln1-Ln2+Cn1);
	 (Op_random==6, AuxLn is Ln1-4, random(AuxLn,Ln1,Ln2), Cn2 is Ln2-Ln1+Cn1);
	 (Op_random==7, AuxLn is Ln1-4, random(AuxLn,Ln1,Ln2), Cn2 is Ln1-Ln2+Cn1)).


%ve se no meio caminho entre 2 posicoes tem alguma pecas, se tiver o movimento nao e valido, pois nao se pode ultrapassar outra peca
move_valida_aux([_]):-!.
move_valida_aux(Caminho):-
	pecas_J1(Pecas_J1), pecas_J2(Pecas_J2), length(Caminho,Size_Caminho),
	remove_at(Caminho,Size_Caminho,_,Meio),
	reverse(Meio,Meio2), nth(Meio2,1,Casa_Meio),
	\+member(Casa_Meio,Pecas_J1), \+member(Casa_Meio,Pecas_J2),
	move_valida_aux(Meio).


%condicao de terminacao do jogo
game_over(Tab):-
	((\+peca_esta_no_tab(aC,Tab);
	 (\+peca_esta_no_tab(aK,Tab), \+peca_esta_no_tab(aP,Tab), \+peca_esta_no_tab(aD,Tab))));
/*	 ( write('Game over, o Jogador 2 ganhou');
	   (J==pc, write('Game over, o Jogador PC ganhou'));
	   (J==pc2, write('Game over, o Jogador PC2 ganhou')))
	),nl,!;
*/
	((\+peca_esta_no_tab(bC,Tab);
	 (\+peca_esta_no_tab(bK,Tab), \+peca_esta_no_tab(bP,Tab), \+peca_esta_no_tab(bD,Tab)))).
/*	 ( write('Game over, o Jogador 1 ganhou');
	   (J==pc1, write('Game over, o Jogador PC1 ganhou'))
	 )),nl,!.
*/

%cada jogador so pode movimentar as suas pecas, mas nao pode movimentar as pecas Castle e Green
permite_mover(J,Ln,Cn,Tab):-
	pecas_J1(Pecas_J1), pecas_J2(Pecas_J2),
	get_peca_do_tab(J,Ln,Cn,Tab,Peca),
	((((J==j1;J==pc1), Peca\=aC, Peca\=aG, member(Peca,Pecas_J1)),!);
	 (((J==j2;J==pc;J==pc2), Peca\=bC, Peca\=bG, member(Peca,Pecas_J2)),!);
	 (((J==j1;J==j2),write('Casa vazia ou nao se permite mover a peca!'),nl,fail); fail)).


vez_jogador(J,Tab):-
	nl, print_tab(Tab),!,nl,write('Vez do Jogador: '), jogador(J, NJ), write(NJ),nl.


%LisV - Lista dos vizinhos, serve para restringir a peca Green so pode ser colocada ao lado da Castle, vice versa
vizinhos(J,Ln,Cn,Tab,LisV):-
	LnMais  is Ln+1,
	LnMenos is Ln-1,
	CnMais  is Cn+1,
	CnMenos is Cn-1,

	get_peca_do_tab(J,LnMais,Cn,Tab,Vbaixo),
	get_peca_do_tab(J,LnMenos,Cn,Tab,Vcima),
	get_peca_do_tab(J,Ln,CnMais,Tab,Vdirecto),
	get_peca_do_tab(J,Ln,CnMenos,Tab,Vesquerdo),

	append([Vbaixo],[Vcima],Vcn),
	append([Vdirecto],[Vesquerdo],Vln),
	append(Vcn,Vln,LisV).


%get_peca_do_tab(J,Ln,Cn,Tab,Peca)
get_peca_do_tab(_,1,Cn,[H|_],Peca):-
	nth(H,Cn,Peca),!.

get_peca_do_tab(J,Ln,Cn,[_|T],Peca):-
	Ln2 is Ln-1,
	get_peca_do_tab(J,Ln2,Cn,T,Peca), !.


%caso Vcima nao existe (Cn==0,Vesquerdo nao existe; Cn==25,Vdirecto nao existe)
get_peca_do_tab(j1,0,_,_,[]):-!.    %jogador 1  LnMenos==1

%caso Vbaixo nao existe (Cn==0,Vesquerda nao existe; Cn==25 Vdirecto nao existe)
get_peca_do_tab(j1,13,_,_,[]):-!.   %jogador 1  LnMais==13

%caso Vcima nao existe (Ln==0,Vesquerda nao existe; Ln==25,Vdirecto nao existe)
get_peca_do_tab(j2,12,_,_,[]):-!.   %jogador 2  LnMenos==12

%caoso Vbaixo nao existe (Ln==0,Vesquerda nao existe; Ln==25,Vdirecto nao existe)
get_peca_do_tab(j2,25,_,_,[]):-!.   %jogador 2  LnMais==25

%caso Vesquerdo nao existe (Ln==0,Vcima nao existe; Ln==13,Vbaixo nao existe)
get_peca_do_tab(_,_,0,_,[]):-!.		        %CnMenos==0

%caso Vdirecto nao existe (Ln==0,Vcima nao existe; Ln==13,Vbaixo nao existe)
get_peca_do_tab(_,_,25,_,[]):-!.                %CnMais==25


%verifica se a peca esta no tabuleiro
peca_esta_no_tab(Peca,Tab):-
	(   member(Sublista,Tab), member(Peca,Sublista)),!;
	fail.


random_choose([],[]):-!.
random_choose(List, Elt) :-
        length(List, Length),
        random(0, Length, Index),
        nth0(Index, List, Elt).
