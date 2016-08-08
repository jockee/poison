defmodule SafePoison do
  alias SafePoison.Encoder
  alias SafePoison.Decode
  alias SafePoison.Parser

  @doc """
  Encode a value to JSON.

      iex> SafePoison.encode([1, 2, 3])
      {:ok, "[1,2,3]"}
  """
  @spec encode(Encoder.t, Keyword.t) :: {:ok, iodata} | {:ok, String.t}
    | {:error, {:invalid, any}}
  def encode(value, options \\ []) do
    {:ok, encode!(value, options)}
  rescue
    exception in [SafePoison.EncodeError] ->
      {:error, {:invalid, exception.value}}
  end

  @doc """
  Encode a value to JSON as iodata.

      iex> SafePoison.encode_to_iodata([1, 2, 3])
      {:ok, [91, ["1", 44, "2", 44, "3"], 93]}
  """
  @spec encode_to_iodata(Encoder.t, Keyword.t) :: {:ok, iodata}
    | {:error, {:invalid, any}}
  def encode_to_iodata(value, options \\ []) do
    encode(value, [iodata: true] ++ options)
  end

  @doc """
  Encode a value to JSON, raises an exception on error.

      iex> SafePoison.encode!([1, 2, 3])
      "[1,2,3]"
  """
  @spec encode!(Encoder.t, Keyword.t) :: iodata | no_return
  def encode!(value, options \\ []) do
    iodata = Encoder.encode(value, options)
    unless options[:iodata] do
      iodata |> IO.iodata_to_binary
    else
      iodata
    end
  end

  @doc """
  Encode a value to JSON as iodata, raises an exception on error.

      iex> SafePoison.encode_to_iodata!([1, 2, 3])
      [91, ["1", 44, "2", 44, "3"], 93]
  """
  @spec encode_to_iodata!(Encoder.t, Keyword.t) :: iodata | no_return
  def encode_to_iodata!(value, options \\ []) do
    encode!(value, [iodata: true] ++ options)
  end

  @doc """
  Decode JSON to a value.

      iex> SafePoison.decode("[1,2,3]")
      {:ok, [1, 2, 3]}
  """
  @spec decode(iodata, Keyword.t) :: {:ok, Parser.t} | {:error, :invalid}
    | {:error, {:invalid, String.t}}
  def decode(iodata, options \\ []) do
    case Parser.parse(iodata, options) do
      {:ok, value} -> {:ok, Decode.decode(value, options)}
      error -> error
    end
  end

  @doc """
  Decode JSON to a value, raises an exception on error.

      iex> SafePoison.decode!("[1,2,3]")
      [1, 2, 3]
  """
  @spec decode!(iodata, Keyword.t) :: Parser.t | no_return
  def decode!(iodata, options \\ []) do
    Decode.decode(Parser.parse!(iodata, options), options)
  end
end
