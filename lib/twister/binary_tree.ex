defmodule Twister.BinaryTree do
  alias Twister.Grid

  @doc """
  on() links the cells of a grid together to form a maze using a binary tree
  algorithm. Returns the linked grid.
  """
  @spec on(grid :: %Grid{}) :: %Grid{}
  def on(grid) do
    cells =
      Enum.map(grid.cells, fn {coord, cell} -> {coord, %{cell | links: [random_direction()]}} end)

    %{grid | cells: Map.new(cells)}
  end

  defp random_direction() do
    Enum.random([:south, :east])
  end
end
