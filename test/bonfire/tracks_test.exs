defmodule Bonfire.TracksTest do
  use Bonfire.DataCase

  alias Bonfire.Tracks

  describe "reading_states" do
    alias Bonfire.Tracks.Schemas.ReadingState

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def reading_state_fixture(attrs \\ %{}) do
      {:ok, reading_state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tracks.create_reading_state()

      reading_state
    end

    @tag :pending
    test "list_reading_states/0 returns all reading_states" do
      reading_state = reading_state_fixture()
      assert Tracks.list_reading_states() == [reading_state]
    end

    @tag :pending
    test "get_reading_state!/1 returns the reading_state with given id" do
      reading_state = reading_state_fixture()
      assert Tracks.get_reading_state!(reading_state.id) == reading_state
    end

    @tag :pending
    test "create_reading_state/1 with valid data creates a reading_state" do
      assert {:ok, %ReadingState{} = reading_state} = Tracks.create_reading_state(@valid_attrs)
    end

    @tag :pending
    test "create_reading_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_reading_state(@invalid_attrs)
    end

    @tag :pending
    test "update_reading_state/2 with valid data updates the reading_state" do
      reading_state = reading_state_fixture()

      assert {:ok, %ReadingState{} = reading_state} =
               Tracks.update_reading_state(reading_state, @update_attrs)
    end

    @tag :pending
    test "update_reading_state/2 with invalid data returns error changeset" do
      reading_state = reading_state_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tracks.update_reading_state(reading_state, @invalid_attrs)

      assert reading_state == Tracks.get_reading_state!(reading_state.id)
    end

    @tag :pending
    test "delete_reading_state/1 deletes the reading_state" do
      reading_state = reading_state_fixture()
      assert {:ok, %ReadingState{}} = Tracks.delete_reading_state(reading_state)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_reading_state!(reading_state.id) end
    end

    @tag :pending
    test "change_reading_state/1 returns a reading_state changeset" do
      reading_state = reading_state_fixture()
      assert %Ecto.Changeset{} = Tracks.change_reading_state(reading_state)
    end
  end
end
