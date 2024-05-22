##### Annotation
:<<'annotation'
# 1. Install zsh and change shell 
# apt install zsh
brew install zsh
chsh -s $(which zsh)
# 2. Install oh-my-zsh and plugin
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# 3. Options: HomeBrew accelerate mirrors
brew tap --custom-remote --force-auto-update homebrew/core https://mirrors.ustc.edu.cn/homebrew-core.git
brew tap --custom-remote --force-auto-update homebrew/cask https://mirrors.ustc.edu.cn/homebrew-cask.git
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
# 4. Install fonts = PowerlineFont
cd /tmp && git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh
annotation
#####


# oh-my-zsh Themes = https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

export PATH=/opt/homebrew/bin:$PATH
export ZSH="/Users/yakir/.oh-my-zsh"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

# Jetbrain Active
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
