defmodule Twister.Cell do
  defstruct [:row, :column, :links]

  @doc """
  new() returns a cell at the coordinates given in the params.

  ## Examples

    iex> Twister.Cell.new(1, 3)
    %Twister.Cell{column: 1, row: 3, links: []}
  """
  @spec new(column :: integer(), row :: integer()) :: %__MODULE__{}
  def new(column, row) do
    %__MODULE__{column: column, row: row, links: []}
  end
end