defmodule Bonfire.Tracks do
  @moduledoc """
  Tracks context. This module holds tracking related high level API.
  """

  alias Bonfire.Tracks.Schemas.ReadingState
  alias Bonfire.Tracks.Commands.StartReading
  alias Bonfire.Tracks.EventApp
  alias Bonfire.Repo

  @doc """
  Returns the list of reading_states.

  ## Examples

      iex> list_reading_states()
      [%ReadingState{}, ...]

  """
  def list_reading_states do
    Repo.all(ReadingState)
    |> Repo.preload(book: [:metadata])
  end

  @doc """
  Gets a single reading_state.

  Raises if the Reading state does not exist.

  ## Examples

      iex> get_reading_state!(123)
      %ReadingState{}

  """
  def get_reading_state!(id), do: raise("TODO")

  @doc """
  Creates a reading_state.

  ## Examples

      iex> create_reading_state(%{field: value})
      {:ok, %ReadingState{}}

      iex> create_reading_state(%{field: bad_value})
      {:error, ...}

  """
  def create_reading_state(%{"isbn" => isbn}) do
    EventApp.dispatch(%StartReading{isbn: isbn})
  end

  @doc """
  Updates a reading_state.

  ## Examples

      iex> update_reading_state(reading_state, %{field: new_value})
      {:ok, %ReadingState{}}

      iex> update_reading_state(reading_state, %{field: bad_value})
      {:error, ...}

  """
  def update_reading_state(%ReadingState{} = reading_state, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a ReadingState.

  ## Examples

      iex> delete_reading_state(reading_state)
      {:ok, %ReadingState{}}

      iex> delete_reading_state(reading_state)
      {:error, ...}

  """
  def delete_reading_state(%ReadingState{} = reading_state) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking reading_state changes.

  ## Examples

      iex> change_reading_state(reading_state)
      %Todo{...}

  """
  def change_reading_state(%ReadingState{} = reading_state) do
    raise "TODO"
  end
end
