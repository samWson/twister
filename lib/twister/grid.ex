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

  @doc """
  to_string() returns a string representation of the grid as ASCII art.
  """
  def to_string(grid) do
    top_boundary_string(grid.columns)
    |> row_strings(grid.rows, grid.columns)
    |> Enum.join()
  end

  defp top_boundary_string(columns) do
    Enum.concat(
      [
        ["+"],
        [Enum.map(1..columns, fn _ -> "---+" end)],
        ["\n"]
      ]
    )
  end

  defp row_strings(acc, rows, columns) do
    Enum.reduce(1..rows, acc, fn _, acc -> row_string(acc, columns) end)
  end

  defp row_string(acc, columns) do
    acc
    |> Enum.concat([ "|" | Enum.map(1..columns, fn _ -> "   |" end) ])
    |> Enum.concat(["\n"])
    |> Enum.concat([ "+" | Enum.map(1..columns, fn _ -> "---+" end) ])
    |> Enum.concat(["\n"])
  end

  defp build_cells(columns, rows) do
    coords = for column <- 1..columns, row <- 1..rows, do: {column, row}

    Map.new(coords, fn {column, row} -> {{column, row}, Cell.new(column, row)} end)
  end
end