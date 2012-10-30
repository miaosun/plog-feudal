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
	Op == 1, clear(50),write('\nMode: Humano contra Humano\n'),nl,
	estadoInicial(Tab),pecas_J1(Hand1), pecas_J2(Hand2),
	insere_todas_peca(j1,Hand1,Tab,Tab1),!, clear(50), insere_todas_peca(j2,Hand2,Tab1,Tab2),
	%funcionou at� aqui, 2 jogadores inserir todas as sua pecas, falta determinar o Green so pode colocar ao lado do Castle.

	%estadoTeste(Tab2),
	jogador_jogador(j1,Tab2),!;

	Op == 2, write('\nMode: Humano contra Computador\n'),nl, menu_nivel,!;
	Op == 3, write('\nMode: Computador contra Computador\n'),nl, menu_nivel.


%funcao so serve no inicio do jogo,permite jogador inserir todas as pecas no tabuleiro Tab, e guarda �ltimo
%estado do tabuleiro no Tabf.
insere_todas_peca(_,[],Tab,Tab):-!.
insere_todas_peca(J,Hand,Tab,Tabf):-
        vez_jogador(J,Tab),
	tab(8),write(': insere todas as suas pecas no seu reino!'),nl,nl,
	print_legenda,

	length(Hand, HandSize),
        jogador(J,NJ),

	write('Player '), write(NJ), write(' hand: '), printList(Hand),nl,nl,
	write('Escolhe uma peca:'),nl,
	mostra_hand(Hand,1),nl,
	write('Peca: '),
	read(P),
	(
	 (integer(P), P>0, P=<HandSize) -> (!, remove_at(Hand,P,Peca,Hand2));
	 (write('Opcao invalida, tenta novamente!'),
	 nl,nl,sleep(1),insere_todas_peca(J,Hand,Tab,Tab1))
	),nl,

	repeat,
	(   (repeat, (write('Linha: '), read(Ln), linha_valida(J,Ln))),
	    (write('Coluna: '), read(Cn), coluna_valida(J,Cn)),
	    colocacao_valida(J,Peca,Ln,Cn,Tab)
	),

	insere_peca_no_tab(Peca,Ln,Cn,Tab,Tab1), insere_todas_peca(J,Hand2,Tab1,Tabf).


