defmodule CffdLive.Search do
  use HTTPoison.Base

  def run(query), do: post!("/graphql", graphql_body(query))

  def process_url(url), do: "https://api.github.com" <> url

  def process_request_headers(headers) do
    [
      {"Authorization", ["bearer ", "d996d824d5dd3254f776b246eee7e7ed0975f298"]}
      | headers
    ]
  end

  def process_response_body(body) do
    body
    |> Jason.decode!()
    |> get_in(["data", "search", "edges"])
  end

  def graphql_body(query) do
    # I can't get this string to construct correctly unless I have it exactly
    # like so fml
    """
    {\"query\":\"{\\n  search(query: \\\"#{query}\\\", type: USER, first: 10) {\\n    edges {\\n      node {\\n        ... on User {\\n          login\\n          name\\n          avatarUrl\\n        url\\n          }\\n      }\\n    }\\n  }\\n  rateLimit {\\n    limit\\n    cost\\n    remaining\\n    resetAt\\n  }\\n}\\n\",\"variables\":\"{}\",\"operationName\":null}\n\n
    """
  end
end
