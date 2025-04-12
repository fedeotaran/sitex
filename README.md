# Sitex

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sitex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sitex, "~> 0.1.0"}
  ]
end
```

## Usage

After installing the dependency, you can use the following commands to work with your static site:

### Initialize a new site
```bash
mix sitex.init
```
This will create the basic structure for your site, including:
- A `sitex.yml` configuration file
- Default theme templates
- Content directories
- Basic page structure

### Build the site
```bash
mix sitex.build
```
This command generates the static site in the build directory (default: `site/`). It processes all your markdown content and templates to create the final HTML files.

### Serve the site locally
```bash
mix sitex.serve
```
This command builds the site and starts a local development server. The server will automatically rebuild the site when you make changes to your content or templates.

### Project Structure
- `content/`: Contains your markdown content
  - `pages/`: Static pages
  - `posts/`: Blog posts
- `themes/`: Theme templates and assets
  - `default/`: Default theme
    - `templates/`: HTML templates
- `sitex.yml`: Configuration file

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sitex](https://hexdocs.pm/sitex).