%verifica se a colocacao da peca e valida, se a peca for C-Castle ou
%G-Green, permite colocar em qualquer casa do seu reino, outras pecas so
%podem ser colocadas em casa "vazia"
colocacao_valida(J,Peca,Ln,Cn,Tab):-
	nth(Tab,Ln,LElm),
	nth(LElm,Cn,Casa),
	vizinhos(J,Ln,Cn,Tab,LisV),
	write(LisV),write(' teste0 '),write(J),

	(
	 (   J==j1,
	    (
	     (Peca==aC,
	      (\+get_peca_do_tab(j1,Ln,Cn,Tab,aG), \+peca_esta_no_tab(aG,Tab));
	       member(aG,LisV)
	     );
	     (Peca==aG,
	      (\+get_peca_do_tab(j1,Ln,Cn,Tab,aC), \+peca_esta_no_tab(aC,Tab));
	      member(aC,LisV)
	     );

	    (Peca\=aC, Peca\=aG, Casa==0) )
	 ),!;

	(   J==j2,
            (
	     (Peca==bC,
	      (\+get_peca_do_tab(j2,Ln,Cn,Tab,bG), \+peca_esta_no_tab(bG,Tab));
	      (write('hello | '),write(LisV), write(' | '), member(bG,LisV),write(LisV),write(' teste2 '))
	     );
	     (Peca==bG,
	      (\+get_peca_do_tab(j2,Ln,Cn,Tab,bC), \+peca_esta_no_tab(bC,Tab),write(' teste3 '));
	       member(bC,LisV)
	    );

	    (Peca\=bC, Peca\=bG, Casa==0),write(' teste5 '))
	),!;

	 (write('Jogada nao valida, tenta novamente!'),!,nl,fail)
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



%remover a peca da lista com indice N, devolve a Peca e a lista final
remove_at([Peca|Xs],1,Peca,Xs):-!.
remove_at([Y|Xs],N,Peca,[Y|Ys]) :- N > 1,
   N1 is N - 1, remove_at(Xs,N1,Peca,Ys).


coluna_valida(_,Cn):-
	Cn>=1, Cn=<24,!;
	write('Coluna invalida, tenta novamente!'),nl,fail.

linha_valida(J,Ln):-
	(   J == j1, Ln>=1,  Ln=<12),!;
	(   J == j2, Ln>=13, Ln=<24),!;
	write('Linha invalida, tenta novamente!'),nl,fail.




jogador_jogador(J,Tab):-
	vez_jogador(J,Tab),nl,
	%(   game_over(Tab), write('Obrigado por jogar!'),nl);


	print_legenda,
	jogar(J,Tab).

/*	write('Escolhe a posicao da Peca pretende mover'),nl,
        repeat,
	(   (repeat, (write('Linha: '), read(Ln))),
	    (write('Coluna: '), read(Cn), permite_mover(J,Ln,Cn,Tab,Peca)

	)),write(Peca),write(ok),

        write('Escolhe a posicao do destino'),nl,
        repeat,
	(   (repeat, (write('Linha: '), read(Ln))),
	    (write('Coluna: '), read(Cn), write(hello) %jogada_valida()

	)),write(final).
*/


jogar(J,Tab):-

	write('Escolhe a posicao da Peca pretende mover'),nl,
        repeat,
	(   (repeat, (write('Linha: '), read(Ln1))),
	    (write('Coluna: '), read(Cn1), permite_mover(J,Ln1,Cn1,Tab,Peca),!

	)),nl,nl,

        write('Escolhe a posicao do destino'),nl,

        write('Linha: '), read(Ln2),
	write('Coluna: '), read(Cn2),

	jogada_valida(Peca,Ln1,Cn1,Ln2,Cn2,Tab),nl,
	jogar(J,Tab).


jogada_valida(Peca,Ln1,Cn1,Ln2,Cn2,Tab):-
	(Ln1\=Ln2; Cn1\=Cn2),
	write('funcina ate aqui.'),nl.

move_valida_king(Peca,Ln1,Cn1,Ln2,Cn2):-
	(Peca==aK; Peca==bK),
	(      %%%%%falta mountanha e torreino
	 (Ln1==Ln2, abs(Cn1-Cn2)=<2);
	 (Cn1==Cn2, abs(Ln1-Ln2)=<2);
	 (abs(Ln1-Ln2)=<2,abs(Ln1-Ln2)=:=abs(Cn1-Cn2))
	).


% VALIDAR QUE NAO PASSA POR MONTANHAS OU TERRENO

move_valida_mountedmen(Peca,Ln1,Cn1,Ln2,Cn2):-
	mountedmen(MountedMen), member(Peca,MountedMen),
	(  %%%%falta mountanha e torreino
	 (Ln1==Ln2;Cn1==Cn2);
	 (abs(Ln1-Ln2)=:=abs(Cn1-Cn2))
	).


move_valida_sergeants(Peca,Ln1,Cn1,Ln2,Cn2):-
	(Peca==aS; peca==bS),
	 (  %%%%%falta mountanha e terreno
	  (Ln1==Ln2, abs(Cn1-Cn2)=:=1);
	  (Cn1==Cn2, abs(Ln1-Ln2)=:=1);
	  (abs(Ln1-Ln2)=<12, abs(Ln1-Ln2)=:=abs(Cn1-Cn2))
	 ).


move_valida_pikemen(Peca,Ln1,Cn1,Ln2,Cn2):-
        (Peca==ap; Peca==bp),
	 (   %%%%%falta mountanha e torreino
	  (Ln1==Ln2, abs(Cn1-Cn2)=<12);
	  (Cn1==Cn2, abs(Ln1-Ln2)=<12);
	  (abs(Ln1-Ln2)=:=1, abs(Cn1-Cn2)=:=1)
         ).


move_valida_squire(Peca,Ln1,Cn1,Ln2,Cn2):-
	(Peca==as; Peca==bs),
	 (  %%%%%%falta mountanha e torreino
	  (abs(Ln1-Ln2)=:=1, abs(Cn1-Cn2)=:=2);
	  (abs(Ln1-Ln2)=:=2, abs(Cn1-Cn2)=:=1)
	 ).


move_valida_archer(Peca,Ln1,Cn1,Ln2,Cn2):-
	(Peca==aa; Peca==ba),
	 (  %%%%%falta mountanha e torreino, e caso de shoot enemy
	  (Ln1==Ln2, abs(Cn1-Cn2)=<3);
	  (Cn1==Cn2, abs(Ln1-Ln2)=<3);
	  (abs(Ln1-Ln2)=<3, abs(Ln1-Ln2)=:=abs(Cn1-Cn2))
	 ).


mover_mais_pecas(0):-!.
mover_mais_pecas(N):-
	N>1, N<14,
	write('Pretende mover mais Pecas? (1: Sim | 2: Nao)'),nl,
	read(Op),
	(   integer(Op),Op==1 -> true;
	Op==2 -> N is 0;
	write('Opcao invalida, tenta novamente!'),nl,
	mover_mais_pecas(N)).


/*

game_over(Tab):-
	member(Linhas,Tab),
	((   \+peca_esta_no_tab(aC,Tab),write(test1);
	 (   \+peca_esta_no_tab(aK,Tab), \+peca_esta_no_tab(aP,Tab), \+peca_esta_no_tab(aD,Tab))
	), write('Game over, o Jogador 2 ganhou')),nl,!;

	member(Linhas,Tab),
	((   \+peca_esta_no_tab(bC,Tab),write(test1);
	 (   \+peca_esta_no_tab(bK,Tab), peca_esta_no_tab(bP,Tab), peca_esta_no_tab(bD,Tab))
	), write('Game over, o Jogador 1 ganhou')),nl,!.
*/
%member(Linhas,Tab),member(Peca,Linhas) nao funciona!!




permite_mover(J,Ln,Cn,Tab,Peca):-
	pecas_J1(Pecas_J1),
	pecas_J2(Pecas_J2),
	get_peca_do_tab(J,Ln,Cn,Tab,Peca),
	(   J==j1, Peca\=aC, Peca\=aG, member(Peca,Pecas_J1)),!;
	(   J==j2, Peca\=bC, Peca\=bG, member(Peca,Pecas_J2)),!;
	write('Casa vazia ou nao se permite mover a peca!'),nl,fail.







vez_jogador(J,Tab):-
	nl, print_tab(Tab),!,nl,write('Vez do Jagador: '), jogador(J, NJ), write(NJ),nl.

%funcao auxiliar para verificar se a opcao do utilizador e valida
opcao_invalida(Op):-
	Op \== 1, Op \== 2, Op \== 3.

%procede a opcao do utilizador
faz_opcao(Op):-
	read(Op),
	\+opcao_invalida(Op),!;
	writeln('opcao invalida, tenta novamente'), write('Opcao: '), faz_opcao(Op),!.



%LisV - Lista dos vizinhos
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





lista([1,2,3,4,5]).
test:-
	lista(Lis),
	vez(1,Lis).

vez(_,[]):-write('acabou'),!.
vez(N,Lis):-
	remove_at(Lis,1,_,Lis2),
	(
	 (N==1, N1 is N-1);
	 (N==0, N1 is N+1)
	),!,
	write(Lis2),nl,write(N1),nl,
	vez(N1,Lis2).



