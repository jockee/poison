defmodule ParserBench do
  use Benchfella

  # We wont test Jazz, since it's parser is simply an earlier version of
  # SafePoison's parser.

  bench "SafePoison", [json: gen_json] do
    SafePoison.Parser.parse!(json)
  end

  bench "jiffy", [json: gen_json] do
    :jiffy.decode(json, [:return_maps])
  end

  bench "JSX", [json: gen_json] do
    JSX.decode!(json, [:strict])
  end

  # UTF8 escaping
  bench "UTF-8 unescaping (SafePoison)", [utf8: gen_utf8] do
    SafePoison.Parser.parse!(utf8)
  end

  bench "UTF-8 unescaping (jiffy)", [utf8: gen_utf8] do
    :jiffy.decode(utf8)
  end

  bench "UTF-8 unescaping (JSX)", [utf8: gen_utf8] do
    JSX.decode!(utf8, [:strict])
  end

  defp gen_json do
    File.read!(Path.expand("data/generated.json", __DIR__))
  end

  defp gen_utf8 do
    text = File.read!(Path.expand("data/UTF-8-demo.txt", __DIR__))
    SafePoison.encode!(text) |> IO.iodata_to_binary
  end
end
