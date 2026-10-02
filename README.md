# 🍠 o1m0 dotfiles

My development environment configuration.

Windows + WSL / macOS で、できるだけ同じ開発環境を使うための dotfiles です。

## Environment

- WezTerm
- WSL / Ubuntu
- zsh
- Neovim
- Git
- Maple Mono NF

## Structure

```text
dotfiles/
├── nvim/
│   ├── init.lua
│   ├── lua/
│   └── lazy-lock.json
│
├── wezterm/
│   └── .wezterm.lua
│
├── zsh/
│   ├── .zshrc
│   └── boot.sh
│
├── install/
├── git/
├── .gitignore
└── README.md
```

## WezTerm

モノクロをベースに、オレンジ `#E8813C` をアクセントカラーとして使用。

### Features

- Maple Mono NF
- Transparent background
- Custom capsule tabs
- Automatic tab names
- Current directory display
- WSL / macOS support
- Vim-style pane navigation
- Custom startup animation

### Tab names

実行しているプログラムやディレクトリから自動で名前を決定します。

```text
 NVIM
 GO
 GIT
 NODE
 PYTHON
 DOCKER
󰉋 OSHIATO
```

通常のシェルでは現在のディレクトリ名を表示します。

### Key bindings

| Key | Action |
|---|---|
| `Alt + Shift + H` | Pane split |
| `Alt + Shift + V` | Pane split |
| `Alt + h` | Move left |
| `Alt + j` | Move down |
| `Alt + k` | Move up |
| `Alt + l` | Move right |
| `Ctrl + Shift + X` | Close pane |
| `Ctrl + Shift + T` | New tab |
| `Ctrl + Shift + W` | Close tab |
| `Alt + 1..9` | Switch tab |
| `Ctrl + Shift + C` | Copy |
| `Ctrl + Shift + V` | Paste |

## 🍠 Boot Animation

zsh 起動時に O1M0 のターミナル起動アニメーションを表示します。

```text
                 🍠

              O 1 M 0

           INITIALIZING

           ━━━━━━━━━━━━━

               READY
```

ターミナルサイズを取得して、表示サイズを自動調整します。

```bash
tput cols
tput lines
```

## Neovim

Neovim の設定は `nvim/` に保存しています。

```text
nvim/
├── init.lua
├── lua/
├── lazy-lock.json
└── setup.sh
```

Go / TypeScript / Python / Java などの開発環境を想定しています。

## Installation

現在は Windows + WSL 環境をメインに使用しています。

将来的には、

```bash
git clone <repository>
cd dotfiles
./install/install.sh
```

だけで環境を再構築できるようにする予定です。

## Platform

### Windows

```text
Windows
   ↓
WezTerm
   ↓
WSL / Ubuntu
   ↓
zsh
   ↓
Neovim
```

### macOS

```text
macOS
   ↓
WezTerm
   ↓
zsh
   ↓
Neovim
```

WezTerm の設定ファイルは共通化し、OS 固有設定のみ Lua 側で切り替えます。

---

Built for my development environment.

🍠 O1M0
