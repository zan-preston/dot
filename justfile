user := env_var('USER')
host := "$(hostname -s)"
defaultUserAtHost := user + '@' + host

switch userAtHost=defaultUserAtHost:
  nix run . -- switch --flake .#{{userAtHost}}

build userAtHost=defaultUserAtHost:
  nix run . -- build --flake .#{{userAtHost}}

install-nix:
  curl -L https://nixos.org/nix/install | sh

fmt:
  find . -name "*.nix" | xargs nix develop --command alejandra
