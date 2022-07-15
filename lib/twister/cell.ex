defmodule Twister.Cell do
  defstruct [:row, :column]

  @doc """
  new() returns a cell at the coordinates given in the params.

  ## Examples

    iex> Twister.Cell.new(1, 3)
    %Twister.Cell{column: 1, row: 3}
  """
  @spec new(column :: integer(), row :: integer()) :: %__MODULE__{}
  def new(column, row) do
    %__MODULE__{column: column, row: row}
  end
end