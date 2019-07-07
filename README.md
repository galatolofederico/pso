# PSO: Pretty Straightforward Opener

`xdg-open` is bloated.

It is hard to configure, easy to mess up and its configuration is not portable.

`pso` is a portable **POSIX-compliant shell script** that is suppose to be a drop-in replacement for `xdg-open`.

`pso` have **no dependencies** other than the GNU Operating System.

It supports regular expressions, URIs and mime types. It can be easily configured by hand and it is capable autoconfigure itself while using it.

`pso` is a ~100 lines self explanatory script that can be collocated in the *suckless spectrum*

## Installation

Clone this repository

```
git clone https://github.com/galatolofederico/pso.git && cd pso
```

Copy the configuration files

```
cp -r config.def/* ~/.config
```

Create a symbolic link named xdg-open

```
ln -s pso xdg-open
```

Add this folder to your `$PATH` as **first element**


## Configuration

The base configuration file is located in `$HOME/.config/pso.config` (although this can be changed setting the `PSO_CONFIG_FILE` environment variable).

It defines:

| Variable   | Meaning |
|:----------:|:-------------:|
| PSO_REGEX_CONFIG | Location of the `files regular expression association rules` file |
| PSO_MIME_CONFIG | Location of the `mime types association rules` file |
| PSO_URI_CONFIG | Location of the `URIs regular expression association rules` file |
| PSO_ASK_MENU | Command for the application choosing menu | 
| PSO_ASK_AUTOSAVE | Should pso save mime type associations when chosen? | 


`pso` behaves in this way:

* If it have to handle a **file**:
    * Check the file name against the `files regular expression association rules` 
    * Check the mime type against the `mime types association rules`
* If it have to handle a **URI**:
    * Check the URI against the `URIs regular expression association rules`


## Rules

Each rule is in the form:

```
parametric_command:rule
```

For example if you want to open all your `pdf` with `zathura` you have to add
```
zathura %s:application/pdf
```
to the `$PSO_MIME_CONFIG` file.


Or if you want to open all your `.log` files with `st -e vim` you have to add
```
st -e "vim %s":*\.log$
```
to the `$PSO_REGEX_CONFIG` file

Or even if you want to copy to your clipboard the `magnet:` links you have to add
```
echo "%s" | xclip -selection clipboard:magnet:(.+)
```
to the `$PSO_URI_CONFIG` file.

**pretty straightforward, isn't it?**