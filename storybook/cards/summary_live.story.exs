defmodule Storybook.Cards.SummaryLive do
  use PhoenixStorybook.Story, :live_component

  alias JobsyncWeb.Cards.SummaryLive

  def component, do: SummaryLive

  def variations do
  [
    %Variation{
      id: :default,
      description: "Default summary card live component",
      attributes: %{
        artist: "Miles Davis",
        title: "Kind of Blue",
        summary: "Lorem ipsum dolar set amit"
      }
    }
  ]
end
end
