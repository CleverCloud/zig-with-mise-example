# Deploy a Zig application on Clever Cloud

`Linux` runtime with Mise helps to deploy anything in a simple way on Clever Cloud. This example shows how to build a simple [Zig](https://ziglang.org/) Server on `8080` port, using [Clever Tools](https://github.com/CleverCloud/clever-tools/).

## Clone this repository and deploy (as easy as 1-2-3)

```bash
git clone https://github.com/CleverCloud/zig-with-mise-example
cd zig-with-mise-example

clever create -t linux
clever deploy
```

You don't need to configure anything, as Build and Run scripts are set up through the [mise.toml](mise.toml) file.
