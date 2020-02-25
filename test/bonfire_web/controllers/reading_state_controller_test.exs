defmodule BonfireWeb.ReadingStateControllerTest do
  use BonfireWeb.ConnCase

  alias Bonfire.Tracks

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:reading_state) do
    {:ok, reading_state} = Tracks.create_reading_state(@create_attrs)
    reading_state
  end

  describe "index" do
    @tag :pending
    test "lists all reading_states", %{conn: conn} do
      conn = get(conn, Routes.reading_state_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Reading states"
    end
  end

  describe "new reading_state" do
    @tag :pending
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.reading_state_path(conn, :new))
      assert html_response(conn, 200) =~ "New Reading state"
    end
  end

  describe "create reading_state" do
    @tag :pending
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.reading_state_path(conn, :create), reading_state: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.reading_state_path(conn, :show, id)

      conn = get(conn, Routes.reading_state_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Reading state"
    end

    @tag :pending
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.reading_state_path(conn, :create), reading_state: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Reading state"
    end
  end

  describe "edit reading_state" do
    setup [:create_reading_state]

    @tag :pending
    test "renders form for editing chosen reading_state", %{
      conn: conn,
      reading_state: reading_state
    } do
      conn = get(conn, Routes.reading_state_path(conn, :edit, reading_state))
      assert html_response(conn, 200) =~ "Edit Reading state"
    end
  end

  describe "update reading_state" do
    setup [:create_reading_state]

    @tag :pending
    test "redirects when data is valid", %{conn: conn, reading_state: reading_state} do
      conn =
        put(conn, Routes.reading_state_path(conn, :update, reading_state),
          reading_state: @update_attrs
        )

      assert redirected_to(conn) == Routes.reading_state_path(conn, :show, reading_state)

      conn = get(conn, Routes.reading_state_path(conn, :show, reading_state))
      assert html_response(conn, 200)
    end

    @tag :pending
    test "renders errors when data is invalid", %{conn: conn, reading_state: reading_state} do
      conn =
        put(conn, Routes.reading_state_path(conn, :update, reading_state),
          reading_state: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Reading state"
    end
  end

  describe "delete reading_state" do
    setup [:create_reading_state]

    @tag :pending
    test "deletes chosen reading_state", %{conn: conn, reading_state: reading_state} do
      conn = delete(conn, Routes.reading_state_path(conn, :delete, reading_state))
      assert redirected_to(conn) == Routes.reading_state_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.reading_state_path(conn, :show, reading_state))
      end
    end
  end

  defp create_reading_state(_) do
    reading_state = fixture(:reading_state)
    {:ok, reading_state: reading_state}
  end
end
