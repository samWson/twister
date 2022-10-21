defmodule Twister.BinaryTree do
  alias Twister.Grid

  @doc """
  on() links the cells of a grid together to form a maze using a binary tree
  algorithm. Returns the linked grid.
  """
  @spec on(grid :: %Grid{}) :: %Grid{}
  def on(grid) do
    Enum.each(Grid.coordinates(grid), fn coord ->
      link_cell(grid, coord)
    end)

    grid
  end

  defp link_cell(grid, {column, row} = coord) do
    cond do
      Grid.is_eastern_extent(grid, column) && Grid.is_southern_extent(grid, row) ->
        grid

      Grid.is_eastern_extent(grid, column) ->
        Grid.link(grid, coord, :south)

      Grid.is_southern_extent(grid, row) ->
        Grid.link(grid, coord, :east)

      true ->
        direction = Enum.random([:south, :east])
        Grid.link(grid, coord, direction)
    end
  end
end
