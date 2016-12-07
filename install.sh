# clone repo
# git clone --recursive https://github.com/hhsnopek/dotfiles.git

# setup
mkdir -p ${HOME}/.config

# git
mkdir -p $HOME/.config/git-templates
ln -sf ${PWD}/git/hooks ${HOME}/.config/git-templates/hooks
ln -sf ${PWD}/git/.gitconfig $HOME
ln -sf ${PWD}/git/.gitignore $HOME

# neovim
ln -sf ${PWD}/.nvim $HOME/.config/nvim
ln -sf ${PWD}/.nvimrc $HOME/.config/nvim/init.vim

# kvm
mkdir -p ${HOME}/.kwm
ln -sf ${PWD}/.kwm/kwmrc ${HOME}/.kwm/kwmrc
ln -sf ${PWD}/.kwm/rules ${HOME}/.kwm/rules

# bash
mkdir -p ${HOME}/.config/bash
ln -sf ${PWD}/bash/prompt.sh ${HOME}/.config/bash/prompt.sh
ln -sf ${PWD}/bash/motd.sh ${HOME}/.config/bash/motd.sh

echo "To finish installation open nvim and run ':PlugInstall'"
