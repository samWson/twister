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
  is_easter_extent() returns true if the given column is the farthest east in
  the grid.
  """
  @spec is_eastern_extent(gird :: %__MODULE__{}, column :: integer()) :: boolean()
  def is_eastern_extent(grid, column) do
    grid.columns == column
  end

  @doc """
  is_southern_extent() returns true if the given row is the farthest south in
  the grid.
  """
  @spec is_southern_extent(grid :: %__MODULE__{}, row :: integer()) :: boolean()
  def is_southern_extent(grid, row) do
    grid.rows == row
  end

  defp build_cells(columns, rows) do
    coords = for column <- 1..columns, row <- 1..rows, do: {column, row}

    Map.new(coords, fn {column, row} -> {{column, row}, Cell.new(column, row)} end)
  end

  defimpl String.Chars do
    def to_string(grid) do
      top_boundary_string(grid.columns)
      |> row_strings(grid)
      |> Enum.join()
    end

    defp top_boundary_string(columns) do
      Enum.concat([
        ["+"],
        [Enum.map(1..columns, fn _ -> "---+" end)],
        ["\n"]
      ])
    end

    defp row_strings(acc, grid) do
      Enum.reduce(1..grid.rows, acc, fn row, acc -> row_string(row, acc, grid) end)
    end

    defp row_string(row, acc, grid) do
      acc
      |> row_body_string(row, grid)
      |> Enum.concat(["\n"])
      |> row_bottom_boundary_string(row, grid)
      |> Enum.concat(["\n"])
    end

    defp row_body_string(acc, row, grid) do
      Enum.concat(acc, [
        "|"
        | Enum.map(1..grid.columns, fn column ->
            case grid.cells[{column, row}].links do
              [:east] -> "    "
              _ -> "   |"
            end
          end)
      ])
    end

    defp row_bottom_boundary_string(acc, row, grid) do
      Enum.concat(acc, [
        "+"
        | Enum.map(1..grid.columns, fn column ->
            case grid.cells[{column, row}].links do
              [:south] -> "   +"
              _ -> "---+"
            end
          end)
      ])
    end
  end

  defimpl Inspect do
    def inspect(grid, opts) do
      Inspect.Algebra.to_doc("#Grid<Columns: #{grid.columns}, Rows: #{grid.rows}>", opts)
    end
  end
end
