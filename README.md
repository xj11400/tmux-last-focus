# tmux-last-focus

A tmux plugin to quickly switch back to the last focused pane across windows and sessions.

## Background

Switching back to the last focused pane in tmux:

- `tmux last-pane` can switch back to the last focused pane, but it only works within the same window.
- `tmux last-window` can switch back to the last focused window, but it only works within the same session.
- `tmux switch-client -l` can switch back to the last focused session.

This plugin extends this functionality to across windows and sessions.

## Installation

### TPM

Add the following to your `~/.tmux.conf`:

```tmux
set -g @plugin 'xj11400/tmux-last-focus'
```

Press `prefix + I` to fetch the plugin and source it.

### Manual Installation

Clone the repository and add this to `~/.tmux.conf`:

```tmux
run-shell "/path/to/tmux-last-focus/tmux-last-focus.tmux"
```

## Configuration

You can customize the plugin behavior by setting these options in your `~/.tmux.conf`:

| Option                    | Default   | Description                                      |
| :------------------------ | :-------- | :----------------------------------------------- |
| `@last-focus-key`         | `]`       | The key used to switch back (requires prefix).   |
| `@last-focus-flash`       | `off`     | Enable/disable the visual flash after switching. |
| `@last-focus-flash-color` | `#101010` | The color used for the focus flash background.   |

Example customization:

```tmux
set -g @last-focus-key 'L'
set -g @last-focus-flash 'on'
set -g @last-focus-flash-color '#333333'
```

## Usage

1. Move around your tmux panes and windows.
2. Press `prefix + ]` (or your custom key) to jump back to the previously focused pane.
3. The destination pane will briefly flash to indicate focus.

## Requirements

- `set -g focus-events on` (handled automatically by the plugin).
