-module(priority_queue).

-export([new/0, insert/3, merge/2, take_min/1, min/1, size/1, from_list/1, to_list/1]).


-type queue() :: {sub_queue(), Size :: non_neg_integer()}.

-opaque sub_queue() :: {Priority :: term(), Value :: term(), [sub_queue()]}.

-spec new() -> NewQueue :: queue().
new() ->
    {{}, 0}.

-spec insert(Priority :: term(), Value :: term(), Queue :: queue()) -> NewQueue :: queue().
insert(Priority, Value, {Queue, Size}) ->
    {do_merge({Priority, Value, []}, Queue), Size + 1}.

-spec merge(Queue1 :: queue(), Queue2 :: queue()) -> NewQueue :: queue().
merge({Queue1, Size1}, {Queue2, Size2}) ->
    {do_merge(Queue1, Queue2), Size1 + Size2}.

-spec min(Queue :: queue()) -> {Priority :: term(), Value :: term()}.
min({{}, _}) ->
    empty;
min({{Priority, Value, _SubQueue}, _Size}) ->
    {Priority, Value}.

-spec take_min(Queue :: queue()) -> {Priority :: term(), Value :: term(), NewQueue :: queue()}.
take_min({{}, _}) ->
    empty;
take_min({{Priority, Value, SubQueue}, Size}) ->
    {Priority, Value, {merge_pairs(SubQueue), Size - 1}}.

-spec size(Queue :: queue()) -> Size :: non_neg_integer().
size({_Queue, Size}) ->
    Size.

-spec from_list(L :: [{Priority :: term(), Value :: term()}]) -> NewQueue :: queue().
from_list(L) ->
    from_list_1(L, new()).

-spec to_list(Queue :: queue()) -> [{Priority :: term(), Value :: term()}].
to_list(Queue) ->
    to_list_1(Queue).
%%=============================================================
%% Internal Functions
%%=============================================================
do_merge(Queue, {}) ->
    Queue;
do_merge({}, Queue) ->
    Queue;
do_merge({Priority, Value, SubQueue}, Queue2) when Priority < element(1, Queue2) ->
    {Priority, Value, [Queue2 | SubQueue]};
do_merge(Queue1, {Priority, Value, SubQueue}) ->
    {Priority, Value, [Queue1 | SubQueue]}.

merge_pairs([SubQueue1, SubQueue2 | T]) ->
    do_merge(do_merge(SubQueue1, SubQueue2), merge_pairs(T));
merge_pairs([SubQueue]) ->
    SubQueue;
merge_pairs([]) ->
    {}.

from_list_1([{Priority, Value} | T], Queue) ->
    from_list_1(T, insert(Priority, Value, Queue));
from_list_1([], Queue) ->
    Queue.

to_list_1(Queue) ->
    case take_min(Queue) of
        empty ->
            [];
        {Priority, Value, NewQueue} ->
            [{Priority, Value} | to_list_1(NewQueue)]
    end.