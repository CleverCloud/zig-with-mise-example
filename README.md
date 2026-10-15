# Deploy a Zig application on Clever Cloud
[![Clever Cloud - PaaS](https://img.shields.io/badge/Clever%20Cloud-PaaS-orange)](https://clever-cloud.com)

This is a minimal HTTP server written in [Zig](https://ziglang.org/) using only the standard library (`std.Io.net`). It answers every request with a plain-text greeting and listens on `0.0.0.0` on the port given by the `PORT` environment variable (`8080` on Clever Cloud).

It runs on the Clever Cloud `Linux` runtime, where [mise](https://mise.jdx.dev/) installs the Zig toolchain and runs the build and start tasks for you.

## How it works

The [`mise.toml`](mise.toml) file declares everything the `Linux` runtime needs:

- `[tools]` pins the Zig version (`0.17.0`), which mise installs during the build.
- `[tasks.build]` compiles the server with `zig build-exe server.zig -O ReleaseSafe`.
- `[tasks.run]` starts the resulting `./server` binary.

Clever Cloud detects the `build` and `run` tasks automatically, so no environment variable is required.

The server uses the Zig 0.16+ I/O model: `main` receives a `std.process.Init`, which provides the `Io` implementation and the environment map used to read `PORT`.

## Project structure

```
.
├── mise.toml    # Zig version, build and run tasks
├── server.zig   # The HTTP server (standard library only)
├── CHANGELOG.md # Maintenance history
└── README.md
```

## Deployment steps

With [Clever Tools](https://github.com/CleverCloud/clever-tools/) installed and logged in:

```bash
git clone https://github.com/CleverCloud/zig-with-mise-example
cd zig-with-mise-example

clever create -t linux
clever deploy
clever open
```

You can also give your application a custom domain with `clever domain add <your-domain>`.

## Running locally

With [mise](https://mise.jdx.dev/) installed:

```bash
mise install
mise run build
mise run run
```

Then open <http://localhost:8080>, or use another port with `PORT=3000 mise run run`.

## Troubleshooting

- Check the build and runtime output with `clever logs`.
- Check the environment variables with `clever env`.
- The server must listen on `0.0.0.0:8080` (or `$PORT`) for Clever Cloud to route traffic to it.
- Zig minor releases often change the standard library API: if you change the version in `mise.toml`, expect to adapt `server.zig`.

## Contributing

Issues and pull requests are welcome on [GitHub](https://github.com/CleverCloud/zig-with-mise-example).

## License

This example is provided as-is by [Clever Cloud](https://clever-cloud.com) for demonstration purposes.
