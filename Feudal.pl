%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Feudal em Prolog       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Miao Sun  &  Jorge Reis   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%       Turma 3 Grupo 1       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    PLOG  MIEIC 2012/2013    %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:-use_module(library(lists)).

:-compile('Tabuleiro.pl').

start:-
	welcome,
	menu_start.

%limpa a ecra com N linhas
clear(0):-!.
clear(N):- N1 is N-1, nl, !,clear(N1).

%para o utilizador saber que simbolo corresponde que peca
print_legenda:-
	write('Legenda:'),nl,
	tab(3),write('C - Castle,   G - Green,	 K - King,    P - Prince,  D - Duke'),nl,
	tab(3),write('k - Knights,  S - Sergeants,  s - Squire,  a - Archer,  p - Pikemen'), nl,nl.

welcome:-
	write('**************************************'),nl,
	write('*                                    *'),nl,
	write('*        Bemvindo ao Feudal          *'),nl,
	write('*                                    *'),nl,
	write('**************************************'),nl,nl.

menu_start:-
	write('**************************************'),nl,
        write('*                                    *'),nl,
        write('*       Escolhe o mode do jogo:      *'),nl,
        write('*                                    *'),nl,
        write('*         1.Humano VS Humano         *'),nl,
        write('*       2.Humano VS Computador       *'),nl,
        write('*     3.Computador VS Computador     *'),nl,
        write('*                                    *'),nl,
        write('**************************************'),nl,nl,
	write('Opcao: '), faz_opcao(Op),
	comeca_jogo(Op).

comeca_jogo(Op):-    %para efeito de teste, ainda n�o est?implementado
	Op == 1, clear(50),write('\nMode: Humano contra Humano\n'),nl, estadoInicial(Tab),
	hand_J1(Hand1), hand_J2(Hand2),
	insere_peca(j1,Hand1,Tab,Tab1),!, clear(50), insere_peca(j2,Hand2,Tab1,Tab2),
	%funcionou at� aqui, 2 jogadores inserir todas as sua pecas, falta determinar o Green so pode colocar ao lado do Castle.

	jogador_jogador(Tab2,j1),!;

	Op == 2, write('\nMode: Humano contra Computador\n'),nl, menu_nivel,!;
	Op == 3, write('\nMode: Computador contra Computador\n'),nl, menu_nivel.


%funcao so serve no inicio do jogo,permite jogador inserir todas as pecas no tabuleiro Tab, e guarda �ltimo
%estado do tabuleiro no Tabf.
insere_peca(_,[],Tab,Tab):-!.
insere_peca(J,Hand,Tab,Tabf):-
        vez_jogador(Tab, J),
	tab(8),write(': insere todas as suas pecas no seu reino!'),nl,nl,
	print_legenda,

	length(Hand, HandSize),

	write('Player '), write(J), write(' hand: '), printList(Hand),nl,nl,
	write('Escolhe uma peca:'),nl,
	mostra_hand(Hand,1),nl,
	write('Peca: '),
	read(P),
	(   (integer(P), P>0, P=<HandSize) ->
	(   !, remove_at(Hand,P,Peca,Hand2));
	(   write('Opcao invalida, tenta novamente!'),
	    nl,nl,sleep(1),insere_peca(J,Hand,Tab,Tab1))),nl,

	repeat,
	(   (repeat, (write('Linha: '), read(Ln), linha_valida(J,Ln))),
	    (write('Coluna: '), read(Cn), coluna_valida(J,Cn)),
	    colocacao_valida(J,Peca,Ln,Cn,Tab)
	),

	insere_peca_no_tab(Peca,Ln,Cn,Tab,Tab1), insere_peca(J,Hand2,Tab1,Tabf).


%verifica se a colocacao da peca e valida, se a peca for C-Castle ou
%G-Green, permite colocar em qualquer casa do seu reino, outras pecas so
%podem ser colocadas em casa "vazia"
colocacao_valida(J,Peca,Ln,Cn,Tab):-
	nth(Tab,Ln,LElm),
	nth(LElm,Cn,Casa),
