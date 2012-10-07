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
% ac - Castle    x1
% ag - Green     x1
% a1 - King      x1
% a2 - Prince    x1
% a3 - Duke      x1
% a4 - Knights   x2
% a5 - Sergeants x2
% a6 - Squire    x1
% a7 - Archer    x1
% a8 - Pikemen   x4

%%%Jogador 2
% bc - Castle    x1
% bg - Green     x1
% b1 - King      x1
% b2 - Prince    x1
% b3 - Duke      x1
% b4 - Knights   x2
% b5 - Sergeants x2
% b6 - Squire    x1
% b7 - Archer    x1
% b8 - Pikemen   x4


mountedmen([2,3,4,4]).
footmen([1,5,5,6,7,8,8,8,8]).

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
print_tab(Tab):- writeln('    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X '),
		 printLists(Tab,1),
		 writeln('    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X '),nl.

%desenhar o limite do tabuleiro
lim:- writeln('   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+').


%%imprime a lista inteira
printLists([],_):-lim, !.
printLists([FList|OList],N):-
                        lim,
		        N < 10, write(' '), write(N), write(' |'),
			printList(FList),
			N2 is N+1, write(' '), writeln(N),
                        printLists(OList,N2),!;

			N> 9, write(N), write(' |'),
                        printList(FList),
			N2 is N+1, write(' '), writeln(N),
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
	Elem == ac, write('1C');
	Elem == ag, write('1G');
	Elem == a1, write('1K');
	Elem == a2, write('1P');
	Elem == a3, write('1D');
	Elem == a4, write('1k');
	Elem == a5, write('1S');
	Elem == a6, write('1s');
	Elem == a7, write('1A');
	Elem == a8, write('1p');
	Elem == bc, write('2C');
	Elem == bg, write('2G');
	Elem == b1, write('2K');
	Elem == b2, write('2P');
	Elem == b3, write('2D');
	Elem == b4, write('2k');
	Elem == b5, write('2S');
	Elem == b6, write('2s');
	Elem == b7, write('2A');
	Elem == b8, write('2p').


start:-
	welcome, show,
	menu_start.


welcome:-
	writeln('**********************************'),
	writeln('*                                *'),
	writeln('*      Bemvindo ao Feudal        *'),
	writeln('*                                *'),
	writeln('**********************************'),nl.

menu_start:-
	writeln('**********************************'),
        writeln('*                                *'),
        writeln('*     Escolhe o mode do jogo:    *'),
        writeln('*                                *'),
        writeln('*       1.Humano VS Humano       *'),
        writeln('*     2.Humano VS Computador     *'),
        writeln('*   3.Computador VS Computador   *'),
        writeln('*                                *'),
        writeln('**********************************'),nl,
	write('faca a sua escolha: '), faz_opcao(Op),
	%tipo_jogo(Op, J1, J2),
	write(Op), integer(Op),writeln(' um numero'),
	comeca_jogo(Op).

comeca_jogo(Op):-    %para efeito de teste, ainda não está implementado
	Op == 1, writeln('humano contra humano');
	Op == 2, writeln('humano contra computador'), menu_nivel;
	Op == 3, writeln('computador contra computador'), menu_nivel.

/*
insere_peca(J,Peca,X,Y,Tab,Tab2).
remove_peca(J,Peca,X,Y,Tab,Tab2).
*/

/*
tipo_jogo(1,humano,humano).
tipo_jogo(2,humano,computador).
tipo_jogo(3,computador,computador).
*/

%funcao auxiliar para verificar se a opção do utilizador é valido
opcao_invalida(Op):-
	Op \== 1, Op \== 2, Op \== 3.

%procede a opção do utilizador
faz_opcao(Op):-
	read(Op),
	not(opcao_invalida(Op)),!;
	writeln('opcao invalida'), write('faca a sua escolha: '), faz_opcao(Op).


menu_nivel:-
	writeln('**********************************'),
        writeln('*                                *'),
        writeln('*         Nivel do Jogo          *'),
        writeln('*                                *'),
        writeln('*            1.Easy              *'),
        writeln('*           2.Normal             *'),
        writeln('*            3.Hard              *'),
        writeln('*                                *'),
        writeln('**********************************'),nl,
	write('faca a sua escolha: '), faz_opcao(Op),
	write(Op), integer(Op),writeln(' um numero').


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
             [0,0,0,t,0,a2,t,x,a7,0,0,0,0,0,0,0,x,x,x,0,x,t,0,x],
             [0,0,0,x,0,a1,ag,ac,x,0,0,0,0,0,0,0,0,0,0,x,0,0,0,0],
             [0,0,0,0,0,a3,0,x,x,a8,0,0,0,0,0,0,x,0,0,x,x,0,0,0],
             [0,0,0,0,0,0,x,x,0,a4,a5,0,a8,a8,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,x,0,0,a4,a5,0,a8,x,x,0,0,0,0,0,0,0,0,0],
             [0,x,0,0,x,t,0,0,0,x,0,a6,0,0,x,x,t,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,x,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,x,0,0,0,t,x,0,0,t,x,x,0,0,0],
             [0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,b8,b8,b8,b6,0,x,0,0,0],
             [0,0,0,0,x,x,0,0,0,0,0,0,0,0,0,0,b5,b4,b8,b7,0,0,0,0],
             [t,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,b4,x,x,t,b1,0,0,0],
             [x,x,0,0,0,x,x,0,0,0,0,0,0,0,0,0,b5,x,bg,bc,b2,0,0,0],
             [0,0,0,0,0,t,x,0,0,0,0,0,0,0,0,x,x,x,x,0,b3,0,0,0],
             [0,0,0,0,0,x,0,x,0,0,x,0,0,x,0,0,0,t,0,0,0,0,0,x],
             [0,0,0,0,x,x,0,0,0,x,x,0,0,t,0,0,x,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
             [x,0,0,0,0,t,x,0,0,0,0,0,0,0,0,0,0,x,x,0,0,0,0,x]]).
