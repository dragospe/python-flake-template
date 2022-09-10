{
  description = "Flake to manage python workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # https://github.com/DavHau/mach-nix/issues/153#issuecomment-717690154

      in
      {
        devShell = (pkgs.poetry2nix.mkPoetryEnv { projectDir = ./.; }).env.overrideAttrs (oldAttrs: {
          buildInputs = with pkgs;
            [
              nixpkgs-fmt
              entr
              fd
            ];
        });
         packages =
           { default = pkgs.poetry2nix.mkPoetryApplication {
               projectDir = ./.;
             };
           };

      });
}
