# OH-MY-ZSH
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="spaceship"
plugins=(common-aliases zsh-syntax-highlighting history-substring-search web-search docker git-flow docker-compose zsh-vi-mode zsh-autosuggestions)

# Override custom dir, inside custom themes or plugins
ZSH_CUSTOM=$HOME/.config/oh-my-zsh/custom
source $ZSH/oh-my-zsh.sh

# history-substring-search with vim mode
# https://github.com/zsh-users/zsh-history-substring-search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# fix history-substring-search for zsh-vi-mode overwriting bindings
# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
# The plugin will auto execute this zvm_after_lazy_keybindings function
# bindkey: https://github.com/zsh-users/zsh-history-substring-search
function my_init() {
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
}
zvm_after_init_commands+=(my_init)
# Disable the cursor style feature
# With true the terminal slows down
ZVM_CURSOR_STYLE_ENABLED=false

# Conditional so we do not load the file again when we are inside tmux
if [[ -z $TMUX ]]; then
  PATH_FILE=$HOME/.zsh/.path_macOS.sh
  source $PATH_FILE
fi

# User configuration
# EXTRA
alias cloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
alias zshconfig="vim $HOME/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias stmux="tmux attach -t dev || tmux new -s dev"
alias c="clear"
alias e="exit"
alias ssh="ssh -X"
alias g="git"
alias d="docker"
# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"
alias update_fzf="cd ~/.fzf && git pull && ./install"
alias update_dotfiles_submodules="cd ~/.homesick/repos/dotfiles-castle && git submodule update --init --recursive"

# Is replaced with fzf
bindkey '^R' history-incremental-pattern-search-backward

function nv() {
    if [ $# -eq 0 ]; then
        nvim .;
    else
        nvim "$@";
    fi;
}

# Override system vi
alias vi='vim'

# EXPORTS
export EDITOR='vim';
export VISUAL='vim';
# For good colors in tmux, TRUE COLOUR
export TERM='xterm-256color-italic'
alias ssh='TERM=xterm-256color ssh'

# 10ms for key sequences, for zsh and vim
export KEYTIMEOUT=1

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# FUNCTIONS
# C-Z back to nvim, vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# SOURCE PERSONAL
source ~/.personal.sh

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# FUNCTIONS AND COMPLETITIONS
# This is cause it was in the .path_macOS but when starting a tmux session the functions 
# where not available inside
[[ -s /usr/local/share/autojump/autojump.zsh ]] && source /usr/local/share/autojump/autojump.zsh

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf autocompletition for zsh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# ZSH completitions from brew
#==> Caveats
#To activate these completions, add the following to your .zshrc:
#
#  fpath=(/usr/local/share/zsh-completions $fpath)
#
#You may also need to force rebuild `zcompdump`:
#
#  rm -f ~/.zcompdump; compinit
#
#Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
#to load these completions, you may need to run this:
#
#  chmod go-w '/usr/local/share'
fpath=(/usr/local/share/zsh-completions $fpath)

# MVN alias
alias mvnis='mvn clean install -DskipTests -Djacoco.skip=true -Dcheckstyle.skip -DskipITs -Dfindbugs.skip=true'
alias mvnps='mvn clean package -DskipTests -Djacoco.skip=true -Dcheckstyle.skip -DskipITs -Dfindbugs.skip=true'

# Aliases for vim and kaleidoscope merge diff tool
alias gkdiff='git config diff.tool kaleidoscope; git difftool'
alias gkmerge='git config merge.tool kaleidoscope; git mergetool'

# Alias gls to ls for dircolors (brew install coreutils)
eval `gdircolors $HOME/.dircolors/dircolors-solarized/dircolors.ansi-dark` 
alias ls='gls --color -FGH'

# Like switchjdk 1.6|1.7|1.8|9|12
function switchjdk() {
  if [ $# -ne 0 ]; then
   removeFromPath '$JAVA_HOME/bin'
   if [ -n "${JAVA_HOME+x}" ]; then
    removeFromPath $JAVA_HOME
   fi
   export JAVA_HOME=`/usr/libexec/java_home -v $@`
   export PATH=$JAVA_HOME/bin:$PATH
  fi
}

function removeFromPath() {
  export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; update_dotfiles_submodules'
alias qtpy='jupyter qtconsole --ConsoleWidget.font_family="MonoLisa" --ConsoleWidget.font_size=16'
