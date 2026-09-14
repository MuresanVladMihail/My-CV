// ─────────────────────────────────────────────────────────────────────────────
// CV DESIGN. The content lives in cv.yaml — you only come here when you want
// to change how it looks (colors, spacing, the order of the sections).
// ─────────────────────────────────────────────────────────────────────────────

#let theme = (
  dark: rgb("#23262c"),
  ink: rgb("#1c1f24"),
  muted: rgb("#6c717a"),
  rule: rgb("#dcdfe4"),
  chip: rgb("#f1f2f4"),
)

// ── Icons (inline SVG, no external dependencies) ─────────────────────────────
#let icon-paths = (
  phone: "<rect x='6' y='2' width='12' height='20' rx='2.5'/><line x1='10' y1='18.5' x2='14' y2='18.5'/>",
  mail: "<rect x='2.5' y='5' width='19' height='14' rx='2'/><path d='M3 7l9 6 9-6'/>",
  pin: "<path d='M12 22s7-6.4 7-12a7 7 0 1 0-14 0c0 5.6 7 12 7 12z'/><circle cx='12' cy='10' r='2.6'/>",
  link: "<circle cx='12' cy='12' r='9'/><ellipse cx='12' cy='12' rx='4' ry='9'/><line x1='3' y1='12' x2='21' y2='12'/>",
  code: "<polyline points='8.5 6 3 12 8.5 18'/><polyline points='15.5 6 21 12 15.5 18'/>",
)

#let icon(kind, color: white, size: 9pt) = {
  let body = icon-paths.at(kind, default: icon-paths.link)
  let svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='" +
    color.to-hex() +
    "' stroke-width='1.9' stroke-linecap='round' stroke-linejoin='round'>" +
    body + "</svg>"
  )
  box(baseline: 1.5pt, image(bytes(svg), format: "svg", width: size))
}

// ── Dates & automatically computed years ─────────────────────────────────────
#let months = ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

#let fmt-date(value) = {
  let s = str(value)
  if s == "present" or s == "Present" { return "Present" }
  let parts = s.split("-")
  if parts.len() >= 2 {
    let m = int(parts.at(1))
    months.at(m - 1) + " " + parts.at(0)
  } else { s }
}

#let years-since(since, until: none) = {
  let stop = if until == none { datetime.today().year() } else { int(until) }
  calc.max(1, stop - int(since))
}

#let plural-years(n) = str(n) + " yr" + if n == 1 { "" } else { "s" }

// ── Blocks ───────────────────────────────────────────────────────────────────
#let section(title) = {
  block(above: 16pt, below: 8pt)[
    #text(size: 10.5pt, weight: 700, tracking: 1.6pt, fill: theme.ink, upper(title))
    #v(3pt, weak: true)
    #line(length: 100%, stroke: 0.8pt + theme.rule)
  ]
}

// Bullet with a hanging indent: wrapped lines line up under the text, not the dot.
#let bullet-row(body) = grid(
  columns: (10pt, 1fr),
  row-gutter: 0pt,
  text(fill: theme.muted)[•], body,
)

#let bullets(items) = {
  set text(size: 8.6pt, fill: theme.ink)
  for it in items {
    block(above: 2.4pt, below: 2.4pt, bullet-row(it))
  }
}

#let stack-lines(stack) = {
  set text(size: 8.4pt)
  for (label, value) in stack.pairs() [
    #block(above: 2pt, below: 2pt)[
      #text(weight: 600, fill: theme.ink)[#label:] #text(fill: theme.muted)[#value]
    ]
  ]
}

#let job(entry) = {
  block(breakable: true, above: 14pt, below: 4pt)[
    // The role, company and context stay together and never break away from the entry.
    #block(breakable: false, sticky: true, below: 0pt)[
      #grid(
        columns: (1fr, auto),
        align: (left + bottom, right + bottom),
        text(size: 10.5pt, weight: 700, fill: theme.ink, entry.role),
        text(size: 8.4pt, fill: theme.muted)[
          #fmt-date(entry.start) — #fmt-date(entry.end)
        ],
      )
      #v(1pt)
      #text(size: 9.2pt, weight: 600, fill: theme.dark, entry.company)
      #if "tagline" in entry [
        #text(size: 9.2pt, fill: theme.muted)[ · #entry.tagline]
      ]
      #if "context" in entry [
        #block(above: 5pt, below: 0pt, text(size: 8.6pt, fill: theme.muted, style: "italic", entry.context))
      ]
      #if "scale" in entry [
        #block(above: 4pt, below: 0pt)[
          #box(fill: theme.chip, radius: 3pt, inset: (x: 6pt, y: 3.5pt))[
            #text(size: 8.2pt, fill: theme.ink)[#entry.scale]
          ]
        ]
      ]
    ]
    #if "projects" in entry [
      #block(above: 6pt)[
        #text(size: 8.8pt, weight: 600, fill: theme.ink)[Notable projects]
        #for p in entry.projects {
          block(above: 3pt, below: 3pt, bullet-row[
            #text(size: 8.6pt, weight: 600)[#p.name — ]#text(size: 8.6pt)[#p.text]
          ])
        }
      ]
    ]
    #if "highlights" in entry [
      #block(above: 6pt)[
        #text(size: 8.8pt, weight: 600, fill: theme.ink)[Highlights]
        #v(1pt)
        #bullets(entry.highlights)
      ]
    ]
    #if "activities" in entry [
      #block(above: 6pt)[
        #text(size: 8.8pt, weight: 600, fill: theme.ink)[Main activities]
        #v(1pt)
        #bullets(entry.activities)
      ]
    ]
    #if "stack" in entry [
      #block(above: 6pt, stack-lines(entry.stack))
    ]
  ]
}

