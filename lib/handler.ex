defmodule Cowboycors.Handler do
  def init({:tcp, :http}, req, opts) do
    {method, req} = :cowboy_req.method(req)
    {url, req} = :cowboy_req.binding(:url, req)
    {headers, req} = :cowboy_req.headers(req)
    {body, req} = :cowboy_req.qs(req)
    {ctype, req} = :cowboy_req.header(<<"content-type">>, req, "text/plain")
    response = request(method, url, headers, ctype, body)
    	           |> parse_response
    {:ok, resp} = :cowboy_req.reply(response.code, response.headers, response.body, req)
    {:ok, resp, opts}
  end 

  def request(method, url, headers, ctype, body) do
    case method do  	
      "GET" -> 
      	url = String.to_char_list(URI.decode(url))
      	headers = headers
      			    |> Enum.map(fn({k,v}) -> {String.to_char_list(k), String.to_char_list(v)} end)
        :httpc.request(url)
        #:httpc.request(:get, {url, headers}, [], [])        
      "POST" ->
      	url = String.to_char_list(URI.decode(url))
        ctype = String.to_char_list(ctype)
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
      		body: body,
          code: code
      	}
      {:error, reason} ->
      	%{
      		headers: [] ++ [{"Access-Control-Allow-Origin", "*"}],
      		body: "An Error Occured" <> reason,
          code: 400
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