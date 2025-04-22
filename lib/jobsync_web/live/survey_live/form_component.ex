defmodule JobsyncWeb.SurveyLive.FormComponent do
  use JobsyncWeb, :live_component
  alias Jobsync.Applications
  alias JobsyncWeb.Components.Widgets.Base, as: B

  def render(assigns) do
    ~H"""
    <div>
      <%!-- <Base.simple_form form={@form} /> --%>
      <B.simple_form form={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <B.input type="text" label="title" field={@form[:title]} />
        <B.input type="text" label="company" field={@form[:company]} />
        <B.input type="text" label="notes" field={@form[:notes]} />
        <B.input type="text" label="description" field={@form[:description]} />
        <B.input type="text" label="status" field={@form[:status]} />
        <B.input type="date" label="date" field={@form[:date]} />

        <%!-- <form --%>
        <%!--   id="goal-form" --%>
        <%!--   phx-submit="submit-file" --%>
        <%!--   phx-change="validate-upload" --%>
        <%!--   phx-drop-target={@uploads.document.ref} --%>
        <%!-- > --%>
        <%!-- {assigns |> inspect()} --%>
        <.input type="hidden" field={@form[:resume_key]} />
        <%= if assigns.job.resume_key do %>
          {"Resume uploaded #{assigns.job.resume_key}"}
        <% end %>
        <.live_file_input upload={@uploads.document} />

        <.input type="hidden" field={@form[:job_description]} />
        <%= if assigns.job.job_description do %>
          {"#{assigns.job.job_description}"}
        <% end %>
        <.live_file_input upload={@uploads.job_description} />

        <.input type="hidden" field={@form[:cover_letter]} />
        <%= if assigns.job.cover_letter do %>
          {"#{assigns.job.cover_letter}"}
        <% end %>
        <.live_file_input upload={@uploads.cover_letter} />
        <%!-- </form> --%>
        <:actions>
          <button>Save</button>
        </:actions>
      </B.simple_form>
    </div>
    """
  end

  defp upload_s3(user_id, job) do
    fn %{path: path}, entry ->
      key =
        "uploads/#{user_id}/#{job["company"]}-#{job["title"]}-#{short_url(4)}-#{entry.client_name}"

      ExAws.S3.Upload.stream_file(path)
      |> ExAws.S3.upload("jobsync-filestore", key)
      |> ExAws.request()

      {:ok, key}
    end
  end

  def short_url(size) do
    :crypto.strong_rand_bytes(size) |> Base.url_encode64(padding: false) |> binary_part(0, size)
  end

  def update(%{job: job} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> allow_upload(:document, accept: ~w(.pdf .md .txt), max_entries: 1)
     |> allow_upload(:cover_letter, accept: ~w(.pdf .md .txt), max_entries: 1)
     |> allow_upload(:job_description, accept: ~w(.pdf .txt), max_entries: 1)
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
    uploaded_files = %{
      resume:
        consume_uploaded_entries(
          socket,
          :document,
          upload_s3(socket.assigns.job.user_id, job_params)
        ),
      cover_letter:
        consume_uploaded_entries(
          socket,
          :cover_letter,
          upload_s3(socket.assigns.job.user_id, job_params)
        ),
      job_description:
        consume_uploaded_entries(
          socket,
          :job_description,
          upload_s3(socket.assigns.job.user_id, job_params)
        )
    }

    job_params =
      job_params
      |> Map.put("resume_key", List.first(uploaded_files.resume) || socket.assigns.job.resume_key)
      |> Map.put(
        "cover_letter",
        List.first(uploaded_files.cover_letter) || socket.assigns.job.cover_letter
      )
      |> Map.put(
        "job_description",
        List.first(uploaded_files.job_description) || socket.assigns.job.job_description
      )

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
