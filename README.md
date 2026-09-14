## Setup (o dată)

```bash
# macOS
brew install typst
# Arch
sudo pacman -S typst
# oriunde (binar standalone)
curl -fsSL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz \
  | tar -xJ --strip-components=1 -C ~/.local/bin --wildcards '*/typst'
```

Pentru IntelliJ / VS Code: extensia **Tinymist Typst** dă preview live și autocomplete.

## Uz zilnic

```bash
make          # PDF complet în build/
make short    # doar rolurile cu priority: 1
make watch    # recompilează la fiecare salvare, ține-l deschis lângă editor
```

## Cum adaugi ceva

**Un job nou** — copiază un bloc din `experience:` și pune-l primul. Cheile `tagline`,
`context`, `projects`, `highlights`, `activities`, `stack` sunt toate opționale:
ce lipsește pur și simplu nu se randează.

```yaml
  - company: Client nou
    role: Principal Backend Engineer
    start: "2027-01"
    end: present
    priority: 1
    projects:
      - name: Ceva
        text: Descriere.
    stack:
      Backend: Kotlin, Spring Boot
```

**Un skill nou** — o linie, cu anul în care ai început, nu cu numărul de ani:

```yaml
  - { name: Rust, since: 2027, group: backend }
```

Anii se recalculează la fiecare build (`10 yrs` azi, `11 yrs` la anul), deci CV-ul nu
mai îmbătrânește singur. Pentru ce nu mai folosești, îngheață numărul cu `until: 2024`.

**O secțiune nouă** (limbi, certificări) — decomentează blocul din coada lui `cv.yaml`.
Pentru ceva complet nou, adaugi cheia în YAML și 4 rânduri în `resume()` din `lib/resume.typ`.

## Variante

`priority` filtrează rolurile: `1` = intră mereu, `2` = doar în varianta lungă, `3` = arhivă.
`make short` scoate un PDF cu doar `priority: 1`. Nu ștergi niciodată nimic din istoric —
doar îi scazi prioritatea.

Pentru o variantă în altă limbă: `cp cv.yaml cv.de.yaml`, traduci textele, și un
`cv.de.typ` de 3 linii care încarcă `cv.de.yaml`. Designul rămâne partajat.
