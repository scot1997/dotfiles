# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/scot/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git 
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#Rofi reverse shell
alias getshell="./Documents/Rofi/rofi-reverse-shells"
#Searchsploit ss
alias ss="tail -n +2 /usr/share/exploitdb/files_exploits.csv | awk -F ',' '{print \$2 \"\t\" \$3 \"\t(\" \$1 \")\"}' | fzf --preview-window=up --preview='echo {} | cut -d\"	\" -f1 | xargs echo \"/usr/share/exploitdb/\" | tr -d \" \" | xargs bat --color=always' | cut -d'	' -f3 | tr -d \"()\" | xargs searchsploit -m"

#Grep IP addresses from a file
alias ipgrep="grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'"

# Always make grep ouput color
alias grep="grep --color=auto"

#Open the thunar file explorer within the terminal
alias files="thunar \$PWD >/dev/null 2>/dev/null & disown"

#Start of autocd
function mycd() {
	cd "$@" 2> /dev/null
	if [ $? = 0 ]; then
		# If we get here cd was successful
		ls
	else
		# If we get here, cd was not successful
		if [ -f "$1" ]; then
			$EDITOR "$1"
		else
			echo "Can't cd"
		fi
	fi
}
alias cd="mycd"
#end of autocd

#fd alias for FZF (Works with wordlist below)
alias fd='fdfind'

###Start of wordlist FZF ^P
# this rg command will get a list of files that are not in gitignore or similar
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || ( bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -500'"
# this is the argument completeion optionm, use the same command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
if [ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]; then

	source /usr/share/doc/fzf/examples/key-bindings.zsh
	source /usr/share/doc/fzf/examples/completion.zsh
# SHORTCUT
	__fsel_wordlist() {
		local cmd="$FZF_DEFAULT_COMMAND --exclude \*.md --exclude \*.gif --exclude \*.jpg --exclude \*.png --exclude \*.lua --exclude \*.jar --exclude \*.pl '' /usr/share/wordlists/ | sed 's#^/usr/share/wordlists/##'"
		setopt localoptions pipefail 2> /dev/null
		eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS --preview 'bat --color=always {}'" $(__fzfcmd) -m "$@" | while read item; do
			echo -n "${(q)item} "
		done
		local ret=$?
		echo
		return $ret
	}

	fzf-wordlist-widget() {
		LBUFFER="${LBUFFER}$(__fsel_wordlist)"
		local ret=$?
		zle reset-prompt
		return $ret
	}
	zle     -N   fzf-wordlist-widget
	bindkey '^P' fzf-wordlist-widget

fi
###End of wordlist FZF


### Start of Keybinding###

    # create a zkbd compatible hash;
    # to add other keys to this hash, see: man 5 terminfo
    typeset -g -A key

    key[Home]="${terminfo[khome]}"
    key[End]="${terminfo[kend]}"
    key[Insert]="${terminfo[kich1]}"
    key[Backspace]="${terminfo[kbs]}"
    key[Delete]="${terminfo[kdch1]}"
    key[Up]="${terminfo[kcuu1]}"
    key[Down]="${terminfo[kcud1]}"
    key[Left]="${terminfo[kcub1]}"
    key[Right]="${terminfo[kcuf1]}"
    key[PageUp]="${terminfo[kpp]}"
    key[PageDown]="${terminfo[knp]}"
    key[ShiftTab]="${terminfo[kcbt]}"

    # setup key accordingly
    [[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
    [[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
    [[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
    [[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
    [[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
    [[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
    [[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
    [[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
    [[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
    [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
    [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
    [[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

    # Finally, make sure the terminal is in application mode, when zle is
    # active. Only then are the values from $terminfo valid.
    if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    	autoload -Uz add-zle-hook-widget
    	function zle_application_mode_start { echoti smkx }
    	function zle_application_mode_stop { echoti rmkx }
    	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
    fi

    autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search

    [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
    [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search


    # By default, Ctrl+d will not close your shell if the command line is filled, this fixes it:
    exit_zsh() { exit }
    zle -N exit_zsh
    bindkey '^D' exit_zsh

    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey '\C-x\C-e' edit-command-line

    bindkey -M viins jj vi-cmd-mode

    # Make CTRL-Z background things and unbackground them.
    # Based off https://github.com/wincent/wincent/commit/30b502d811fbf4ca058db3a6f006aaecab68f6b7
    function fg-bg() {
    	if [[ $#BUFFER -eq 0 ]]; then
    		local backgroundProgram="$(jobs | tail -n 1 | awk '{print $4}')"
    		if [[ "$backgroundProgram" == "nc" ]] || [[ "$backgroundProgram" == "ncat" ]]; then
    			# Make sure that /dev/tty is given to the stty command
    			local columns=$(stty -a < /dev/tty | grep -oE 'columns [0-9]+' | cut -d' ' -f2)
    			local rows=$(stty -a < /dev/tty | grep -oE 'rows [0-9]+' | cut -d' ' -f2)
    			notify-send "Terminal dimensions" "Rows: $rows\nColumns: $columns\nstty command on clipboard"
    			echo "stty rows $rows cols $columns" | clip
    			stty raw -echo < /dev/tty; fg
    		else
    			fg
    		fi
    	else
    		zle push-input
    	fi
    }
    zle -N fg-bg
    bindkey '^Z' fg-bg
###End of keybindings###
