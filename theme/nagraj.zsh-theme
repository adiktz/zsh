
#variables
local PL_BRANCH_CHAR=$'\ue0a0'
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local venv_prompt="$(virtualenv_prompt_info)"

if [[ $UID -eq 0 ]]; then
    local user_host="%{$fg_bold[red]%}%n@%m%{$reset_color%}"
    local user_symbol='#'
else
    local user_host="%{$fg_bold[green]%}%n@%m%{$reset_color%}"
    local user_symbol='$'
fi

#Get Git Prompt
function gitPrompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep -i 'nothing to commit' &> /dev/null) ; then
      STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e 'Changes to be committed' &> /dev/null); then
    STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e 'Changes not staged' &> /dev/null); then
    STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep 'Untracked files' &> /dev/null); then
    STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e 'unmerged' &> /dev/null); then
    STATUS="$STATUS $ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS="$STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX "
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function userPrompt() {
#	echo "user:($user_host) "
}

fun filePath() {
	local filePrefix="%{$reset_color%}file:("
	local fileSuffix="%{$reset_color%})"
	local folder="%{$fg[magenta]%}%~"
	echo "%{$reset_color%}$filePrefix$folder$fileSuffix "
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '® ' && return
    echo '○ '
}

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

#PROMPT Defination
PROMPT='╭─$(userPrompt)$(filePath)$(gitPrompt)$venv_prompt
╰─%B${user_symbol}%b '
RPROMPT="%B${return_code}%b"

#Constants
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}git:(%{$FG[098]%}$PL_BRANCH_CHAR "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[040]%}● Files Staged"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[178]%}● Files Unstaged"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}● Files Untracked"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}✕"