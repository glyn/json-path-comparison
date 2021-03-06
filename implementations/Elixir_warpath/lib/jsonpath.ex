defmodule Mix.Tasks.Execute do
  use Mix.Task

  def run(args) do
    json = IO.read(:stdio, :all)
    selector = hd(args)
    case Warpath.query(Poison.decode!(json), selector) do
      {:ok, result} -> IO.puts(Poison.encode!(result))
      {:error, exception} -> raise exception
    end
  end
end
