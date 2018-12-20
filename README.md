# Tmux Indicators

Plugin that allows you to customize and configure indicators for your tmux session.

### Usage

You can add Tags to the status-left and/or status-right options for your status bar.

The following tags are available to use:

| Tag              | Description               |
|------------------|---------------------------|
| #{prefix}        | Prefix Indicator          |
| #{synchronized}  | Synchronized Indicator    |
| #{sharedsession} | Shared Sessions Indicator |

Examples:

```tmux.conf
set -g status-right '#{prefix} #{synchronized} #{sharedsession} | %a %Y-%m-%d %H:%M'
```

### Installation with Tmux Plugin Manager (recommended)

Add the plugin to the list of TPM plugins:

```tmux.conf
set -g @plugin 'https://git.linux-help.org/psi-jack/tmux-indicators'
```

Press prefix+I to install it.

### Manual Installation

Clone the repo:

```bash
$ git clone https://git.linux-help.org/psi-jack/tmux-indicators ~/clone/path
```

Add this line to your .tmux.conf:

```tmux.conf
run-shell ~/clone/path/indicators.tmux
```

Reload TMUX environment with:

```bash
tmux source-file ~/.tmux.conf
```

### Configurations

Configuring the various options can be done by setting the various settings in your tmux configuration with:

`set -g "setting" "value"`

And the following settings are available for each tag:

| Setting             | Description                        | Default |
|---------------------|------------------------------------|---------|
| @prefix_text        | Text for prefix indicator          | "⌨️  "   |
| @prefix_fg          | Prefix foreground color            |         |
| @prefix_bg          | Prefix background color            |         |
| @prefix_attr        | Prefix attribute options           |         |
| @synchronized_text  | Text for synchronized indicator    | "🔁 "   |
| @synchronized_fg    | Synchronized foreground color      |         |
| @synchronized_bg    | Synchronized background color      |         |
| @synchronized_attr  | Synchronized attribute options     |         |
| @sharedsession_text | Text for Shared Sessions indicator | "👓 "   |
| @sharedsession_fg   | Shared Sessions foreground color   |         |
| @sharedsession_bg   | Shared Sessions background color   |         |
| @sharedsession_attr | Shared Sessions attribute options  |         |

### License

[MIT](LICENSE)

