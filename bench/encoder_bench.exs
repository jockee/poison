defmodule EncoderBench do
  use Benchfella

  # Lists
  bench "lists (SafePoison)", [list: gen_list] do
    SafePoison.encode!(list)
  end

  bench "lists (jiffy)", [list: gen_list] do
    :jiffy.encode(list)
  end

  bench "lists (JSX)", [list: gen_list] do
    JSX.encode!(list)
  end

  bench "lists (Jazz)", [list: gen_list] do
    Jazz.encode!(list)
  end

  # Maps
  bench "maps (SafePoison)", [map: gen_map] do
    SafePoison.encode!(map)
  end

  bench "maps (jiffy)", [map: gen_map] do
    :jiffy.encode(map)
  end

  bench "maps (JSX)", [map: gen_map] do
    JSX.encode!(map)
  end

  bench "maps (Jazz)", [map: gen_map] do
    Jazz.encode!(map)
  end

  # Strings
  bench "strings (SafePoison)", [string: gen_string] do
    SafePoison.encode!(string)
  end

  bench "strings (jiffy)", [string: gen_string] do
    :jiffy.encode(string)
  end

  bench "strings (JSX)", [string: gen_string] do
    JSX.encode!(string)
  end

  bench "strings (Jazz)", [string: gen_string] do
    Jazz.encode!(string)
  end

  # String escaping
  bench "string escaping (SafePoison)", [string: gen_string] do
    SafePoison.encode!(string, escape: :unicode)
  end

  bench "string escaping (jiffy)", [string: gen_string] do
    :jiffy.encode(string, [:uescape])
  end

  bench "string escaping (JSX)", [string: gen_string] do
    JSX.encode!(string, [:uescape])
  end

  bench "string escaping (Jazz)", [string: gen_string] do
    Jazz.encode!(string, escape: :unicode)
  end

  # Structs
  bench "structs (SafePoison)", [structs: gen_structs] do
    SafePoison.encode!(structs)
  end

  bench "structs (JSX)", [structs: gen_structs] do
    JSX.encode!(structs)
  end

  bench "structs (Jazz)", [structs: gen_structs] do
    Jazz.encode!(structs)
  end

  bench "SafePoison", [data: gen_data] do
    SafePoison.encode!(data)
  end

  bench "jiffy", [data: gen_data] do
    :jiffy.encode(data)
  end

  bench "JSX", [data: gen_data] do
    JSX.encode!(data)
  end

  bench "Jazz", [data: gen_data] do
    Jazz.encode!(data)
  end

  bench "SafePoison (pretty)", [data: gen_data] do
    SafePoison.encode!(data, pretty: true)
  end

  bench "jiffy (pretty)", [data: gen_data] do
    :jiffy.encode(data, [:pretty])
  end

  bench "JSX (pretty)", [data: gen_data] do
    JSX.encode!(data) |> JSX.prettify!
  end

  bench "Jazz (pretty)", [data: gen_data] do
    Jazz.encode!(data, pretty: true)
  end

  defp gen_list do
    1..1000 |> Enum.to_list
  end

  defp gen_map do
    Stream.map(?A..?Z, &<<&1>>) |> Stream.with_index |> Enum.into(%{})
  end

  defp gen_string do
    Path.expand("data/UTF-8-demo.txt", __DIR__) |> File.read!
  end

  defmodule Struct do
    @derive [SafePoison.Encoder]
    defstruct x: nil
  end

  defp gen_structs do
    1..10 |> Enum.map(&(%Struct{x: &1}))
  end

  defp gen_data do
    Path.expand("data/generated.json", __DIR__) |> File.read! |> SafePoison.decode!
  end
end
