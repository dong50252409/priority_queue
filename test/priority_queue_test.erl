-module(priority_queue_test).

-include_lib("eunit/include/eunit.hrl").

simple_test() ->
    QueueA = priority_queue:new(),
    ?assertMatch({{}, 0}, QueueA),
    QueueA1 = priority_queue:insert(0, 0, QueueA),

    L = [{N, rand:uniform(N)} || N <- lists:seq(10, 1, -1)],
    QueueB = priority_queue:from_list(L),
    {1, _} = priority_queue:min(QueueB),
    10 = priority_queue:size(QueueB),

    QueueC = priority_queue:merge(QueueA1, QueueB),
    11 = priority_queue:size(QueueC),
    {0, _, QueueC1} = priority_queue:take_min(QueueC),
    [{1, _}, {2, _}, {3, _}, {4, _}, {5, _}, {6, _}, {7, _}, {8, _}, {9, _}, {10, _}] = priority_queue:to_list(QueueC1).
