#!/usr/bin/env escript
%% Advent of code day 3. 03.erl <input>

-module('03').
-export([main/1]).

manhattan({ X1, Y1 }, { X2, Y2 }) -> abs(X1 - X2) + abs(Y1 - Y2).
neighbours({ X, Y }) -> [{ X + I, Y + J } || I <- [-1, 0, 1], J <- [-1, 0, 1], not ((I == 0) and (J == 0))].

level_end(L) -> Side = L * 2 + 1, Side * Side.

level_pos({ L, LI }) ->
    DI = ((LI - 1) rem (L * 2)) - (L - 1),
    case 1 + (trunc((LI - 1) / (L * 2)) rem 4) of
        1 -> { L, DI };
        2 -> { -DI, L };
        3 -> { -L, -DI };
        4 -> { DI, -L }
    end.

index_to_pos(Index) -> index_to_pos(Index, 0).
index_to_pos(Index, PLevel) ->
    case Index =< level_end(PLevel + 1) of
        true -> level_pos({ PLevel + 1, Index - level_end(PLevel) });
        false -> index_to_pos(Index, PLevel + 1)
    end.

pos_to_index({ 0, 0 }) -> 1;
pos_to_index({ X, Y }) ->
    Level = lists:max([abs(I) || I <- [X, Y]]),
    case trunc(X / Level) of
        1 -> if Y == -Level -> level_end(Level); true -> Y + Level + level_end(Level - 1) end;
        -1 -> -Y + Level + (Level * 4) + level_end(Level - 1);
        0 -> case trunc(Y / Level) of
                1 -> -X + Level + (Level * 2) + level_end(Level - 1);
                -1 -> X + Level + (Level * 6) + level_end(Level - 1)
            end
    end.

pos_value({ 0, 0 }) -> 1;
pos_value(Pos) ->
    Index = pos_to_index(Pos),
    case erlang:get({ "pos_value", Index }) of
        V when is_integer(V) -> V;
        undefined ->
            Neighbours = lists:filter(fun (P) -> pos_to_index(P) < Index end, neighbours(Pos)),
            Value = lists:foldl(fun (N, Acc) -> Acc + pos_value(N) end, 0, Neighbours),
            erlang:put({ "pos_value", Index }, Value),
            Value
    end.

part_one(Num) -> manhattan(index_to_pos(Num), {0, 0}).

part_two(Num) -> part_two(Num, 1).
part_two(Num, Index) ->
    Value = pos_value(index_to_pos(Index)),
    case Value > Num of
        true -> Value;
        false -> part_two(Num, Index + 1)
    end.

main([String]) ->
    { Num, _ } = string:to_integer(String),
    io:fwrite("Part 1: ~p Part 2: ~p", [part_one(Num), part_two(Num)]).
