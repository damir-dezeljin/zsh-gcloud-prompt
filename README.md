# zsh-gcloud-prompt for GCP Cloud Shell
This script is derived from the original [zsh-gcloud-prompt](https://github.com/ocadaruma/zsh-gcloud-prompt).

The above mentioned script didn't work for me in ZSH shell in a GCP Cloud Shell, as the watched files never
changed. So I scheduled a `gcloud config get-value project` every 5 seconds and updated a local file in the
user `$HOME` directory.

**NOTE:** I just needed gCloud project name, which I exported to `ZSH_GCLOUD_PROJECT`.

## Installation

#### Oh My ZSH setup

1. Plugin installation
   ```bash
   $ git clone git@github.com:damir-dezeljin/zsh-gcloud-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-gcloud-prompt
   ```
2. Enable the plugin by editing your `~/.zshrc` and add `zsh-gcloud-prompt` to the end of `plugins` line like:
   ```bash
   plugins=(... zsh-gcloud-prompt)
   ```
3. Use the `$ZSH_GCLOUD_PROJECT` in your `PROMPT` configuration. <br>
   Example in my case I used it in `~/.oh-my-zsh/themes/robbyrussell.zsh-theme` by adding:
   ```bash
   PROMPT+=' (%{$fg[yellow]%}$ZSH_GCLOUD_PROJECT%{$reset_color%}) '
   ```
