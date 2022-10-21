defmodule Twister.Grid do
  defstruct [:rows, :columns, :table]

  @doc """
  new() returns a grid with the dimensions given in the params.
  """
  @spec new(columns :: integer(), rows :: integer()) :: %__MODULE__{}
  def new(columns, rows) do
    %__MODULE__{
      columns: columns,
      rows: rows,
      table: :ets.new(:cells, [])
    }
  end

  @doc """
  coordinates() returns all the coordinates of the grid as a list of tuples.
  """
  @spec coordinates(grid :: %__MODULE__{}) :: list(tuple())
  def coordinates(grid) do
    for column <- 1..grid.columns, row <- 1..grid.rows, do: {column, row}
  end

  @doc """
  is_easter_extent() returns true if the given column is the farthest east in
  the grid.
  """
  @spec is_eastern_extent(grid :: %__MODULE__{}, column :: integer()) :: boolean()
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

  @doc """
  link() will link the cell at the given coordinate in the direction provided.
  """
  @spec link(grid :: %__MODULE__{}, coord :: tuple(), direction :: atom()) :: %__MODULE__{}
  def link(grid, coord, direction) do
    :ets.insert(grid.table, {coord, direction})

    grid
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
            case :ets.lookup(grid.table, {column, row}) do
              [{_coords, :east}] -> "    "
              _ -> "   |"
            end
          end)
      ])
    end

    defp row_bottom_boundary_string(acc, row, grid) do
      Enum.concat(acc, [
        "+"
        | Enum.map(1..grid.columns, fn column ->
            case :ets.lookup(grid.table, {column, row}) do
              [{_coords, :south}] -> "   +"
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
