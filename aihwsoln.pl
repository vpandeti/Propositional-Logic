% Water and Zebra problem
%------------------------
%1. The Englishman lives in the red house.
%2. The Spaniard owns a dog.
%3. The Norwegian lives in the first house
%4. Kools are smoked in the yellow house.
%5. Chesterfields are smoked next to where the fox is kept.
%6. The Norwegian lives next to the blue house.
%7. The Old Gold Smoker owns snails
%8. The Lucky Strike smoker drinks orange juice
%9. The Ukrainian drinks tea
%10. The Japanese smokes Parliaments
%11. The Kools smoker lives next to where the house is kept
%12. Coffee is drunk in the green house
%13. The green house is to the immediate right of the ivory house
%14. Milk is drunk in the middle house

water_and_zebra(X) :- 
	nl,
	start(X),
	whos_pet_zebra(X),
	who_drinks_water(X).
	
whos_pet_zebra([]).
whos_pet_zebra([[_,_,N,_,P]|T]) :- 
	P == 'zebra' -> write(N), 
	write(' owns zebra'), 
	nl, 
	nl; 
	whos_pet_zebra(T).

who_drinks_water([]).
who_drinks_water([[_,D,N,_,_]|T]) :- 
	D == 'water' -> write(N), 
	write(' drinks water'), 
	nl, 
	nl; 
	who_drinks_water(T).

member(Hs, [H|T]) :- 
	Hs = H; 
	member(Hs, T).

start(X):- 	
	X=[[COL1,DRI1,NAT1,CIG1,PET1],
	   [COL2,DRI2,NAT2,CIG2,PET2],
	   [COL3,DRI3,NAT3,CIG3,PET3],
	   [COL4,DRI4,NAT4,CIG4,PET4],
	   [COL5,DRI5,NAT5,CIG5,PET5]],
	
	member('zebra',[PET1,PET2,PET3,PET4,PET5]),
	member('water',[DRI1,DRI2,DRI3,DRI4,DRI5]),
	
	% 3rd fact
	NAT1='Norwegian',
	% 6th fact
	COL2='blue',
	% 14th fact
	DRI3='milk',
	
	% 1st fact
	member(['red','Englishman'],[[COL3,NAT3],[COL4,NAT4],[COL5,NAT5]]),
	% 2nd fact
	member(['Spaniard','dog'],[[NAT2,PET2],[NAT3,PET3],[NAT4,PET4],[NAT5,PET5]]),
	% 9th fact
	member(['tea','Ukrainian'],[[DRI2,NAT2],[DRI3,NAT3],[DRI4,NAT4],[DRI5,NAT5]]),
	%10th fact
	member(['parliaments','Japanese'],[[CIG2,NAT2],[CIG3,NAT3],[CIG4,NAT4],[CIG5,NAT5]]),
	% (12 & 13)th facts
	member(['green','coffee','ivory'],[[COL4,DRI4,COL3],[COL5,DRI5,COL4]]),
	% 5th fact
	member(['chesterfields','fox'],[[CIG1,PET2],[CIG2,PET1],[CIG2,PET3],[CIG3,PET2],[CIG3,PET4],[CIG4,PET3],[CIG4,PET5],[CIG5,PET4]]),
	% (4 & 11)th facts
	member(['yellow','kools','horse'],[[COL1,CIG1,PET2],[COL3,CIG3,PET2],[COL4,CIG4,PET3],[COL3,CIG3,PET4],[COL4,CIG4,PET5],[COL5,CIG5,PET4]]),
	% 7th fact
	member(['old gold','snails'],[[CIG1,PET1],[CIG2,PET2],[CIG3,PET3],[CIG4,PET4],[CIG5,PET5]]),
	% 8th fact
	member(['orange','lucky strike'],[[DRI1,CIG1],[DRI2,CIG2],[DRI3,CIG3],[DRI4,CIG4],[DRI5,CIG5]]).

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Missionaries and Cannibals
%---------------------------
%Three missionaries and three cannibals seek to cross a river. A boat is available which holds two people, and which can be navigated by any% combination of missionaries and cannibals involving one or two people. If the missionaries on either bank of the river, or “en route” in %the river are outnumbered at any time by the cannibals, the cannibals will succumb to their anthropologic tendencies and do away with the %missionaries. Find the simplest schedule of crossing that will permit all the missionaries and cannibals to cross the river safely

missionaries_cannibals(M,C) :-  
	nl, 
	find(M,C,0,0,0).

valid_move(X,Y,A,B) :- 
	X >= Y, 
	write('X = '), 
	write(X), 
	write('Y = '), 
	write(Y), nl.
	
