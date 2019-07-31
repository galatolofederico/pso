# PSO: Pretty Straightforward Opener

`xdg-open` is bloated.

It is hard to configure, easy to mess up and its configuration is not portable.

`pso` is a portable **POSIX-compliant shell script** that is suppose to be a drop-in replacement for `xdg-open`.

`pso` have **no dependencies** other than the GNU Operating System.

It supports regular expressions, URIs and mime types. 

It can be easily configured by hand and it is capable **autoconfigure itself** while **using it**.

`pso` is a ~100 lines self explanatory script that can be collocated in the *suckless spectrum*

## Installation

Clone this repository somewhere (in this example `$HOME/.local/opt` )

```
mkdir -p $HOME/.local/opt && cd $HOME/.local/opt
git clone https://github.com/galatolofederico/pso.git && cd pso
```

Copy the configuration files

```
cp -r config.def/* ~/.config
```

Create a symbolic link named `xdg-open`

```
ln -s pso xdg-open
```

Add the folder to the `$PATH` of your X instance as **first element** (in order to override `xdg-open`). For example if you are using `.xinitrc` you have to add

```
export PATH=$HOME/.local/opt/pso:$PATH
```


## Configuration

The base configuration file is located in `$HOME/.config/pso.config` (although this can be changed setting the `PSO_CONFIG_FILE` environment variable).

It defines:

| Variable   | Meaning |
|:----------:|:-------------:|
| PSO_REGEX_CONFIG | Location of the `files regular expression association rules` file |
| PSO_MIME_CONFIG | Location of the `mime types regular expression association rules` file |
| PSO_URI_CONFIG | Location of the `URIs regular expression association rules` file |
| PSO_FOLDER_CMD | Command for opening the folders |
| PSO_ASK_MENU | Command for the application chooser menu (or "false" for disabling it) | 
| PSO_ASK_AUTOSAVE | Should pso save mime type associations when chosen? (true/false) | 
| PSO_LOG | Location of the log file (or "false" for disabling it) |  

you can check out the default values [here](https://github.com/galatolofederico/pso/blob/master/config.def/pso.config)

## Rules

`pso` behaves in this way:

* IF it have to handle a **folder**
    * Use the command specified in `PSO_FOLDER_CMD`
* If it have to handle a **file**:
    * Check the file name against the `files regular expression association rules` 
    * Check the mime type against the `mime types regular expression association rules`
* If it have to handle a **URI**:
    * Check the URI against the `URIs regular expression association rules`


Each rule is in the form:

```
parametric_command:rule
```

## Examples

If you want to open all your `pdf` with `zathura` you have to add
```
zathura %s:application/pdf
```
to the `$PSO_MIME_CONFIG` file.

Or if you want to open all your `text/` files with `st -e vim` you have to add
```
st -e "vim %s":text/.*
```


If you want to open all your `.log` files with `st -e vim` you have to add
```
st -e "vim %s":*\.log$
```
to the `$PSO_REGEX_CONFIG` file

If you want to copy to your clipboard the `magnet:` links you have to add
```
echo "%s" | xclip -selection clipboard:magnet:(.+)
```
to the `$PSO_URI_CONFIG` file.

If you want to open your folders with `set -e ranger` you have to set `$PSO_FOLDER_CMD` as:
```
PSO_FOLDER_CMD="st -e ranger %s"
```

The `parametric_command` are evaluated using `GNU printf`

The regular expressions are evaluated using `grep -E` extended regular expressions engine.


**pretty straightforward, isn't it?**


## License

This code is released under an open source license (in this case `GPLv3`) as all the code should be. Feel free to do [whatever you want](https://choosealicense.com/licenses/gpl-3.0/) with it :D 