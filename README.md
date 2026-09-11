# OmaStack

### Bring Your Own Bloat to Omarchy: `omack update`

**Config as code:**

You adapt your `wanted.txt` and `unwanted.txt` and reproduce your dream **stack** in seconds on any Omarchy system.

## Setup

```bash
cp omack ~/.local/bin/
chmod +x ~/.local/bin/omack
omack init
```

Lists: `~/.config/omack/` (`$XDG_CONFIG_HOME/omack` if set).

## Commands

```
omack init [--force]       # wanted.txt = explicitly installed packages (pacman -Qqe)
                           # unwanted.txt = empty
                           # refuses to overwrite lists unless --force
omack list                 # print explicitly installed packages
omack status               # pending installs/removes and names in both lists
omack update [--dry-run]   # install packages in wanted.txt if missing
                           # uninstall packages in unwanted.txt if installed
omack help
omack version
```

Edit the two lists, preview with `omack update --dry-run`, then `omack update`.

## Rules

- `wanted.txt` — must be installed (`omarchy pkg add`)
- `unwanted.txt` — must be gone (`omarchy pkg drop`)
- Everything else is left alone (Omarchy itself, dependencies)
- A name in both files is an error
- Lines starting with `#` and blank lines are ignored
- AUR packages are not handled; use `omarchy pkg aur add` separately

## Requirements

- Omarchy
- `pacman`
- `omarchy pkg add` / `omarchy pkg drop`

## License

MIT Licensed.
