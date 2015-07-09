Cowboycors
==========

###Use

```elixir
$>iex -S mix

```

Send requests to localhost:8000 like:
localhost:8000/#somenoncorsurl

*enter url like www.google.com, leave off http://
*https:// will be prepended to url

Headers + parameters will be forwarded. Response parameters will be returned along with response headers including 'Access-Control-Allow-Origin: *'

NOTE: Work in Progress
