# clone repo
git clone --recursive https://github.com/hhsnopek/dotfiles.git

# setup
mkdir -p ${HOME}/.config

# git - https://git-scm.com/
mkdir -p $HOME/.config/git-templates
ln -sf ${PWD}/git/hooks ${HOME}/.config/git-templates/hooks
ln -sf ${PWD}/git/.gitconfig ${HOME}
ln -sf ${PWD}/git/.gitignore ${HOME}

# npm - https://www.npmjs.com
ln -sf ${PWD}/.npmrc $HOME

# neovim - https://neovim.io
ln -sf ${PWD}/.nvim $HOME/.config/nvim
ln -sf ${PWD}/.nvimrc $HOME/.config/nvim/init.vim

# kvm - https://github.com/koekeishiya/kwm
mkdir -p ${HOME}/.kwm
ln -sf ${PWD}/.kwm/kwmrc ${HOME}/.kwm/kwmrc
ln -sf ${PWD}/.kwm/rules ${HOME}/.kwm/rules

# bash - https://www.gnu.org/software/bash
mkdir -p ${HOME}/.config/bash
ln -sf ${PWD}/bash/prompt.sh ${HOME}/.config/bash/prompt.sh
ln -sf ${PWD}/bash/motd.sh ${HOME}/.config/bash/motd.sh

# alacritty - https://github.com/jwilm/alacritty
mkdir -p ${HOME}/.config/alacritty
ln -sf ${PWD}/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

echo "To finish installation open nvim and run ':PlugInstall'"
