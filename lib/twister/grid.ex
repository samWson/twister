defmodule Twister.Grid do
  alias Twister.Cell

  defstruct [:cells, :rows, :columns]

  @doc """
  new() returns a grid with the dimensions given in the params.
  """
  @spec new(columns :: integer(), rows :: integer()) :: %__MODULE__{}
  def new(columns, rows) do
    %__MODULE__{
      cells: build_cells(columns, rows),
      columns: columns,
      rows: rows
    }
  end

  defp build_cells(columns, rows) do
    coords = for column <- 1..columns, row <- 1..rows, do: {column, row}

    Map.new(coords, fn {column, row} -> {{column, row}, Cell.new(column, row)} end)
  end
end