append([],L,L).
append([H|T],L,[H|Ts]) :- 
	append(T,L,Ts).

test(ML,CL,B) :- ML > 0, B = 0, CL > 0, B = 1.

find(ML,CL,MR,CR,S) :- S1 is S+1,
	write('Missionaries = '), 
	write(ML), write(' ------------------------------------------------------ '),
	write('Missionaries = '), 
	write(MR), 
	nl, 
	write('                  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ '),
	nl,
	write('Cannibals =    '), 
	write(CL), write(' ------------------------------------------------------ '),
	write('Cannibals =    '), 
	write(CR), 
	nl, 
	nl, 
	nl,
	move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,S1),
	(CL == 0 -> (ML == 0 -> X1 is 1;find(ML1,CL1,MR1,CR1,S1)); find(ML1,CL1,MR1,CR1,S1)).

move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,1) :- 
	CL1 is CL-2,
	CR1 is 2,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,2) :-
	CR1 is CR-1,
	CL1 is CL+1,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,3) :-
	CR1 is CR+2,
	CL1 is CL-2,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,4) :-
	CR1 is CR-1,
	CL1 is CL+1,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,5) :-
	ML1 is ML-2,
	MR1 is MR+2,
	CR1 is CR,
	CL1 is CL.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,6) :-
	ML1 is ML+1,
	MR1 is MR-1,
	CL1 is CL+1,
	CR1 is CR-1.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,7) :-
	ML1 is ML-2,
	MR1 is MR+2,
	CL1 is CL,
	CR1 is CR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,8) :-
	MR1 is MR,
	ML1 is ML,
	CR1 is CR-1,
	CL1 is CL+1.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,9) :-
	CR1 is CR+2,
	CL1 is CL-2,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,10) :-
	CR1 is CR-1,
	CL1 is CL+1,
	ML1 is ML,
	MR1 is MR.
move(ML,CL,MR,CR,ML1,CL1,MR1,CR1,11) :-
	CR1 is CR+2,
	CL1 is CL-2,
	ML1 is ML,
	MR1 is MR.
	
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Assembly
%---------
begin([H1|T1],[H2|T2],[H3|T3],[H4|T4],[H5|T5],[H6|T6],S) :- 	
	rotate(H1,H4,T1,T4,X,Y),
	rotate(H2,H4,T1,T4,X,Y),
	rotate(H3,H6,T1,T4,X,Y),
	merge(H1,H2,H4,H5,T1,T4,1,0,0,0),
	merge(H2,H3,H4,H5,T1,T4,0,1,0,0),
	merge(H3,H4,H4,H5,T1,T4,0,0,1,0),
	X = board1.

rotate([B1,B2,B3,B4],[S1,S2,S3,S4],TB,TS,X,Y) :-
	A = B4,
	B = B1,
	C = B2,
	D = B3,
	E = S4,
	F = S1,
	G = S2,
	H = S3,
	X = [[A,B,C,D]|TB],
	Y = [[E,F,G,H]|TS].
	
merge([B1,B2,B3,B4],[B5,B6,B7,B8],[S1,S2,S3,S4],[S5,S6,S7,S8],TS,TB,A,B,C,D) :- 
	L = [B9,B10,B11,B12],
	L1 = [S9,S10,S11,S12],
	(A==1 -> 
	(B1 == B5 -> 
	(S1 \= S5 -> 
	B9 = B5;
	fail);
	fail);
	fail),
	(B==1 -> 
	(B2 == B6 -> 
	(S2 \= S6 -> 
	B10 = B6;
	fail);
	fail);
	fail),
	(C==1 -> 
	(B3 == B7 -> 
	(S3 \= S7 -> 
	B11 = B7;
	fail);
	fail);
	fail),
	(D==1 -> 
	(B4 == B8 -> 
	(S4 \= S8 -> 
	B12 = B8;
	fail);
	fail);
	fail).
	
assembler(X) :- 
	B1 = [['a','b','c','d'],['d','a','d','c'],['d','c','b','d']],
	B2 = [['b','d','c','d'],['d','b','c','a'],['b','a','d','c']],
	B3 = [['a','b','c','d'],['b','a','c','a'],['c','b','a','d']],
	
	S1 = [['-','+','+','+'],['-','+','+','-'],['-','-','+','+']],
	S2 = [['+','+','-','+'],['+','+','-','-'],['+','-','-','+']],
	S3 = [['-','+','+','+'],['+','-','-','+'],['-','-','+','+']],
	
	X = [B1,B2,B3],
	X1 = [S1,S2,S3],
	write(X),
	nl,
	write(X1),
	begin(B1,B2,B3,S1,S2,S3,X).