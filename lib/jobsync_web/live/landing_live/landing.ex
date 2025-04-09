defmodule JobsyncWeb.Landing do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.Landing.Component
  alias Jobsync.Accounts

  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     assign(socket,
       title: "JobSync",
       score: 100_000_000
       # session_id: session["live_socket_id"]
     )}
  end

  def render(assigns) do
    ~H"""
    <pre>
      <%= inspect(@current_user.email) %>
      <%= @session_id %>
    </pre>
    <div class="flex flex-col items-center lg:items-start gap-10 v-screen">
      <Component.header></Component.header>
      <ul>
        <Component.elem icon="share">
          <:upper>Share you jobs with others and they can add jobs</:upper>
          <:lower>People can add jobs to your search without making an account</:lower>
        </Component.elem>
        <Component.elem icon="bookmark-square">
          <:upper>Save, Upload, and Download jobs as you search</:upper>
          <:lower>Easy date exporting and importing with markdown</:lower>
        </Component.elem>
        <Component.elem icon="briefcase">
          <:upper>Makes it clear of every job oppurtunity</:upper>
          <:lower>You can look back and see all job oppurtunity available to you</:lower>
        </Component.elem>
        <Component.elem icon="chart-bar">
          <:upper>Objective analtics for an overview on you job search</:upper>
          <:lower>Show to people who think your lazy and do not apply to enough jobs</:lower>
        </Component.elem>
      </ul>
    </div>
    """
  end
end
