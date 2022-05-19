defmodule Tweets.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :username, :string
    end

    create table(:tweets) do
      add :sentiment, :decimal
      add :engagement, :decimal
    end
  end

end
