{ ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-t";
    mouse = false;
    terminal = "tmux-256color";
    escapeTime = 10;
    baseIndex = 1;
    historyLimit = 5000;
    keyMode = "vi";

    extraConfig = ''
      bind-key C-r source-file $HOME/.config/tmux/tmux.conf

      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Windows
      unbind-key f
      bind-key C-f command-prompt "find-window -Z -- '%%'"
      unbind-key c
      bind-key C-o new-window
      unbind-key n
      bind-key C-n next-window
      unbind-key p
      bind-key C-p previous-window
      unbind-key ,
      bind-key N command-prompt -I "#W" "rename-window -- '%%'"

      # Panes
      unbind-key %
      bind-key C-v split-window -h
      unbind-key '"'
      bind-key C-s split-window -v
      bind-key C-k select-pane -U
      bind-key C-l select-pane -R
      bind-key C-j select-pane -D
      bind-key C-h select-pane -L
      bind-key -r k resize-pane -U 1
      bind-key -r l resize-pane -R 1
      bind-key -r j resize-pane -D 1
      bind-key -r h resize-pane -L 1
      bind-key -r K resize-pane -U 5
      bind-key -r L resize-pane -R 5
      bind-key -r J resize-pane -D 5
      bind-key -r H resize-pane -L 5
      bind-key C-t resize-pane -Z
      unbind-key x
      bind-key C-q kill-pane
      unbind-key C-c
      bind-key C-c set-window-option synchronize-panes

      set -g window-style "bg=#2a2a2a"
      set -g window-active-style "bg=#000000"

      # Copy mode
      bind-key [ copy-mode
      bind-key ] paste-buffer
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

      # Status bar
      set-option -g status on
      set-option -g status-position bottom
      set-option -g status-bg green
      set-option -g status-fg black
    '';
  };
}
