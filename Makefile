MAKEFLAGS = iks

targets = bashrc bash_profile gitconfig gitignore inputrc vimrc tmux.conf
build_targets = $(foreach t, $(targets), $t_build)
clean_targets = $(foreach t, $(targets), $t_clean)
diff_targets = $(foreach t, $(targets), $t_diff)

_divider = \
	printf "%0.s=" {1..$(shell tput cols)}; printf "\n";

_build = $(_divider) \
	if [ -f "$(DEST_FILE)" ]; then mv -v "$(DEST_FILE)" "$(BAK_FILE)"; fi; \
	cp -v "$(SRC_FILE)" "$(DEST_FILE)";

_clean = \
	if [ -f "$(BAK_FILE)" ]; then rm -v "$(BAK_FILE)"; fi;

_diff  = $(_divider) \
	printf '%-20s%s\n' "$(SRC_FILE)" "$(DEST_FILE)"; \
	diff "$(DEST_FILE)" "$(SRC_FILE)";

.PHONY: all build $(build_targets) clean $(clean_targets) diff $(diff_targets)
all:
	echo Please specify target

#==============================================================================
# batch operation
#==============================================================================
build: $(build_targets)
clean: $(clean_targets)
diff:  $(diff_targets)

#==============================================================================
# bash
#==============================================================================
bashrc%: SRC_FILE = ./bash/bashrc
bashrc%: DEST_FILE = $(HOME)/.bashrc
bashrc%: BAK_FILE = $(DEST_FILE).bak
bashrc_build:
	$(_build)
bashrc_clean:
	$(_clean)
bashrc_diff:
	$(_diff)

bash_profile%: SRC_FILE = ./bash/bash_profile
bash_profile%: DEST_FILE = $(HOME)/.bash_profile
bash_profile%: BAK_FILE = $(DEST_FILE).bak
bash_profile_build:
	$(_build)
bash_profile_clean:
	$(_clean)
bash_profile_diff:
	$(_diff)

#==============================================================================
# git
#==============================================================================
gitconfig%: SRC_FILE = ./git/gitconfig
gitconfig%: DEST_FILE = $(HOME)/.gitconfig
gitconfig%: BAK_FILE = $(DEST_FILE).bak
gitconfig_build:
	$(_build)
gitconfig_clean:
	$(_clean)
gitconfig_diff:
	$(_diff)

gitignore%: SRC_FILE = ./git/gitignore
gitignore%: DEST_FILE = $(HOME)/.gitignore
gitignore%: BAK_FILE = $(DEST_FILE).bak
gitignore_build:
	$(_build)
gitignore_clean:
	$(_clean)
gitignore_diff:
	$(_diff)

#==============================================================================
# readline
#==============================================================================
inputrc%: SRC_FILE = ./readline/inputrc
inputrc%: DEST_FILE = $(HOME)/.inputrc
inputrc%: BAK_FILE = $(DEST_FILE).bak
inputrc_build:
	$(_build)
inputrc_clean:
	$(_clean)
inputrc_diff:
	$(_diff)

#==============================================================================
# vim
#==============================================================================
vimrc%: SRC_FILE = ./vim/vimrc
vimrc%: DEST_FILE = $(HOME)/.vimrc
vimrc%: BAK_FILE = $(DEST_FILE).bak
vimrc_build:
	$(_build)
vimrc_clean:
	$(_clean)
vimrc_diff:
	$(_diff)

#==============================================================================
# tmux
#==============================================================================
tmux.conf%: SRC_FILE = ./tmux/tmux.conf
tmux.conf%: DEST_FILE = $(HOME)/.tmux.conf
tmux.conf%: BAK_FILE = $(DEST_FILE).bak
tmux.conf_build:
	$(_build)
tmux.conf_clean:
	$(_clean)
tmux.conf_diff:
	$(_diff)
