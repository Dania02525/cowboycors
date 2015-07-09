defmodule Cowboycors.Handler do
  def init({:tcp, :http}, req, opts) do
    {method, req} = :cowboy_req.method(req)
    {url, req} = :cowboy_req.binding(:url, req)
    {headers, req} = :cowboy_req.headers(req)
    {ctype, req} = :cowboy_req.header(<<"Content-Type">>, req, <<"text/plain">>)
    {body, req} = :cowboy_req.qs(req)

    response = request(method, url, headers, ctype, body)
    	         |> parse_response
    {:ok, resp} = :cowboy_req.reply(200, response.headers, response.body, req)
    {:ok, resp, opts}
  end 

  def request(method, url, headers, ctype, body) do
    case method do  	
      "GET" -> 
      	url = String.to_char_list("http://" <> url)
      	headers = headers
      			    |> Enum.map(fn({k,v}) -> {String.to_char_list(k), String.to_char_list(v)} end)
        :httpc.request(url)
        #:httpc.request(:get, {url, headers}, [], [])        
      "POST" ->
      	url = String.to_char_list("http://" <> url)
      	headers = headers
      			    |> Enum.map(fn({k,v}) -> {String.to_char_list(k), String.to_char_list(v)} end)
      	:httpc.request(:post, {url, headers, ctype, body}, [], body_format: :binary)
    end
  end

  defp parse_response(httpc_response) do
  	case httpc_response do
      {:ok, {{_httpvs, code, _status_phrase}, headers, body}} ->
      	%{
      		headers: headers ++ [{"Access-Control-Allow-Origin", "*"}],
      		body: body
      	}
      {:error, reason} ->
      	%{
      		headers: [],
      		body: "error: " <> reason
      	}
    end
  end

  def handle(req, state) do
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

end