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
	NewValue = integer_to_list(rand:uniform(1000000)),
	Req1 = cowboy_req:set_resp_cookie(<<"server">>, NewValue,
	Req, #{path => <<"/">>}),
	#{client := ClientCookie, server := ServerCookie}
		= cowboy_req:match_cookies([{client, [], <<>>}, {server, [], <<>>}], Req1),
	Req0 = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/html">>
	}),
	{AllCookies, Req2} = cowboy_req:cookies(Req0),
	{reply, {text, << {AllCookies, ClientCookie, ServerCookie}, Msg/binary >>}, State};
websocket_handle({text, Msg}, State) ->
	{reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
	{ok, State}.

websocket_info(_Info, State) ->
	{ok, State}.
