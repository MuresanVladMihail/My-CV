// The entry point. There is usually nothing to edit in here.
//
//   make            → build/CV-Vlad-Muresan.pdf
//   make watch      → recompiles on every save
//   make short      → the short variant (priority 1 only)

#import "lib/resume.typ": resume

// 1 = only the essential roles, 3 = everything. Can be overridden from the command line:
//   typst compile --input max-priority=1 cv.typ
#let max-priority = int(sys.inputs.at("max-priority", default: "3"))

#resume(yaml("cv.yaml"), max-priority: max-priority)
