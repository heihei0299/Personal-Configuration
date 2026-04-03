# ~/.zshrc



# 项目或私有环境变量。
# 如需提高安全性，建议迁移到单独的私有文件中再 source。
export AUTH_TOKEN=123
export PROXY_TOKEN=123



# -----------------------------------------------------------------------------
# 工具链初始化
# -----------------------------------------------------------------------------
# fnm
FNM_PATH="/home/shial/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# 加载 .zsh_alias
source .zsh_aliases


# -----------------------------------------------------------------------------
# 历史记录与 shell 选项
# -----------------------------------------------------------------------------
# 控制历史记录的数量和保存位置。
HISTCONTROL=ignoreboth
HISTSIZE=1000
SAVEHIST=2000
HISTFILE="$HOME/.zsh_history"

# 追加写入历史、忽略重复项和以空格开头的命令，并在多窗口间共享历史。
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# 终端行为
# -----------------------------------------------------------------------------
# 在每次显示提示符前刷新终端尺寸变量，避免窗口缩放后行列数不准确。
autoload -Uz add-zsh-hook
update_terminal_size() {
  export LINES COLUMNS
}
add-zsh-hook precmd update_terminal_size

# -----------------------------------------------------------------------------
# Zinit 插件管理
# -----------------------------------------------------------------------------
# Zinit 安装目录；若不存在则自动克隆。
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "$(dirname "$ZINIT_HOME")"
[[ ! -d "$ZINIT_HOME/.git" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# 注册 Zinit 自身补全。
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# ==================== 插件配置（按需添加） ====================
# 🔹 必装基础插件
# 先加载补全扩展，再初始化 compinit，使扩展补全立即生效。
zinit light zsh-users/zsh-completions            # 丰富的命令补全库
zinit light zsh-users/zsh-syntax-highlighting    # 命令语法高亮

# -----------------------------------------------------------------------------




# -----------------------------------------------------------------------------
# 交互增强插件
# -----------------------------------------------------------------------------
# 🔹 异步延迟加载（不阻塞启动）
zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions      # 历史命令自动提示

zinit ice lucid wait='0'
zinit light agkozak/zsh-z                      # 快速目录跳转

zinit ice lucid wait='0'
zinit light Aloxaf/fzf-tab                     # fzf 命令补全

zinit ice lucid wait='0'
zinit light zsh-users/zsh-history-substring-search



# ==================== 初始化补全 ====================
autoload -Uz compinit
compinit


# -----------------------------------------------------------------------------
# 使用 starship 作为提示符；放在最后初始化，避免提示符被后续配置覆盖。
eval "$(starship init zsh)"




