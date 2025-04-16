defmodule Storybook.Cards.Summary do
  use PhoenixStorybook.Story, :component

  alias JobsyncWeb.Cards.Summary

  def function, do: &Summary.summary_card/1
  @impl true

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default summary card function component",
        attributes: %{
          number: 10
          # artist: "Miles Davis",
          # title: "Kind of Blue",
          # summary: "Lorem ipsum dolar set amit"
        }
      }
    ]
  end
end
