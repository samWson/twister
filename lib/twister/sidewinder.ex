defmodule Twister.Sidewinder do
  alias Twister.Grid

  # REVIEW: the same public interface as BinaryTree. Might be an opportunity to
  # make a protocol

  @doc """
  on() links the cells of a grid together to form a maze using a sidewinder
  algorithm. Returns the linked grid.
  """
  @spec on(grid :: %Grid{}) :: %Grid{}
  def on(grid) do
    cells = grid.cells
    |> Enum.sort()
    |> Enum.chunk_every(grid.rows)


    linked_cells = visit_cells(grid, cells)

    %{grid | cells: Map.new(List.flatten(linked_cells))}
  end

  # Cells at this point:
  # [
  #   [
  #     {{1, 1}, %Twister.Cell{column: 1, links: [], row: 1}},
  #     {{1, 2}, %Twister.Cell{column: 1, links: [], row: 2}},
  #     {{1, 3}, %Twister.Cell{column: 1, links: [], row: 3}},
  #     {{1, 4}, %Twister.Cell{column: 1, links: [], row: 4}},
  #     {{1, 5}, %Twister.Cell{column: 1, links: [], row: 5}}
  #   ],
  # ...
  #   [
  #     {{4, 1}, %Twister.Cell{column: 4, links: [], row: 1}},
  #     {{4, 2}, %Twister.Cell{column: 4, links: [], row: 2}},
  #     {{4, 3}, %Twister.Cell{column: 4, links: [], row: 3}},
  #     {{4, 4}, %Twister.Cell{column: 4, links: [], row: 4}},
  #     {{4, 5}, %Twister.Cell{column: 4, links: [], row: 5}}
  #   ]
  # ]
  defp visit_cells(grid, cells) do
    Enum.map(cells, fn row_of_cells ->
      start_running(grid, row_of_cells, [])

      row_of_cells
    end)
  end

  defp start_running(grid, row_of_cells, linked_runs) do
    {run, remaining_row} = collect_run(row_of_cells, [])

    linked_run = link_run(run)

    IO.inspect(remaining_row)
    if length(remaining_row) != 0 do
      start_running(grid, remaining_row, [linked_runs | linked_run])
    end

    linked_runs
  end

  defp link_run(run) do
    run
    |> link_east()
    |> link_south()
  end

  defp link_east(run) do
    Enum.map(run, fn {coords, cell} ->
      {coords, %{cell | links: [:east]}}
    end)
  end

  defp link_south(run) do
    index = Enum.random(1..length(run)) - 1

    List.update_at(run, index, fn {coords, cell} ->
      {coords, %{cell | links: [:south | cell.links]}}
    end)
  end

  defp collect_run([], run) do
    {run, []}
  end

  defp collect_run(cells, run) do
    case flip_a_coin() do
      :tails ->
        collect_run(tl(cells), [hd(cells) | run])
      :heads ->
        {run, cells} # close the run
    end
  end

  # # TODO: when I get a run back I want to link all the cells of that run to the
  # # east (excluding the last). Then a random cell in that run is linked to the
  # # south. Move on to the next run until there are no more runs to consume.

  # # This can collect a run of cells along a row. The first list in the returned
  # # tuple is the run of coords. These first coords are the ones that are linked
  # # to the east (excluding the last). A random one of these coords is linked to
  # # the south.
  # #
  # # The same process continues with the remaining coords until the row is
  # # consumed.
  # @spec collect_run(coords :: [tuple()]) :: {[tuple()], [tuple()]}
  # def collect_run(coords) do
  #   collect_run(coords, [])
  # end

  # defp collect_run([], run) do
  #   {run, []}
  # end

  # defp collect_run(coords, run) do
  #   # REVIEW: an inefficiency, sometimes this will return an empty run without
  #   # having collected any coords. Maybe never close the run unless there is at
  #   # least one element in the run.
  #   case flip_a_coin() do
  #     :tails ->
  #       collect_run(tl(coords), [hd(coords) | run] )
  #     :heads ->
  #       {run, coords}
  #   end
  # end

  defp flip_a_coin() do
    Enum.random([:heads, :tails])
  end
end