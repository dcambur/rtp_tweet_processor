import Config

config :stream_processor, ecto_repos: [Tweets.Repo]

config :stream_processor, Tweets.Repo,
  database: "stream_processor",
  username: "main_role",
  password: "dcambur",
  hostname: "localhost"
