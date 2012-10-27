
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
hand_J1([aC,aG,aK,aP,aD, ak,ak,aS,aS,as,aa,ap,ap,ap,ap]).
hand_J2([bC,bG,bK,bP,bD, bk,bk,bS,bS,bs,ba,bp,bp,bp,bp]).


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
print_tab(Tab):-
	         write('    1  2  3  4  5  6  7  8  9  10 11 12	13 14 15 16 17 18 19 20 21 22 23 24'),nl,
		 printLists(Tab,1),
		 write('    1  2  3  4  5  6  7  8  9  10 11 12	13 14 15 16 17 18 19 20 21 22 23 24'),nl,nl.

%desenhar o limite do tabuleiro
lim:- write('   +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+'),nl.


%%imprime a lista inteira
printLists([],_):-lim, !.
printLists([FList|OList],N):- lim,
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
	write('Opcao: '), faz_opcao(_Op),!.
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
