PROMPT_DIRTRIM=4
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
PS1='[ \[\e[1;4m\]\t\[\e[0m\] ] ( \[\e[1;3m\]\u@\h\[\e[0m\] ) ( \[\e[2;4m\]${PS1_CMD1}\[\e[0m\] )\n(\[\e[1;2m\]\w\[\e[0m\]) \[\e[1m\]\$\[\e[0m\] '
