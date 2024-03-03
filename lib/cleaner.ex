defmodule Cleaner.CLI do
  @moduledoc """
  Documentation for `Cleaner.CLI`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cleaner.hello()
      :world

  """

  @default "~/Desktop"
  @protected ["/", "~/"]

  def main(argv) do
    {opts, args} = OptionParser.parse!(argv, strict: [all: :boolean])

    path = if args == [], do: [@default], else: args

    if opts[:all] do
      Enum.each(path, &remove(:all, &1))
    else
      Enum.each(path, &remove(:file, &1))
    end
  end

  defp remove(:all, path) do
    with {:ok, abspath} <- to_abspath(path),
          :ok <- validate_path(abspath) do
      abspath
      |> Path.join("/**")
      |> Path.wildcard(match_dot: true)
      |> rm_rf()
    else
      {:error, reason} ->
        IO.puts formatter(:error, reason)
    end
  end

  defp remove(:file, path) do
    with {:ok, abspath} <- to_abspath(path),
          :ok <- validate_path(abspath) do
      abspath
      |> Path.join("/*")
      |> Path.wildcard(match_dot: true)
      |> Enum.filter(&File.regular?/1)
      |> rm()
    else
      {:error, reason} ->
        IO.puts formatter(:error, reason)
    end
  end

  defp rm_rf([]) do
    IO.puts "Nothing to delete."
  end

  defp rm_rf(entry) do
    entry
    |> confirm_deletion()
    |> Enum.each(fn path ->
      File.rm_rf!(path)
      IO.puts "#{path}: deleted."
    end)
    :ok
  end

  defp rm([]) do
    IO.puts "Nothing to delete."
  end

  defp rm(entry) do
    entry
    |> confirm_deletion()
    |> Enum.each(fn path ->
      File.rm!(path)
      IO.puts "#{path}: deleted."
    end)
    :ok
  end

  defp to_abspath(path) when path == "", do: {:error, "Path argument: \"\" not allowed."}
  defp to_abspath(path), do: {:ok, Path.expand(path)}

  defp validate_path(path) do
    with {:ok, _} <- path_exists(path),
         {:ok, _} <- in_protected_path(path) do
          :ok
    else
      {:error, message} -> {:error, message}
    end
  end

  defp path_exists(path) do
    case File.exists?(path) do
      true  -> {:ok, path}
      false -> {:error, "#{path}: No such file or directory."}
    end
  end

  defp in_protected_path(path) do
    protected = @protected |> Enum.map(&Path.expand/1)
    case path in protected do
      false -> {:ok, path}
      true  -> {:error, "Directory #{path} is protected."}
    end
  end

  defp confirm_deletion(entry) do
    entry |> Enum.each(&IO.puts/1)
    IO.gets "Really want to delete? [Enter]"
    entry
  end

  defp formatter(:error, msg), do: inspect("#{msg}", syntax_colors: [string: [:red]])

end
