defmodule Twister.Grid do
  defstruct [:cells, :rows, :columns]

  @doc """
  new() returns a grid with the dimensions given in the params.

  ## Examples
    iex> Twister.Grid.new(4, 3)
    %Twister.Grid{cells: %{}, columns: 4, rows: 3}

  """
  @spec new(columns :: integer(), rows :: integer()) :: %__MODULE__{}
  def new(columns, rows) do
    %__MODULE__{cells: %{}, columns: columns, rows: rows}
  end
end