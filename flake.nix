{
  description = "Isolated Python development environment with uv and ZMK CLI";

  inputs = {
    nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # 1. Native packages provided by Nix
          packages = with pkgs; [
            python311 # Stable target for ZMK tool ecosystem
            uv # Lightning-fast package manager
            git # Required internally by the ZMK CLI setup
          ];

          # 2. Automated setup script that executes on environment entry
          shellHook = ''
            # Create a localized virtual environment inside the repository root
            if [ ! -d ".venv" ]; then
              uv venv .venv
            fi

            # Activate the virtual environment
            source .venv/bin/activate

            # Ensure ZMK package is pinned and operational via uv
            uv pip install --quiet zmk

          '';
        };
      }
    );
}
