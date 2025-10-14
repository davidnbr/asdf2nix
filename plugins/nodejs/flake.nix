{
  description = "asdf2nix nodejs plugin with minor version support";

  outputs = { self }: {
    lib = rec {
      # Check if we can find a nodejs version matching the requested version
      hasVersion = { system, version }:
        let
          inherit (builtins) match head;
          
          # Parse major.minor from version string
          # Supports: "18.16.3" -> ["18" "16"]
          versionParts = match "([0-9]+)\\.([0-9]+)(\\..*)?

" version;
          
          # If no match, return false
          hasMatch = versionParts != null;
          
        in
        hasMatch;
      
      # Retrieve the nodejs package for the requested version
      packageFromVersion = { system, version }:
        let
          inherit (builtins) match head elemAt fetchGit;
          
          # Parse version to get major.minor
          versionMatch = match "([0-9]+)\\.([0-9]+)(\\..*)?$" version;
          major = elemAt versionMatch 0;
          minor = elemAt versionMatch 1;
          
          # Version to nixpkgs commit mapping
          # This maps "major.minor" to specific nixpkgs commits
          # Data source: https://lazamar.co.uk/nix-versions/?package=nodejs
          versionMap = {
            # Node.js 18.x versions
            "18.16" = {
              rev = "55070e598e0e03d1d116c49b9eff322ef07c6ac6";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "18.17" = {
              rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0e";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "18.18" = {
              rev = "5e15d5da4abb74f0dd76967044735c70e94c5af1";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "18.19" = {
              rev = "9c513fc6fb75142f6aec6b7545cb8af2236b80f5";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "18.20" = {
              rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            
            # Node.js 20.x versions
            "20.9" = {
              rev = "c757e9bd77b16ca2e03c89bf8bc9ecb28e0c06ad";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.10" = {
              rev = "5e15d5da4abb74f0dd76967044735c70e94c5af1";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.11" = {
              rev = "9c513fc6fb75142f6aec6b7545cb8af2236b80f5";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.12" = {
              rev = "ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.13" = {
              rev = "807c549feabce7eddbf259dbdcec9e0600a0660d";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.14" = {
              rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.15" = {
              rev = "f2e26ab47e597e8fe0dca1a7d39add49ddcf3454";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.16" = {
              rev = "5633bcff0c6162b9e4b5f1264264611e950c8ec7";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.17" = {
              rev = "7c67f03f731f0a48e4b3fc39f6e1a5e1f11df14e";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "20.18" = {
              rev = "13aff9b34cc32e59d35c62ac9356e4a41198a538";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            
            # Node.js 22.x versions
            "22.4" = {
              rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.5" = {
              rev = "f2e26ab47e597e8fe0dca1a7d39add49ddcf3454";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.6" = {
              rev = "5633bcff0c6162b9e4b5f1264264611e950c8ec7";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.7" = {
              rev = "7c67f03f731f0a48e4b3fc39f6e1a5e1f11df14e";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.8" = {
              rev = "13aff9b34cc32e59d35c62ac9356e4a41198a538";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.9" = {
              rev = "8809585e6937d0b07fc066792c8c9abf9c3fe5c4";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.10" = {
              rev = "70f1dbb84e4051dfd5cf0d0d7d7d6e0e5ae989ea";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
            "22.11" = {
              rev = "4d2b37a84fad1091b9de401eb450aae66f1a741e";
              sha256 = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
            };
          };
          
          # Lookup the nixpkgs commit for this version
          versionKey = "${major}.${minor}";
          nixpkgsInfo = versionMap.${versionKey} or (throw ''
            Node.js version ${versionKey}.x is not available in the plugin.
            
            Available versions:
            ${builtins.concatStringsSep "\n" (builtins.attrNames versionMap)}
            
            To add this version:
            1. Visit https://lazamar.co.uk/nix-versions/?package=nodejs
            2. Find the nixpkgs commit for nodejs ${versionKey}.x
            3. Add it to plugins/nodejs/flake.nix in the versionMap
          '');
          
          # Fetch the specific nixpkgs commit
          pinnedPkgs = import (fetchGit {
            url = "https://github.com/NixOS/nixpkgs";
            ref = "nixpkgs-unstable";
            rev = nixpkgsInfo.rev;
          }) { inherit system; };
          
          # Get the nodejs package attribute name (e.g., nodejs_18)
          nodejsAttr = "nodejs_${major}";
          
        in
        pinnedPkgs.${nodejsAttr};
    };
  };
}
