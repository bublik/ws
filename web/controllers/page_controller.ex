defmodule Ws.PageController do
  use Ws.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
