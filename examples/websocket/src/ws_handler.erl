-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
	erlang:start_timer(1000, self(), <<"Hello!">>),
	{ok, State}.

websocket_handle({text, "cookie"}, State) ->
	{AllCookies, Req2} = cowboy_req:cookies(Req),
	{reply, {text, << AllCookies, Msg/binary >>}, State};
websocket_handle({text, Msg}, State) ->
	{reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info(_Info, State) ->
	{ok, State}.
