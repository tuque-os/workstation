#!/usr/bin/env bash

set -euo pipefail

SRC_DIR="/usr/share/tuque-os/vscodium"
USER_DIR="${HOME}/.config/VSCodium/User"

EXTENSIONS=(
  "adpyke.codesnap"
  "asabil.meson"
  "bierner.markdown-preview-github-styles"
  "blueglassblock.better-json5"
  "bmalehorn.vscode-fish"
  "catppuccin.catppuccin-vsc"
  "charliermarsh.ruff"
  "coolbear.systemd-unit-file"
  "editorconfig.editorconfig"
  "esbenp.prettier-vscode"
  "golang.go"
  "llvm-vs-code-extensions.vscode-clangd"
  "mads-hartmann.bash-ide-vscode"
  "mkhl.shfmt"
  "ms-azuretools.vscode-containers"
  "ms-kubernetes-tools.vscode-kubernetes-tools"
  "ms-pyright.pyright"
  "nefrob.vscode-just-syntax"
  "nvarner.typst-lsp"
  "pkief.material-icon-theme"
  "redhat.ansible"
  "redhat.java"
  "redhat.vscode-yaml"
  "rust-lang.rust-analyzer"
  "samuelcolvin.jinjahtml"
  "tamasfe.even-better-toml"
  "timonwong.shellcheck"
  "xaver.clang-format"
  "zignd.html-css-class-completion"
)

echo "Installing extensions..."

for extension in "${EXTENSIONS[@]}"; do
  codium --install-extension "$extension"
done

echo "Copying settings..."

cp "${SRC_DIR}"/*.json "${USER_DIR}/"
