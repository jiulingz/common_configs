MAKEFLAGS = s

targets = bashrc bash_profile gitconfig gitignore inputrc vimrc nvim tmux.conf
build_targets = $(addsuffix .build, $(targets))
clean_targets = $(addsuffix .clean, $(targets))
diff_targets  = $(addsuffix .diff,  $(targets))

#==============================================================================
# batch operation
#==============================================================================
.PHONY: default build $(build_targets) clean $(clean_targets) diff $(diff_targets)
default:
	echo Targets:
	echo '' build clean diff
	echo '' $(build_targets)
	echo '' $(clean_targets)
	echo '' $(addsuffix ' ', $(diff_targets))

build: $(build_targets)
clean: $(clean_targets)
diff:  $(diff_targets)

divider = printf "%0.s=" {1..$(shell tput cols)}; printf "\n"

%_build:
	$(divider)
	if [ -f "$(BAK_FILE)" ]; then \
		echo "$(BAK_FILE)" already exits!!!!!!!!!!!!!; \
	else \
		if [ -f "$(DEST_FILE)" ]; then mv -v "$(DEST_FILE)" "$(BAK_FILE)"; fi; \
		cp -v "$(SRC_FILE)" "$(DEST_FILE)"; \
	fi

%_clean:
	if [ -f "$(BAK_FILE)" ]; then rm -v "$(BAK_FILE)"; fi

%_diff:
	$(divider)
	printf '%-20s%s\n' "$(SRC_FILE)" "$(DEST_FILE)"
	-diff "$(DEST_FILE)" "$(SRC_FILE)"

%_link:
	ln -s $(DEST_FILE) $(LINK_FILE)

#==============================================================================
# bash
#==============================================================================
bashrc%: SRC_FILE = ./bash/bashrc
bashrc%: DEST_FILE = $(HOME)/.bashrc
bashrc%: BAK_FILE = $(DEST_FILE).bak
bashrc.build: bashrc_build
bashrc.clean: bashrc_clean
bashrc.diff:  bashrc_diff

bash_profile%: SRC_FILE = ./bash/bash_profile
bash_profile%: DEST_FILE = $(HOME)/.bash_profile
bash_profile%: BAK_FILE = $(DEST_FILE).bak
bash_profile.build: bash_profile_build
bash_profile.clean: bash_profile_clean
bash_profile.diff:  bash_profile_diff

#==============================================================================
# git
#==============================================================================
gitconfig%: SRC_FILE = ./git/gitconfig
gitconfig%: DEST_FILE = $(HOME)/.gitconfig
gitconfig%: BAK_FILE = $(DEST_FILE).bak
gitconfig.build: gitconfig_build
gitconfig.clean: gitconfig_clean
gitconfig.diff:  gitconfig_diff

gitignore%: SRC_FILE = ./git/gitignore
gitignore%: DEST_FILE = $(HOME)/.gitignore
gitignore%: BAK_FILE = $(DEST_FILE).bak
gitignore.build: gitignore_build
gitignore.clean: gitignore_clean
gitignore.diff:  gitignore_diff

#==============================================================================
# readline
#==============================================================================
inputrc%: SRC_FILE = ./readline/inputrc
inputrc%: DEST_FILE = $(HOME)/.inputrc
inputrc%: BAK_FILE = $(DEST_FILE).bak
inputrc.build: inputrc_build
inputrc.clean: inputrc_clean
inputrc.diff:  inputrc_diff

#==============================================================================
# vim
#==============================================================================
vimrc%: SRC_FILE = ./vim/vimrc
vimrc%: DEST_FILE = $(HOME)/.vimrc
vimrc%: BAK_FILE = $(DEST_FILE).bak
vimrc.build: vimrc_build
vimrc.clean: vimrc_clean
vimrc.diff:  vimrc_diff

nvim%: SRC_FILE = ./vim/init.vim
nvim%: DEST_FILE = $(HOME)/.config/nvim/init.vim
nvim%: BAK_FILE = $(DEST_FILE).bak
nvim%: LINK_FILE = $(HOME)/.nvimrc
nvim.build: nvimrc_build nvimrc_link
nvim.clean: nvimrc_clean
nvim.diff:  nvimrc_diff

#==============================================================================
# tmux
#==============================================================================
tmux.conf%: SRC_FILE = ./tmux/tmux.conf
tmux.conf%: DEST_FILE = $(HOME)/.tmux.conf
tmux.conf%: BAK_FILE = $(DEST_FILE).bak
tmux.conf.build: tmux.conf_build
tmux.conf.clean: tmux.conf_clean
tmux.conf.diff:  tmux.conf_diff
