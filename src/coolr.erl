-module(coolr).
-export([do/1, do/2]).

%%
%% API
%%

do(String) -> do(String, 25).
do(String, Shade) -> to_hex(shade(rgb(hash(String)), Shade)).

%%
%% Internal
%%

hash(Str) ->
    lists:foldl(fun(Char, Acc) ->
        Char + ((Acc bsl 5) - Acc)
    end, 0, Str).

rgb(Int) ->
    { (Int bsr 24) band 16#FF
    , (Int bsr 16) band 16#FF
    , (Int bsr 8)  band 16#FF
    }.

shade({R, G, B}, Amt) ->
    { check(R + Amt)
    , check(G + Amt)
    , check(B + Amt)
    }.

check(Col) when (Col < 255) and (Col >= 1) -> Col;
check(Col) when (Col < 255) -> 0;
check(Col) -> 255.

to_hex({R, G, B}) ->
    to_hex(R) ++ to_hex(G) ++ to_hex(B);
to_hex(Int) ->
    fix_len(integer_to_list(Int, 16)).

fix_len(Hex) when length(Hex) =:= 1 -> [$0|Hex];
fix_len(Hex) -> Hex.

%%
%% Tests
%%

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

do_test() ->
    ?assertEqual("CFA5FE", do("artemeff")),
    ?assertEqual("1951DF", do("yuri")),
    ?assertEqual("CBEBA0", do("erlcol")),
    ?assertEqual("194F5D", do("test")).

do_shade_test() ->
    ?assertEqual("C7902F", do("qwerty", 0)),
    ?assertEqual("A77DD6", do("artemeff", -15)),
    ?assertEqual("0A42D0", do("yuri", 10)),
    ?assertEqual("FFFFFF", do("erlcol", 155)),
    ?assertEqual("000000", do("test", -1400)).

-endif.
