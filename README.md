priority_queue
=====

Priority queue based on pairs heap implementation

    new/0       O(1)   
    insert/3    O(1) 
    merge/2     O(1) 
    take_min/1  O(logN) amortized O(N) worst case
    min/1       O(1) 
    size/1      O(1) 
    from_list/1 O(N) 
    to_list/1   O(N)

Build
-----

    $ rebar3 compile
