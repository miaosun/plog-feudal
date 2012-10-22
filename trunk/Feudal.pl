%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Feudal em Prolog       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Miao Sun  &  Jorge Reis   %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%       Turma 3 Grupo 1       %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%    PLOG  MIEIC 2012/2013    %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-use_module(library(lists)).

% x - Mountains
% t - rough terrain
% 0 - vazia

%%%%%%%%%% Peças do jogo
%%%Jogador 1
% aC - Castle    x1
% aG - Green     x1
% aK - King      x1
% aP - Prince    x1
% aD - Duke      x1
% ak - Knights   x2
% aS - Sergeants x2
% as - Squire    x1
% aa - Archer    x1
% ap - Pikemen   x4

%%%Jogador 2
% bC - Castle    x1
% bG - Green     x1
% bK - King      x1
% bP - Prince    x1
% bD - Duke      x1
% bK - Knights   x2
% bS - Sergeants x2
% bs - Squire    x1
% ba - Archer    x1
% bp - Pikemen   x4


mountedmen([aP,aD,ak, bP,bD,bk]).
footmen([aK,aS,as,aa,ap, bK,bS,bs,ba,bp]).
peca_J1([aC,aG,aK,aP,aD, ak,ak,aS,aS,as,aa,ap,ap,ap,ap]).
peca_J2([bC,bG,bK,bP,bD, bk,bk,bS,bS,bs,ba,bp,bp,bp,bp]).


jogador(j1,1).
jogador(j2,2).


