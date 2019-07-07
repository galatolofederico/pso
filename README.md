# PSO: Pretty Straightforward Opener

`xdg-open` is bloated.

It is hard to configure, easy to mess up and its configuration is not portable.

`pso` is a portable **POSIX Compliant shell script** that is suppose to be a drop-in replacement for `xdg-open`.

`pso` have **no dependencies** other than the GNU Operating System.

It supports Regular Expressions, URIs and mime types. It can be easily configured by hand and it is capable autoconfigure itself while using it.

## Installation

Clone this repository

```
cmd
```

Copy the configuration files

```
cp -r config.def/* ~/.config
```

Create a symbolic link named xdg-open

```
ln -s xdg-open pso
```

