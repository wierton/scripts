# Personal scripts and configuration

高频配置放在根目录，其余文件归入三个目录：

| 位置 | 内容 |
| --- | --- |
| 根目录 | `tmux.conf`、`bashrc`、`vimrc`、`zshrc`、`wierton.zsh-theme`（以实际存在的文件为准） |
| `config/` | Vim 插件和配色（含 `_vim/`）、Zsh 插件、clang-format、fstab、Windows Terminal 配置 |
| `tools/` | 安装、网络、壁纸等脚本，以及 Python/C 示例和 Makefile 模板 |
| `docs/` | Linux、网络和启动修复笔记 |

常用入口：

- `tools/install.sh`、`tools/old-install.sh`：历史环境安装脚本，按仓库根目录定位配置文件。
- `tools/ssh-reverse-relay.sh`：SSH 反向中继。
- `tools/256-colors.sh`、`tools/256-colors.py`：终端颜色预览。
- `tools/wifipasswd.sh`：查看 Wi-Fi 密码。
- `tools/rfc.sh`：浏览 RFC。
- `tools/get_score.sh`、`tools/get_score.py`：历史校园成绩查询脚本。
- `tools/wallpictures.sh`、`tools/wallpaper_download.sh`、`tools/wallpaper_inform.sh`：壁纸相关脚本。
