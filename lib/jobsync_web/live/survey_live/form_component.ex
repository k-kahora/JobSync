defmodule JobsyncWeb.SurveyLive.FormComponent do
  use JobsyncWeb, :live_component
  alias Jobsync.Applications
  alias JobsyncWeb.Components.Widgets.Base

  def render(assigns) do
    ~H"""
    <div>
      <%!-- <Base.simple_form form={@form} /> --%>
      <Base.simple_form form={@form} phx-submit="save" phx-target={@myself}>
        <Base.input type="text" field={@form[:title]} />
        <Base.input type="text" field={@form[:company]} />
        <Base.input type="text" field={@form[:notes]} />
        <Base.input type="text" field={@form[:description]} />
        <Base.input type="text" field={@form[:status]} />
        <Base.input type="date" field={@form[:date]} />
        <:actions>
          <button>Save</button>
        </:actions>
      </Base.simple_form>
    </div>
    """
  end

  def update(%{job: job} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(Applications.change_jobs(job)) end)}
  end

  def handle_event(
        "save",
        %{"jobs" => job_params} = _,
        socket
      ) do
    save_product(socket, socket.assigns.action, job_params)
  end

  defp save_product(socket, :new, job_params) do
    job_params = Map.put(job_params, "user_id", socket.assigns.job.user_id)

    case Applications.create_jobs(job_params) do
      {:ok, job} ->
        notify_parent({:saved, job})
        {:noreply, socket |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("Error")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_product(socket, :edit, job_params) do
    case Applications.update_jobs(socket.assigns.job, job_params) do
      {:ok, job} ->
        notify_parent({:saved, job})
        {:noreply, socket |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
