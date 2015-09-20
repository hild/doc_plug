# DocPlug

**This plug is intended for development only. Disable it in production.**

A utility [plug](https://github.com/elixir-lang/plug) for developers that
automatically generates documentation for a project when it is started and
serves it under "/docs". Intended for use with
[ExDoc](https://github.com/elixir-lang/ex_doc). Note that this plug assumes
that documentation generation for your project has already been set up.


## Plug Options

- `task`: The name of the mix task to run to generate docs. Defaults to
  `"docs"`.
- `from`: The directory on the filesystem the generated documentation can be
  found. Defaults to `"doc"`.
- `at`: The path to serve the docs from. Defaults to `"docs/"`.
- `generate`: If the documentation should be generated on starting the
  server, defaults to `true`.

