defmodule PhoenixDockerWeb.PageController do
  use PhoenixDockerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
