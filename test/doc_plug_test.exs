defmodule DocPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  setup do
    {:ok, %{opts: DocPlug.init}}
  end

  test "endpoint redirects to main doc page", %{opts: opts} do
    req = conn(:get, "/docs") |> DocPlug.call(opts)

    {status, headers, _} = sent_resp(req)
    assert status == 302
    assert {"location", "/docs/index.html"} in headers
  end

  test "documentation is served", %{opts: opts} do
    req = conn(:get, "/docs/index.html") |> DocPlug.call(opts)

    {status, _, _} = sent_resp(req)
    assert status == 200
    assert req.halted
  end
end

