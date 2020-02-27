defmodule BonfireWeb.PageControllerTest do
  use BonfireWeb.ConnCase

  @tag :pending
  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
