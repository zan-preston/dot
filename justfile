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

darwin-build host=host:
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- build --flake .#{{host}}

darwin-switch host=host:
  nix run --extra-experimental-features nix-command --extra-experimental-features flakes nix-darwin -- switch --flake .#{{host}}
