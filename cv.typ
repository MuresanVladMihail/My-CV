// Punctul de intrare. De obicei nu ai ce edita aici.
//
//   make            → build/CV-Vlad-Muresan.pdf
//   make watch      → recompilează la fiecare salvare
//   make short      → varianta scurtă (doar priority 1)

#import "lib/resume.typ": resume

// 1 = doar rolurile esențiale, 3 = tot. Se poate suprascrie din linia de comandă:
//   typst compile --input max-priority=1 cv.typ
#let max-priority = int(sys.inputs.at("max-priority", default: "3"))

#resume(yaml("cv.yaml"), max-priority: max-priority)
