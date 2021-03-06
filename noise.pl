:- dynamic(edge/3).

noise(File) :-
	open(File, read, In),
	readheader(In, C, S, Q),
	process_task(In, C, S, Q, 1),
	close(In).

process_task(_, 0, 0, 0, _) :- !. 
process_task(In, C, S, Q, Case) :- 
	write('Case #'),write(Case),write('\n'),
	readstreets(In, S),
	readqueries(In, Q),
	retractall(edge(_, _, _)),
	readheader(In, C1, S1, Q1),
	Case1 is Case+1,
	write('\n'),
	process_task(In, C1, S1, Q1, Case1).

readheader(In, C, S, Q) :-
	readnumber(In, C),
	readnumber(In, S),
	readnumber(In, Q).

readstreets(_, 0) :- !.
readstreets(In, S) :-
	readnumber(In, C1),
	readnumber(In, C2),
	readnumber(In, DCB),
	assert(edge(C1, C2, DCB)),
	Minus is S-1,
	readstreets(In, Minus).

readqueries(_, 0) :- !.
readqueries(In, Q) :-
	readnumber(In, C1),
	readnumber(In, C2),
	query(C1, C2),
	Minus is Q-1,
	readqueries(In, Minus).

query(C1, C2) :-
	shortest(C1, C2, _, Noise), write(Noise), write('\n') ; 
	write('No path'), write('\n').

readnumber(In, N) :-
	get_char(In, C),
	readnumber(In, C, N1),
	atom_number(N1, N).

readnumber(_, ' ', '') :- !.
readnumber(_, '\n', '') :- !.
readnumber(In, C, Res) :-
	get_char(In, C1),
	readnumber(In, C1, Next),
	atom_concat(C, Next, Res).


/************************

	ALGORITMUS

************************/

connected(X,Y,L) :- edge(X,Y,L) ; edge(Y,X,L).

path(A,B,Path,Len) :-
       travel(A,B,[A],Q,Len), 
       reverse(Q,Path).

assignmax(X,Y,X) :- X>=Y.
assignmax(X,Y,Y) :- X<Y.

travel(A,B,P,[B|P],L) :- 
       connected(A,B,L).
travel(A,B,Visited,Path,L) :-
       connected(A,C,D),           
       C \== B,
       \+member(C,Visited),
       travel(C,B,[C|Visited],Path,L1),
       assignmax(D,L1,L).  

shortest(A,B,Path,Length) :-
   setof([P,L],path(A,B,P,L),Set),
   Set = [_|_], % fail if empty
   minimal(Set,[Path,Length]).

minimal([F|R],M) :- min(R,F,M).

% minimal path
min([],M,M).
min([[P,L]|R],[_,M],Min) :- L < M, !, min(R,[P,L],Min). 
min([_|R],M,Min) :- min(R,M,Min).

