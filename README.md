Cowboycors
==========

###Use

```elixir
$>iex -S mix

```

Send requests to localhost:8000 like:
localhost:8000/http%3A%2F%2Fwww.google.com

The url must be entered with http/https and must be escaped as above

*GET requests aren't currently working with Authorization headers

Headers + parameters will be forwarded. Response parameters will be returned along with response headers including 'Access-Control-Allow-Origin: *'

NOTE: Work in Progress