%%%%%%%%  Estado inicial  %%%%%%%%
estadoInicial([[x,0,0,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,0,0,x],
               [0,0,0,0,0,0,0,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [t,0,0,0,0,0,0,0,0,0,x,0,0,0,0,t,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,x,0,0,0,x,0,0,0,t,0,0,0,0,0,x,0,0,x],
               [0,0,0,t,0,0,t,x,0,0,0,0,0,0,0,0,x,x,x,0,x,t,0,x],
               [0,0,0,x,0,0,0,0,x,0,0,0,0,0,0,0,0,0,0,x,0,0,0,0],
               [0,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,x,0,0,x,x,0,0,0],
               [0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,x,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0],
               [0,x,0,0,x,t,0,0,0,x,0,0,0,0,x,x,t,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,x,0,0,0,t,x,0,0,t,x,x,0,0,0],
               [0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0,x,0,0,0],
               [0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [t,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,x,x,t,0,0,0,0],
               [x,x,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,x,0,0,0,0,0,0],
               [0,0,0,0,0,t,x,0,0,0,0,0,0,0,0,x,x,x,x,0,0,0,0,0],
               [0,0,0,0,0,x,0,x,0,0,x,0,0,x,0,0,0,t,0,0,0,0,0,x],
               [0,0,0,0,x,x,0,0,0,x,x,0,0,t,0,0,x,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
               [x,0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,0,x,x,0,0,0,0,x]]).


show:- estadoInicial(X), print_tab(X).  %mostra tabuleiro do estado inicial
show2:-estadoTeste(X), print_tab(X).	%mostra tabuleiro do estado teste com todas as peças colocadas no tabuleiro

%mostra o tabuleiro e as coordenadas respectivemente
print_tab(Tab):- write('    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X '),nl,
		 printLists(Tab,1),
		 write('    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X '),nl,nl.

%desenhar o limite do tabuleiro
lim:- write('   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+'),nl.


%%imprime a lista inteira
printLists([],_):-lim, !.
printLists([FList|OList],N):-
                        lim,
		        N < 10, write(' '), write(N), write(' |'),
			printList(FList),
			N2 is N+1, write(' '), write(N),nl,
                        printLists(OList,N2),!;

			N> 9, write(N), write(' |'),
                        printList(FList),
			N2 is N+1, write(' '), write(N),nl,
                        printLists(OList,N2).


%imprime todos os elementos de cada sublista
printList([]).
printList([FElem|OElem]):-
                        write(''), draw_casa(FElem), write('|'),
                        printList(OElem).

draw_casa(Elem):-  %desenha a casa com os valores respectivmente
	Elem == 0,  write('  ');
	Elem == x,  write('##');
	Elem == t,  write('**');
	Elem == aC, write('1C');
	Elem == aG, write('1G');
	Elem == aK, write('1K');
	Elem == aP, write('1P');
	Elem == aD, write('1D');
	Elem == ak, write('1k');
	Elem == aS, write('1S');
	Elem == as, write('1s');
	Elem == aa, write('1a');
	Elem == ap, write('1p');
	Elem == bC, write('2C');
	Elem == bG, write('2G');
	Elem == bK, write('2K');
	Elem == bP, write('2P');
	Elem == bD, write('2D');
	Elem == bk, write('2k');
	Elem == bS, write('2S');
	Elem == bs, write('2s');
	Elem == ba, write('2a');
	Elem == bp, write('2p').


start:-
	welcome, show,
	menu_start.


welcome:-
	write('**********************************'),nl,
	write('*                                *'),nl,
	write('*      Bemvindo ao Feudal        *'),nl,
	write('*                                *'),nl,
	write('**********************************'),nl,nl.

menu_start:-
	write('**********************************'),nl,
        write('*                                *'),nl,
        write('*     Escolhe o mode do jogo:    *'),nl,
        write('*                                *'),nl,
        write('*       1.Humano VS Humano       *'),nl,
        write('*     2.Humano VS Computador     *'),nl,
        write('*   3.Computador VS Computador   *'),nl,
        write('*                                *'),nl,
        write('**********************************'),nl,nl,
	write('faca a sua escolha: '), faz_opcao(Op),
	tipo_jogo(Op, _J1, _J2).
	%comeca_jogo(Op).

/*comeca_jogo(Op):-    %para efeito de teste, ainda não está implementado
	Op == 1, writeln('humano contra humano');
	Op == 2, writeln('humano contra computador'), menu_nivel;
	Op == 3, writeln('computador contra computador'), menu_nivel.
*/

/*
insere_peca(J,Peca,X,Y,Tab,Tab2)
remove_peca(J,Peca,X,Y,Tab,Tab2).
*/


tipo_jogo(1,humano,humano):- write('\nMode: Humano contra Humano\n'),nl.
tipo_jogo(2,humano,computador):- write('\nMode: Humano contra Computador\n'),nl, menu_nivel.
tipo_jogo(3,computador,computador):- write('\nMode: Computador contra Computador\n'),nl, menu_nivel.


%funcao auxiliar para verificar se a opção do utilizador é valido
opcao_invalida(Op):-
	Op \== 1, Op \== 2, Op \== 3.

%procede a opção do utilizador
faz_opcao(Op):-
	read(Op),
	\+opcao_invalida(Op),!;
	writeln('opcao invalida'), write('faca a sua escolha: '), faz_opcao(Op).


menu_nivel:-
	write('**********************************'),nl,
        write('*                                *'),nl,
        write('*         Nivel do Jogo          *'),nl,
        write('*                                *'),nl,
        write('*            1.Easy              *'),nl,
        write('*           2.Normal             *'),nl,
        write('*            3.Hard              *'),nl,
        write('*                                *'),nl,
        write('**********************************'),nl,nl,
	write('faca a sua escolha: '), faz_opcao(_Op).
	%write(Op), integer(Op),writeln(' um numero').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% estado para testar visualização do tabuleiro %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%para efeito de teste da visulização do tabuleiro com todas as peças
%%colocadas no tabuleiro.

estadoTeste([[x,0,0,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,0,0,x],
	     [0,0,0,0,0,0,0,0,0,0,0,0,0,x,x,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [t,0,0,0,0,0,0,0,0,0,x,0,0,0,0,t,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,x,0,0,0,x,0,0,0,t,0,0,0,0,0,x,0,0,x],
             [0,0,0,t,0,aP,t,x,aa,0,0,0,0,0,0,0,x,x,x,0,x,t,0,x],
             [0,0,0,x,0,aK,aG,aC,x,0,0,0,0,0,0,0,0,0,0,x,0,0,0,0],
             [0,0,0,0,0,aD,0,x,x,ap,0,0,0,0,0,0,x,0,0,x,x,0,0,0],
             [0,0,0,0,0,0,x,x,0,ak,aS,0,ap,ap,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,x,0,0,ak,aS,0,ap,x,x,0,0,0,0,0,0,0,0,0],
             [0,x,0,0,x,t,0,0,0,x,0,as,0,0,x,x,t,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,x,0,0,0,t,x,0,0,t,x,x,0,0,0],
             [0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,bp,bp,bp,bs,0,x,0,0,0],
             [0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,bS,bk,bp,ba,0,0,0,0],
             [t,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,bk,x,x,t,bK,0,0,0],
             [x,x,0,0,0,x,x,0,0,0,0,0,0,0,0,0,bS,x,bG,bC,bP,0,0,0],
             [0,0,0,0,0,t,x,0,0,0,0,0,0,0,0,x,x,x,x,0,bD,0,0,0],
             [0,0,0,0,0,x,0,x,0,0,x,0,0,x,0,0,0,t,0,0,0,0,0,x],
             [0,0,0,0,x,x,0,0,0,x,x,0,0,t,0,0,x,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [x,0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,0,x,x,0,0,0,0,x]]).