#let skills-block(data) = {
  let groups = data.at("skill_groups", default: ())
  let all = data.at("skills", default: ())
  let used = ()
  let cells = ()
  for g in groups {
    // Sorted by years, descending — the order in cv.yaml does not matter.
    let items = all
      .filter(s => s.at("group", default: "") == g.id)
      .sorted(key: s => -years-since(s.since, until: s.at("until", default: none)))
    if items.len() == 0 { continue }
    used += items
    cells.push[
      #text(size: 8.8pt, weight: 700, fill: theme.ink)[#g.label]
      #v(3pt, weak: true)
      #for s in items [
        #box(
          fill: theme.chip,
          radius: 3pt,
          inset: (x: 5pt, y: 3pt),
          outset: (y: 1.5pt),
        )[
          #text(size: 8pt, fill: theme.ink)[#s.name]
          #text(size: 8pt, fill: theme.muted)[#plural-years(years-since(s.since, until: s.at("until", default: none)))]
        ]
        #h(3pt)
      ]
    ]
  }
  grid(columns: (1fr, 1fr), column-gutter: 18pt, row-gutter: 12pt, ..cells)
}

#let header(data) = {
  let b = data.basics
  let years = years-since(b.at("career_start", default: datetime.today().year()))
  let summary = b.at("summary", default: "").replace("{years}", str(years))

  pad(top: -40pt, x: -40pt)[
    #block(width: 100%, fill: theme.dark, inset: (x: 40pt, top: 34pt, bottom: 26pt))[
      #set text(fill: white)
      #grid(
        columns: if "photo" in b { (auto, 1fr) } else { (1fr,) },
        column-gutter: 22pt,
        ..(
          if "photo" in b {
            (box(clip: true, radius: 4pt, width: 92pt, height: 112pt, image(b.photo, width: 92pt, height: 112pt, fit: "cover")),)
          } else { () }
        ),
        [
          #text(font: "League Spartan", size: 26pt, weight: 700)[#b.name]
          #v(2pt)
          #text(size: 9.5pt, weight: 500, tracking: 2pt, fill: rgb("#c9cdd4"))[#upper(b.title)]
          #if "subtitle" in b [
            #v(3pt)
            #text(size: 8.6pt, fill: rgb("#a8adb6"))[#b.subtitle]
          ]
          #v(8pt)
          #text(size: 8.8pt, fill: rgb("#e4e6ea"))[#summary]
          #v(10pt)
          #grid(
            columns: (auto, auto),
            column-gutter: 20pt,
            row-gutter: 5pt,
            ..b.at("contact", default: ()).map(c => {
              let label = text(size: 8.4pt, fill: white)[#c.text]
              [#icon(c.at("icon", default: "link"))#h(5pt)#if "link" in c { link(c.link, label) } else { label }]
            })
          )
        ],
      )
    ]
  ]
}

// ── The document ─────────────────────────────────────────────────────────────
#let resume(data, max-priority: 3) = {
  set document(
    title: data.basics.name + " — CV",
    author: data.basics.name,
    keywords: data.at("skills", default: ()).map(s => s.name),
  )
  set page(
    paper: "a4",
    margin: (x: 40pt, top: 40pt, bottom: 38pt),
    footer: context {
      set text(size: 7.5pt, fill: theme.muted)
      grid(
        columns: (1fr, auto),
        align: (left, right),
        data.basics.name,
        [#counter(page).display() / #counter(page).final().first()],
      )
    },
  )
  set text(font: ("Montserrat", "DejaVu Sans"), size: 9.2pt, fill: theme.ink, lang: "en")
  set par(justify: false, leading: 0.66em, spacing: 0.66em)

  header(data)

  if data.at("skills", default: ()).len() > 0 {
    section("Skills")
    skills-block(data)
  }

  if data.at("experience", default: ()).len() > 0 {
    section("Experience")
    for entry in data.experience {
      if entry.at("priority", default: 1) <= max-priority { job(entry) }
    }
  }

  if data.at("education", default: ()).len() > 0 {
    section("Education")
    for e in data.education {
      block(above: 8pt, below: 0pt)[
        #grid(
          columns: (1fr, auto),
          align: (left, right),
          [
            #text(size: 9.6pt, weight: 700)[#e.degree] \
            #text(size: 8.8pt, fill: theme.muted)[#e.institution#if "location" in e [ · #e.location]]
          ],
          text(size: 8.4pt, fill: theme.muted)[#e.start — #e.end],
        )
      ]
    }
  }

  if "languages" in data {
    section("Languages")
    text(size: 9pt)[#data.languages.map(l => l.name + " — " + l.level).join("   ·   ")]
  }

  if "certifications" in data {
    section("Certifications")
    for c in data.certifications {
      block(above: 5pt)[
        #text(size: 9pt, weight: 600)[#c.name] #text(size: 8.4pt, fill: theme.muted)[— #c.issuer, #c.year]
      ]
    }
  }
}