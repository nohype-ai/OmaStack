# OmaStack

### Bring Your Own Bloat to Omarchy: `omack update`

**Bloat as code:**

Evolve your `wanted.txt` and `unwanted.txt` then reproduce that dream **stack** in seconds.

## Setup

```bash
curl -fsSL https://omastack.dev/install.sh | bash
```

`wanted.txt` and `unwanted.txt` are created in `~/.config/omack/`

## Usage

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

## Behaviour

- `wanted.txt` — will be installed (`omarchy pkg add`)
- `unwanted.txt` — will be gone (`omarchy pkg drop`)
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
