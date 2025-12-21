{
  inputs.nixpkgs-nodejs.url = "github:davidnbr/nixpkgs-nodejs";

  outputs = { self, nixpkgs-nodejs }: {
    lib = {
      hasVersion = { version, system ? builtins.currentSystem }:
        builtins.hasAttr version nixpkgs-nodejs.packages.${system};
      packageFromVersion = { version, system ? builtins.currentSystem }:
        nixpkgs-nodejs.packages.${system}.${version};
    };
  };
}