/*	vizinhos(J,Tab,Ln,Cn,LisV),
	member(Linhas,Tab),

	(   J==j1,
	    (Peca==aC,
	     \+member(aG,Linhas) -> true;
	     member(aG,LisV) -> true;
	    (Peca==aG, \+member(aC,Linhas) -> true;
	     member(aC,LisV) -> true));

	    (Peca\=aC, Peca\=aG, Casa==0) -> true
	),!;
*/  %porque nao esta a funcionar o codigo de cima?????????????????????????????????????????????

	(   J==j1,
	    (Peca==aC; Peca==aG) -> true;
	    (Peca\=aC, Peca\=aG, Casa==0) -> true
	),!;

	(   J==j2,
	    (Peca==bC; Peca==bG) -> true;
	    (Peca\=bC, Peca\=bG, Casa==0) -> true
	),!;

	write('Jogada nao valida, tenta novamente!'),!,nl,fail.




nth([H|_],1,H):-!.
nth([_|T],N,X):-
	I is N-1, nth(T,I,X).


%insere peca no tabuleiro na determinada posicao
insere_peca_no_tab(Peca,1,Cn,[H|T],[H2|T]):-
	procede_colocacao(Peca,Cn,H,H2),!.

insere_peca_no_tab(Peca,Ln,Cn,[H|T],[H|T2]):-
	Ln1 is Ln-1,
	insere_peca_no_tab(Peca,Ln1,Cn,T,T2).

%funcao auxiliar
procede_colocacao(Peca,1,[_|T],[Peca|T]):-!.
procede_colocacao(Peca,N,[H|T],[H|T2]):-
	N1 is N-1,
	procede_colocacao(Peca,N1,T,T2).


%mostra todas as pecas o jogador tem no momento
mostra_hand([],_):-!.
mostra_hand([H|T],N):-
	N1 is N+1,
	write(N),
	write(': '),
	draw_casa(H),
	write(' | '),
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

/*
%LisV - Lista dos vinhos
vizinhos(J,Tab,Ln,Cn,LisV):-

	LnMais  is Ln+1,
	LnMenos is Ln-1,
	CnMais  is Cn+1,
	CnMenos is Cn-1,

	get_peca_do_tab(J,LnMais,Cn,Tab,Vbaixo),
	get_peca_do_tab(J,LnMenos,Cn,Tab,Vcima),
	get_peca_do_tab(J,Ln,CnMais,Tab,Vdirecto),
	get_peca_do_tab(J,Ln,CnMenos,Tab,Vesquerdo),

	append(Vbaixo,Vcima,Vcn),
	append(Vdirecto,Vesquerdo,Vln),
	append(Vcn,Vln,LisV).


%get_peca_do_tab(J,Ln,Cn,Tab,Peca)
get_peca_do_tab(/*_,*/1,Cn,[H|_],Peca):-
	nth(H,Cn,Peca),!.

get_peca_do_tab(/*J,*/Ln,Cn,[_|T],Peca):-
	Ln2 is Ln-1,
	get_peca_do_tab(/*J,*/Ln2,Cn,T,Peca).


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
*/



%remover a peca da lista com indice N, devolve a Peca e a lista final
remove_at([Peca|Xs],1,Peca,Xs):-!.
remove_at([Y|Xs],N,Peca,[Y|Ys]) :- N > 1,
   N1 is N - 1, remove_at(Xs,N1,Peca,Ys).


coluna_valida(_,Cn):-
	Cn>=1, Cn=<24,!;
	write('Coluna invalida, tenta novamente!'),nl,fail.

linha_valida(NJ,Ln):-
	(   NJ == j1, Ln>=1,  Ln=<12),!;
	(   NJ == j2, Ln>=13, Ln=<24),!;
	write('Linha invalida, tenta novamente!'),nl,fail.  %funciona


%remove_peca(J,Peca,X,Y,Tab,Tab2).



jogador_jogador(Tab, ActJ):-
	vez_jogador(Tab,ActJ),nl,nl .


vez_jogador(Tab,J):-
	nl, print_tab(Tab),!,nl,write('Vez do Jagador: '), jogador(J, NJ), write(NJ),nl.

%funcao auxiliar para verificar se a opcao do utilizador e valida
opcao_invalida(Op):-
	Op \== 1, Op \== 2, Op \== 3.

%procede a opcao do utilizador
faz_opcao(Op):-
	read(Op),
	\+opcao_invalida(Op),!;
	writeln('opcao invalida, tenta novamente'), write('Opcao: '), faz_opcao(Op),!.



lista([1,2,3,4,5]).
test:-
	lista(Lis),
	vez(1,Lis).

vez(_,[]):-write('acabou'),!.
vez(N,Lis):-
	remove_at(Lis,1,_,Lis2),
	(   N==1, N1 is N-1);
	(   N==0, N1 is N+1);
	write(Lis2),nl,write(N1),nl,
	vez(N1,Lis2).







