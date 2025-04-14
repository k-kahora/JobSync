defmodule Widgets.Index do
  use PhoenixStorybook.Index
  def folder_name, do: "Display Widgets"
  def folder_icon, do: {:fa, "bolt", :thin}
  def entry("total"), do: [icon: {:fa, "file", :thin}]
end
