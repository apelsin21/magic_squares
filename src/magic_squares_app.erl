%%%-------------------------------------------------------------------
%% @doc magic_squares public API
%% @end
%%%-------------------------------------------------------------------

-module(magic_squares_app).

-behaviour(application).

%-export([start/2, stop/1]).
-compile(export_all).

print_and_run(X) ->
	Squares = magic_squares(3, X),

	case Squares of
		[] -> io:format("~p = []~n", [X]);
		L -> print_squares(L)
	end.

start() ->
    magic_squares_sup:start_link(),

    [spawn(fun() -> print_and_run(X) end) || X <- lists:seq(15,25)].

stop(_State) ->
    ok.

%% internal functions

is_magic_square({NW,NC,NE,W,C,E,SW,SC,SE}, V) ->
	(NW+NC+NE =:= V) % top row
	andalso (W+C+E =:= V) % middle row
	andalso (SW+SC+SE =:= V) % bottom row
	andalso (NW+W+SW =:= V) % left column
	andalso (NC+C+SC =:= V) % middle column
	andalso (NE+E+SE =:= V) % right column
	andalso (NW+C+SE =:= V) % diagonal top left bottom right
	andalso (NE+C+SW =:= V) % diagonal top right bottom left
	andalso all_uniq(tuple_to_list({NW,NC,NE,W,C,E,SW,SC,SE})).

uniq(Elem, [H|T]) ->
	case Elem =:= H of
		false -> uniq(Elem, T);
		true -> false
	end;
uniq(_, []) ->
	true.

all_uniq([H|T]) ->
	case uniq(H, T) of
		true -> all_uniq(T);
		false -> false
	end;
all_uniq([]) ->
	true.

% ----------------
% | NW | NC | NE |
% |  W |  C |  E |
% | SW | SC | SE |
% ----------------
magic_squares(Order, V) ->
	Min=1,
	Max=Order*Order,
	L=lists:seq(Min,Max),

	[{NW,NC,NE,W,C,E,SW,SC,SE} ||
	NW <- L,
	NC <- L,
	NE <- L,
	W <- L,
	C <- L,
	E <- L,
	SW <- L,
	SC <- L,
	SE <- L,
	is_magic_square({NW,NC,NE,W,C,E,SW,SC,SE}, V)
	].

perms([]) ->
	[[]];
perms(L) ->
	[[H|T] || H <- L, T <- perms(L--[H])].

%new_magic_square(Order, N) ->
%	
%
%find_magic_square(Order) ->
%	find_magic_square(Order, 14, 0).
%
%find_magic_square(Order, N, Start) ->
%	Squares = magic_squares(Order, N),
%
%	case Squares of
%		[] -> io:format("~p=[]~n", [N]), find_magic_square(Order, N+1);
%		Squares ->
%			io:format("~p=...~n", [N]),
%			print_squares(Squares),
%			io:format("~p=^", [N])
%	end.

print_square({NW,NC,NE,W,C,E,SW,SC,SE}) ->
	io:format("----------~n"),
	io:format("|~2.. B|~2.. B|~2.. B|~n", [NW,NC,NE]),
	io:format("|~2.. B|~2.. B|~2.. B|~n", [W,C,E]), 
	io:format("|~2.. B|~2.. B|~2.. B|~n", [SW,SC,SE]), 
	io:format("----------~n").

print_squares(Squares) -> lists:foreach(fun(X) -> print_square(X) end, Squares).
