defmodule Twister.BinaryTree do
  alias Twister.Grid

  @doc """
  on() links the cells of a grid together to form a maze using a binary tree
  algorithm. Returns the linked grid.
  """
  @spec on(grid :: %Grid{}) :: %Grid{}
  def on(grid) do
    cells =
      Enum.map(grid.cells, fn {coord, cell} ->
        {coord, %{cell | links: link_cell(coord, grid)}}
      end)

    %{grid | cells: Map.new(cells)}
  end

  defp link_cell({column, row}, grid) do
    cond do
      Grid.is_eastern_extent(grid, column) && Grid.is_southern_extent(grid, row) ->
        []

      Grid.is_eastern_extent(grid, column) ->
        [:south]

      Grid.is_southern_extent(grid, row) ->
        [:east]

      true ->
        [Enum.random([:south, :east])]
    end
  end
end
