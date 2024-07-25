{
  pkgs,
  lib,
  makeGhReleasePkg,
  ...
}:
with pkgs; [
  # fonts
  fontconfig
  (nerdfonts.override {fonts = ["Hack"];})

  # terminal, shell and editor
  zsh
  warp-terminal
  wezterm
  tmux
  pam-reattach # for tmux touch id support
  starship
  neovim

  # cli tools
  git
  bat
  tree
  eza
  fzf
  fd
  gawk
  thefuck
  ripgrep
  jq
  yq
  wget
  htop
  neofetch
  pngpaste
  slides
  vhs

  # k8s tools
  k9s
  helm-docs
  kustomize

  # asdf
  # we do not install any langs using nix
  # asdf manages tooling versions via ./.tool-versions
  asdf-vm

  # language tools
  terraform-ls
  tflint
  gopls
  gotools
  golines
  golangci-lint
  air
  stylua
  prettierd
  eslint_d
  statix
  alejandra
  yamlfmt
  yamllint

  # other
  gnupg
  ollama

  # custom packages from my public git repos
  (makeGhReleasePkg
    {
      pname = "shed";
      fname = "shed-darwin-arm64";
      version = "v0.0.3";
      repo = "shed";
      owner = "shanehull";
      sha256 = "sha256-McEzuLE6+xKwNb5PtXrLVb0GyH1hRQSr5yPLvm9WKzQ=";
    })
  (makeGhReleasePkg
    {
      pname = "quickval";
      fname = "quickval-darwin-arm64";
      version = "latest";
      repo = "quickval";
      owner = "shanehull";
      sha256 = "sha256-Pxtz5kFfZt24PG6Z19N9obm2mCXwB8z/qdptPqmkZ1o=";
    })
]
