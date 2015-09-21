defmodule DocPlug do
  @moduledoc ~S"""
  A plug for automatically generating and mounting a project's documentation.
  Requires that the project has documentation generation via
  [ExDoc](https://github.com/elixir-lang/ex_doc) already set up.

  **Note**: If the generation task given does not exist then an error will be
  thrown on initialization.

  ## Options

  - `task`: The name of the mix task to run to generate docs. Defaults to
    `"docs"`.
  - `from`: The directory on the filesystem the generated documentation can be
    found. Defaults to `"doc"`.
  - `at`: The path to serve the docs from. Defaults to `"docs/"`.
  - `generate`: If the documentation should be generated on starting the
    server, defaults to `true`.
  """

  import Plug.Conn
  alias Mix.Task
  alias Plug.Conn
  alias Plug.Static

  # Types for plug configuration data.
  @typep doc_conf :: %{from: String.t, at: String.t, task: String.t,
                       generate: boolean}
  @typep config :: {doc_conf, %{}}

  # Default values for the task -- should match ExDoc defaults.
  @defaults %{from: "doc",
              at: "docs",
              task: "docs",
              generate: true}

  defmodule GenerationError do
    @moduledoc ~S"""
    Error caused by an invalid task used for documentation generation.
    """

    defexception [:message]

    @doc false
    def exception(task) do
      %__MODULE__{message: ~s(The task "#{task}" is not available.)}
    end
  end

  @doc ~S"""
  Initialize the plug with the given options. See the module documentation for
  an overview of the options available.
  """
  @spec init(Keyword.t) :: config
  def init(overrides \\ []) do
    opts = Enum.into(overrides, @defaults)
    static_opts = Static.init(at: opts.at, from: opts.from, gzip: false)

    # Determine if task name is runnable.
    if opts.generate and Task.get(opts.task) == nil do
      raise GenerationError, opts.task
    end

    generate(opts)
    {opts, static_opts}
  end

  @doc ~S"""
  Call the plug for the given connection.

  Connections to the base endpoint will be redirected to the main documentation
  page and the documentation contents will be served.
  """
  def call(%Conn{path_info: path} = conn, {opts, static_opts}) do
    at = opts.at
    case path do
      [^at] -> redirect(conn, at)
      [^at | _rest] -> Static.call(conn, static_opts)
      _ -> conn
    end
  end

  # Generate the documentation if needed.
  defp generate(%{generate: false}), do: :noop
  defp generate(%{task: task}) do
    :application.ensure_started(:mix)

    Task.reenable(task)
    Task.run(task)
  end

  # Redirect the user to the main documentation page.
  defp redirect(conn, to) do
    url = "/#{URI.encode(to)}/index.html"
    body = "You are being redirected to #{url}"

    conn
    |> put_resp_header("location", url)
    |> put_resp_content_type("text/plain")
    |> send_resp(302, body)
    |> halt
  end
end

