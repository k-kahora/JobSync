defmodule JobsyncWeb.SurveyLive.FormComponent do
  use JobsyncWeb, :live_component
  alias Jobsync.Applications
  alias JobsyncWeb.Components.Widgets.Base

  def render(assigns) do
    ~H"""
    <div>
      <%!-- <Base.simple_form form={@form} /> --%>
      <Base.simple_form form={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <Base.input type="text" label="title" field={@form[:title]} />
        <Base.input type="text" label="company" field={@form[:company]} />
        <Base.input type="text" label="notes" field={@form[:notes]} />
        <Base.input type="text" label="description" field={@form[:description]} />
        <Base.input type="text" label="status" field={@form[:status]} />
        <Base.input type="date" label="date" field={@form[:date]} />

        <%!-- <form --%>
        <%!--   id="goal-form" --%>
        <%!--   phx-submit="submit-file" --%>
        <%!--   phx-change="validate-upload" --%>
        <%!--   phx-drop-target={@uploads.document.ref} --%>
        <%!-- > --%>
        <.live_file_input upload={@uploads.document} />
        <%!-- </form> --%>
        <:actions>
          <button>Save</button>
        </:actions>
      </Base.simple_form>
    </div>
    """
  end

  defp upload_s3(path, entry, user_id) do
    key = "uploads/#{user_id}/#{entry.client_name}"

    ExAws.S3.Upload.stream_file(path)
    |> ExAws.S3.upload("jobsync-filestore", key)
    |> ExAws.request()

    {:ok, key}
  end

  def update(%{job: job} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:document, accept: ~w(.pdf .md), max_entries: 1, auto_upload: true)
     |> assign_new(:form, fn -> to_form(Applications.change_jobs(job)) end)}
  end

  def handle_event("validate", %{"jobs" => job_params}, socket) do
    changeset = Applications.change_jobs(socket.assigns.job, job_params)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event(
        "save",
        %{"jobs" => job_params} = _,
        socket
      ) do
    uploaded_files =
      consume_uploaded_entries(socket, :document, fn %{path: path}, entry ->
        {:ok, key} = upload_s3(path, entry, socket.assigns.job.user_id)
        IO.puts(key)
        {:ok, key}
      end)

    job_params = Map.put(job_params, "resume_key", uploaded_files |> List.first())
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
