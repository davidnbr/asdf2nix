# asdf2nix nodejs plugin

This plugin provides Node.js version management with **minor version granularity** for asdf2nix.

## Features

- **Minor version pinning**: Specify `18.16.3` in `.tool-versions` → get Node.js 18.16.x
- **Pre-built binaries**: Uses nixpkgs binary cache (no compilation needed)
- **Reproducible**: Pins to specific nixpkgs commits

## Usage

### In your project's flake.nix

```nix
{
  inputs = {
    asdf2nix.url = "github:sestrella/asdf2nix";
    asdf2nix-nodejs.url = "github:YOUR_USERNAME/asdf2nix?dir=plugins/nodejs";
  };

  outputs = { asdf2nix, asdf2nix-nodejs, ... }: {
    # Your configuration
  };
}
```

### .tool-versions examples

```
nodejs 18.16.3    # → gets nodejs 18.16.x
nodejs 20.18.9    # → gets nodejs 20.18.x
nodejs 22.10.0    # → gets nodejs 22.10.x
```

## Supported Versions

Check `flake.nix` for the complete list of supported versions.

To add a new version:

1. Visit [Nix Package Versions](https://lazamar.co.uk/nix-versions/?package=nodejs)
2. Search for your desired Node.js version
3. Copy the nixpkgs commit hash
4. Add it to the `versionMap` in `flake.nix`

## Version Resolution

- `18.16.0` → `18.16`
- `18.16.1` → `18.16`
- `18.16.3` → `18.16`
- `20.18.9` → `20.18`

The plugin ignores patch versions and maps to the closest available minor version in nixpkgs.
