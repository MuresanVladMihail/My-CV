## Setup (once)

```bash
# macOS
brew install typst
# Arch
sudo pacman -S typst
# anywhere (standalone binary)
curl -fsSL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz \
  | tar -xJ --strip-components=1 -C ~/.local/bin --wildcards '*/typst'
```

For IntelliJ / VS Code: the **Tinymist Typst** extension gives you live preview and autocomplete.

## Day-to-day use

```bash
make          # full PDF in build/
make short    # only the roles with priority: 1
make watch    # recompiles on every save, keep it open next to your editor
```

## How to add something

**A new job** — copy a block from `experience:` and put it first. The keys `tagline`,
`context`, `projects`, `highlights`, `activities` and `stack` are all optional:
whatever is missing simply does not get rendered.

```yaml
  - company: New client
    role: Principal Backend Engineer
    start: "2027-01"
    end: present
    priority: 1
    projects:
      - name: Something
        text: Description.
    stack:
      Backend: Kotlin, Spring Boot
```

**A new skill** — one line, with the year you started, not the number of years:

```yaml
  - { name: Rust, since: 2027, group: backend }
```

The years are recomputed on every build (`10 yrs` today, `11 yrs` next year), so the CV no
longer ages on its own. For anything you no longer use, freeze the number with `until: 2024`.

**A new section** (languages, certifications) — uncomment the block at the bottom of `cv.yaml`.
For something entirely new, add the key to the YAML and 4 lines to `resume()` in `lib/resume.typ`.

## Variants

`priority` filters the roles: `1` = always included, `2` = long variant only, `3` = archive.
`make short` produces a PDF with only `priority: 1`. You never delete anything from the
history — you just lower its priority.

For a variant in another language: `cp cv.yaml cv.de.yaml`, translate the text, and add a
3-line `cv.de.typ` that loads `cv.de.yaml`. The design stays shared.
