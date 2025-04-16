defmodule Storybook.Table.Story do
  use PhoenixStorybook.Story, :component
  alias JobsyncWeb.Components.Widgets.Base
  def function, do: &Base.table/1

  def row_mapper(row), do: row.title

  def variations do
    [
      %Variation{
        id: :default,
        description: "My table for displaying jobs",
        attributes: %{
          id: "tabs",
          rows: [
            %{company: "tesla", title: "finance bro", status: :applied},
            %{company: "apple", title: "data analyst", status: :ghosted},
            %{company: "at&t", title: "data engineer", status: :rejected},
            %{company: "baskin robbins", title: "swe", status: :applied}
          ]
          # row_item: &__MODULE__.row_mapper/1
        },
        slots: [
          ~s|<:col label="company" :let={row}>{row.company}</:col>|,
          ~s|<:col label="title" :let={row}>{row.title}</:col>|,
          ~s|<:col label="status" :let={row}>{row.status}</:col>|
        ]
      }
    ]
  end
end
