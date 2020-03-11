
# To redraw line after fzf closes (printf '\e[5n')
bind '"\e[0n": redraw-current-line'
#bind '"\er": redraw-current-line'

_fzf_complete_hashcat() {
	toAdd=""
	if [ -n "${COMP_WORDS[COMP_CWORD]}" ]; then
		toAdd=" "
		prevArgNo="$COMP_CWORD"
	else
		prevArgNo="$(($COMP_CWORD - 1))"
	fi

	if [[ "${COMP_WORDS[prevArgNo]}" == "-m" || "${COMP_WORDS[prevArgNo]}" == "--hash-type" ]]; then
		local selected
		echo ""
		selected=$(hashcat --example-hashes | awk -v RS="\n\n" -F "\t" '{gsub("\n","\t",$0); print $1 "\t" $2}' | sed 's/MODE: //; s/TYPE: //' | fzf --reverse --height 40% | awk '{print $1}')
		if [ -n "$selected" ]; then
			printf "\e[5n"
			COMPREPLY=( "$selected" )
			return 0
		fi;

	fi


}

complete -F _fzf_complete_hashcat -o default -o bashdefault hashcat
