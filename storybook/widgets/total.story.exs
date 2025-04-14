defmodule Storybook.Total.Story do
  use PhoenixStorybook.Story, :component
  alias JobsyncWeb.Components.Widgets.Base
  def function, do: &Base.total/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default Display of a number",
        attributes: %{
          number: 10,
          heading: "this week",
          previous: 3,
          footer: "from last week",
          unit: ""
        }
      }
    ]
  end
end
