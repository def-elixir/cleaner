# Cleaner

## Installation

```bash
mix escript.install git https://github.com/def-elixir/cleaner.git
```

Add path

```bash
export PATH=$HOME/.mix/escripts:$PATH
```

## Descritption

Remove extra file and directory under the directory.
If argument 'path' is not specified, set default path '~/Desktop' 

cleanup [-all] path

The options are as follows:
| | |
| ---- | ---- |
| -all | remove directory also not only file |

## Uninstall

```bash
mix escript.uninstall cleanup
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cleaner` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cleaner, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/cleaner>.