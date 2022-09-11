# Python Flake Template

- [Python Flake Template](#python-flake-template)
  * [Setup](#setup)
    + [Prerequisites](#prerequisites)
    + [Instructions](#instructions)
  * [Usage Instructions](#usage-instructions)
    + [Adding a dependency](#adding-a-dependency)
- [Troubleshooting](#troubleshooting)
  * [`error: metadata-generation-failed`](#-error--metadata-generation-failed-)
- [Things to note](#things-to-note)

## Setup 

### Prerequisites

First, install `nix` by following [the instructions](https://nixos.org/download.html) for your operating system.

Then, users must enable `nix flakes`. The instructions to do so
differ by operating system.

For non-NixOS operating systems, edit either `~/.config/nix/nix.conf` or 
`/etc/nix/nix.conf` and add `experimental-features = nix-command flakes`.
If the Nix installation is in multi-user mode, don’t forget to restart the         
with `sudo systemctl restart nix-daemon`.


For NixOS, set the following options in `configuration.nix` and run 
`nixos-rebuild`:

```nixos
{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

### Instructions

- Clone this repository
- Update the `pyproject.toml` file
- Add a `description` to `flake.nix`

## Usage Instructions

- Run `nix develop` to enter a hermetic development shell. This shell,
  by default, provides:
  - The nix standard environment (including `make`, `coreutils`, etc.)
  - `entr` (for re-running commands on file change)
  - `fd` (for easier `find` behavior)
  - `poetry`, for python dependency management. The `poetry2nix` package
     then uses a `poetry.lock` file to provide:
     - `mypy`
     - `black`
     - `flake8`
     - `pylint`
     - `pytest`
- Use the provided `Makefile` to build, test, or format the project. The `make` 
  command will print a usage string; examine the `Makefile` itself to understand
  how it runs specific commands.
  
### Adding a dependency

This flake handles dependency management via nix, which uses `poetry2nix`, which
uses `poetry` underneath. To add a dependency, use `poetry add <package name>`. 
To make this package come in to scope (e.g., in your shell or editor), you 
will need to leave your nix shell and re-enter it with `nix develop`.

# Troubleshooting 

## `error: metadata-generation-failed`

**The error:**

You run `nix build` or `make build` and receive an error message like: 

```
       >   Preparing metadata (pyproject.toml) ... error
       > error: metadata-generation-failed
       >
       > × Encountered error while generating package metadata.
       > ╰─> See above for output.
       >
       > note: This is an issue with the package mentioned above, not pip.
       > hint: See above for details.
```

**The solution:**

- Run `git status` and check if there are any untracked files necessary to 
  build your project.
- If so, use `git add` to track those files.

**The cause:**

Nix derivations built using flakes are only permitted to use files that
`git` knows about. If the file isn't yet tracked by `git`, Nix doesn't
yet "know" about they file, and can't use it to build your project.

 *Note*: you do not need to _commit_ the code, just add it.

# Things to note:

This template installs `mypy` pinned to `=0.961`, because a version of spec of
the latest version at the time of creation (`^0.971`) was failing. When
the upstream has a fix, this repository should pull in an update.
