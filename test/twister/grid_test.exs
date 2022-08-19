defmodule Twister.GridTest do
  use ExUnit.Case
  doctest Twister.Grid

  alias Twister.Grid

  setup do
    {:ok, grid: Grid.new(4, 5)}
  end

  describe "Grid extents" do
    test "the column is at the eastern exent", %{grid: grid} do
      assert Grid.is_eastern_extent(grid, 4)
    end

    test "the column is *not* at the eastern exent", %{grid: grid} do
      refute Grid.is_eastern_extent(grid, 1)
    end

    test "the row is at the southern extent", %{grid: grid} do
      assert Grid.is_southern_extent(grid, 5)
    end

    test "the row is *not* at the southern extent", %{grid: grid} do
      refute Grid.is_southern_extent(grid, 1)
    end
  end
end
