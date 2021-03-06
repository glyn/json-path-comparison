-module(jsonpath).
-export([start/1]).

-define(BLK_SIZE, 16384).

read() ->
    ok = io:setopts(standard_io, [binary]),
    read(<<>>).

read(Acc) ->
    case file:read(standard_io, ?BLK_SIZE) of
        {ok, Data} ->
            read(<<Acc/bytes, Data/bytes>>);
        eof ->
            Acc
    end.

% https://stackoverflow.com/questions/44629823/how-to-apply-timeout-on-method-in-erlang
execute(Selector, Doc) ->
    TimeOut = 10000,
    Self = self(),
    _Pid = spawn(fun()->
                         try
                             Result = ejsonpath:execute(Selector, Doc),
                             Self ! {self(), ok, Result}
                         catch
                             _:Reason -> Self ! {self(), error, Reason}
                         end
                 end),
    receive
        {_PidSpawned, ok, Result} -> Result;
        {_PidSpawned, error, Reason} -> exit(Reason)
    after
        TimeOut -> exit("Timeout")
    end.

print_result(Selector, Doc) ->
    Result = execute(Selector, Doc),
    Json = jiffy:encode(Result),
    io:fwrite("~s~n", [Json]).

start([Selector]) ->
    Bin = read(),
    Doc = jiffy:decode(Bin, [return_maps]),
    print_result(Selector, Doc).
