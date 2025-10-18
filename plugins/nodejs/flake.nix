{
  description = "asdf2nix nodejs plugin with minor version support";

  outputs = { self }: {
    lib = rec {
      versionMap = {
        "18.16" = {
          rev = "824421b1796332ad1bcb35bc7855da832c43305f";
          sha256 = "1w6cjnakz1yi66rs8c6nmhymsr7bj82vs2hz200ipi1sfiq8dy4y";
        };
        "18.18" = {
          rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0d";
          sha256 = "1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
        };
        "18.20" = {
          rev = "05bbf675397d5366259409139039af8077d695ce";
          sha256 = "1r26vjqmzgphfnby5lkfihz6i3y70hq84bpkwd43qjjvgxkcyki0";
        };
        "20.14" = {
          rev = "a343533bccc62400e8a9560423486a3b6c11a23b";
          sha256 = "0103a1a1g5sp4bjhm6fl0nfw69jgdiwrwz96nnqi0f3bg6vcg1sf";
        };
        "20.16" = {
          rev = "5633bcff0c6162b9e4b5f1264264611e950c8ec7";
          sha256 = "0p3ry8x72cl572fs1c47h9y3s045p4aq71wpblzdi4dfqx3z2i7m";
        };
        "20.18" = {
          rev = "13aff9b34cc32e59d35c62ac9356e4a41198a538";
          sha256 = "0ij9dq03b9awqfr0ys837cxlw6rzzjg1lnqhch81wpyvn892v5w0";
        };
        "22.6" = {
          rev = "5633bcff0c6162b9e4b5f1264264611e950c8ec7";
          sha256 = "0p3ry8x72cl572fs1c47h9y3s045p4aq71wpblzdi4dfqx3z2i7m";
        };
        "22.8" = {
          rev = "13aff9b34cc32e59d35c62ac9356e4a41198a538";
          sha256 = "0ij9dq03b9awqfr0ys837cxlw6rzzjg1lnqhch81wpyvn892v5w0";
        };
        "22.10" = {
          rev = "70f1dbb84e4051dfd5cf0d0d7d7d6e0e5ae989ea";
          sha256 = "0000000000000000000000000000000000000000000000000000";
        };
      };

      hasVersion = { system, version }:
        let
          inherit (builtins) match elemAt;
          versionMatch = match "([0-9]+)\\.([0-9]+)(\\..*)?$" version;
        in
          if versionMatch != null then
            let
              major = elemAt versionMatch 0;
              minor = elemAt versionMatch 1;
              versionKey = "${major}.${minor}";
            in
              versionMap ? ${versionKey}
          else
            false;

      packageFromVersion = { system, version }:
        let
          inherit (builtins) match elemAt fetchGit;

          versionMatch = match "([0-9]+)\\.([0-9]+)(\\..*)?$" version;
          major = elemAt versionMatch 0;
          minor = elemAt versionMatch 1;

          versionKey = "${major}.${minor}";
          nixpkgsInfo = versionMap.${versionKey} or (throw ''
            Node.js version ${versionKey}.x is not available in the plugin.

            Available versions:
            ${builtins.concatStringsSep "\n" (builtins.attrNames versionMap)}
          '');

          pinnedPkgs = import (fetchGit {
            url = "https://github.com/NixOS/nixpkgs";
            ref = "nixpkgs-unstable";
            rev = nixpkgsInfo.rev;
          }) { inherit system; };

        in
          # Try different attribute names based on what exists
          if pinnedPkgs ? "nodejs_${major}" then
            pinnedPkgs."nodejs_${major}"
          else if pinnedPkgs ? "nodejs-${major}_x" then
            pinnedPkgs."nodejs-${major}_x"
          else if pinnedPkgs ? nodejs then
            pinnedPkgs.nodejs
          else if pinnedPkgs ? elmPackages && pinnedPkgs.elmPackages ? nodejs then
            pinnedPkgs.elmPackages.nodejs
          else
            throw ''
              Could not find nodejs for version ${versionKey}.
              Tried: nodejs_${major}, nodejs-${major}_x, nodejs, elmPackages.nodejs
              
              Available attributes: ${builtins.concatStringsSep ", " (builtins.attrNames pinnedPkgs)}
            '';
    };
  };
}
