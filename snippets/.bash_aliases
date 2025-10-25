# ~/.bash_aliases (assuming you're using Bash)
# This is a collection of mostly-one-liners I've built up over the years for debugging Linux (or just making my life easier)
# While I didn't keep the links, some of these are from Stack Overflow/similar (thanks!)

# Reload aliases
alias alias_reload="source ~/.bash_aliases"
#alias bashrc_reload="source ~/.bashrc"
#alias session_reload="exec su -w "PWD,TERM_USER" -l $USER" # Note: this doesn't actually reload your session, it just creates a new session attached to your console. Useful for permissions changes but use "exit" or "logout" to come back

# Git
alias commit="git commit -m"

# Python
alias python="python3"
alias activate="source venv/bin/activate"
alias venv_i="virtualenv venv && source venv/bin/activate"
#alias jupyter_lab="tmux a -t jupyter || tmux new -s jupyter \"jupyter lab --no-browser --ip=0.0.0.0\""

# Kubernetes
alias apply="kubectl apply -f "
#alias kubectx='[[ $# -eq 0 ]] && kubectl config current-context || kubectl config use-context'
# For kubectl: if no parameters are passed, print current context. Otherwise, pass all parameters to the command to change contexts
function kubectx() {
        if [[ "$#" -eq "0" ]]
        then
                kubectl config current-context
        else
                kubectl config use-context $@
        fi
}

# Random debugging
alias bigfiles="find ./ -type f -printf '%s %p\n' | sort -nr | head -10"
alias ports_in_use="sudo lsof -i -P -n | grep LISTEN"
alias killed_processes="sudo dmesg -T | egrep -i 'killed process'"
alias groups_one_per_line="groups | cut -d: -f4 | tr ' ' '\n' | sort -u"

# Other
alias isrebootrequired="[ -f \"/var/run/reboot-required\" ] && echo \"Reboot required\" || echo \"No reboot required\""
alias uefi="systemctl reboot --firmware-setup"
