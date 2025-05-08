:- use_module(library(random)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first_n_elements(khawa_khawa, Count, List, PrefixElements)
%
% Extracts the first Count elements of List (i.e. its prefix)
% and returns them in PrefixElements.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_first_n_elements(_Ctx, 0, _List, []) :- !.
khawa_khawa_first_n_elements(_Ctx, _Count, [], []) :- !.
khawa_khawa_first_n_elements(Ctx, Count, [H|T], [H|Rest]) :-
    Count > 0,
    Count1 is Count - 1,
    khawa_khawa_first_n_elements(Ctx, Count1, T, Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select_weighted(khawa_khawa, Probabilities, Elements, ChosenElement)
%
% Selects one element from Elements according to Probabilities using a random float.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_select_weighted(Ctx, Probs, Elems, Chosen) :-
    random(R),  % use random_float/1 instead of deprecated random/1
    khawa_khawa_select_by_prob(Ctx, Probs, Elems, R, Chosen).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select_by_prob(khawa_khawa, Probabilities, Elements, Random, ChosenElement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_select_by_prob(_Ctx, [P|_], [E|_], R, E) :-
    R =< P, !.
khawa_khawa_select_by_prob(Ctx, [P|Ps], [_|Es], R, Chosen) :-
    R1 is R - P,
    khawa_khawa_select_by_prob(Ctx, Ps, Es, R1, Chosen).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second_elements(khawa_khawa, ListOfPairs, Seconds)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_second_elements(_Ctx, [], []).
khawa_khawa_second_elements(Ctx, [[_,Second|_]|Rest], [Second|Ss]) :-
    khawa_khawa_second_elements(Ctx, Rest, Ss).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% count_elem(khawa_khawa, Element, List, Count)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_count_elem(_Ctx, _E, [], 0).
khawa_khawa_count_elem(Ctx, E, [E|T], C) :-
    khawa_khawa_count_elem(Ctx, E, T, C1),
    C is C1 + 1.
khawa_khawa_count_elem(Ctx, E, [_|T], C) :-
    khawa_khawa_count_elem(Ctx, E, T, C).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rel_freq_stats(khawa_khawa, BigList, QueryList, Stats)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_rel_freq_stats(Ctx, BL, QL, Stats) :-
    length(BL, Total),
    khawa_khawa_rel_freq_stats_internal(Ctx, QL, BL, Total, Stats).

khawa_khawa_rel_freq_stats_internal(_Ctx, [], _BL, _Tot, []).
khawa_khawa_rel_freq_stats_internal(Ctx, [E|Es], BL, Tot, [[E,F,V]|Rs]) :-
    khawa_khawa_count_elem(Ctx, E, BL, Count),
    ( Tot =:= 0 -> F = 0 ; F is Count / Tot ),
    ( Tot =:= 0 -> V = 0 ; V is F * (1 - F) / Tot ),
    khawa_khawa_rel_freq_stats_internal(Ctx, Es, BL, Tot, Rs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normal_pdf and normal_area approximator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_normal_pdf(_Ctx, X, Y) :-
    Y is 1/sqrt(2*pi) * exp(-X*X/2).

khawa_khawa_normal_area(Ctx, A, B, N, Area) :-
    Delta is (B - A) / N,
    khawa_khawa_normal_area_helper(Ctx, A, Delta, N, 0, Area).

khawa_khawa_normal_area_helper(_Ctx, _X, _D, 0, Acc, Acc).
khawa_khawa_normal_area_helper(Ctx, X, D, N, Acc, Area) :-
    N > 0,
    Mid is X + D/2,
    khawa_khawa_normal_pdf(Ctx, Mid, Y),
    Acc1 is Acc + Y * D,
    X1 is X + D,
    N1 is N - 1,
    khawa_khawa_normal_area_helper(Ctx, X1, D, N1, Acc1, Area).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% distance_test(khawa_khawa, Variance, Result)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_distance_test(_Ctx, 0, 1).
khawa_khawa_distance_test(Ctx, Var, R) :-
    Bound is 0.1 / sqrt(Var),
    khawa_khawa_normal_area(Ctx, -Bound, Bound, 1000, R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% proba_of_strategy(khawa_khawa, StrategyList, Probabilities)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_proba_of_strategy(_Ctx, [], []).
khawa_khawa_proba_of_strategy(Ctx, [[_,_,Var]|Ss], [P|Ps]) :-
    khawa_khawa_distance_test(Ctx, Var, P),
    khawa_khawa_proba_of_strategy(Ctx, Ss, Ps).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix_A/2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
khawa_khawa_matrix_A(_Ctx, [
  [1,0,3,4,5],
  [3,2,0,4,5],
  [1,5,3,0,5],
  [1,2,7,4,0],
  [1,2,3,9,5]
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dot products, transpose, max_index, zeros, set_at_index, update, product, pairwise_multiply, create_list
% (as in your original code, unchanged)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... (copy the rest of your helper predicates here exactly as before) ...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main predicate: joue(khawa_khawa, GameHistory, Move)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
joue(Ctx, GH, Move) :-
    length(GH, L), L < 4,
    khawa_khawa_select_weighted(Ctx, [0.03,0.444,0.203,0.323,0.0], [1,2,3,4,5], Move).

joue(Ctx, GH, Move) :-
    khawa_khawa_first_n_elements(Ctx, 4, GH, Last4),
    khawa_khawa_second_elements(Ctx, Last4, OppMoves),
    khawa_khawa_rel_freq_stats(Ctx, OppMoves, [1,2,3,4,5], Strat),
    khawa_khawa_proba_of_strategy(Ctx, Strat, Probs),
    khawa_khawa_matrix_A(Ctx, A),
    khawa_khawa_second_elements(Ctx, Strat, ExpStrat),
    khawa_khawa_pairwise_multiply(Ctx, ExpStrat, Probs, WStrat),
    khawa_khawa_product(Ctx, Probs, Psucc),
    khawa_khawa_create_list(Ctx, 5, Psucc, PsuccVec),
    khawa_khawa_best_response(Ctx, WStrat, A, Resp),
    khawa_khawa_update(Ctx, [0.03,0.444,0.203,0.323,0.0], PsuccVec, Resp, Choice),
    khawa_khawa_select_weighted(Ctx, Choice, [1,2,3,4,5], Move).
