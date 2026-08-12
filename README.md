# DEXCHAT

**Dextran and Chitosan Solution Calculator** — a small Shiny app that turns a
reagent mass into the solvent volume you need to hit a target working
concentration, so nobody has to redo the arithmetic at the bench.

[![tests](https://github.com/richard-ortiz/dexchat/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/richard-ortiz/dexchat/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## What it does

Enter a chitosan mass and a dextran mass in milligrams. The app returns:

- the volume of **H₂O** needed to bring the chitosan to **50 mg/mL**,
- the volume of **PBS** needed to bring the dextran to **0.1 mg/µL**,
- a table and a bar chart of both volumes.

| Reagent  | Solvent | Target concentration | Example                |
| -------- | ------- | -------------------- | ---------------------- |
| Chitosan | H₂O     | 50 mg/mL             | 100 mg → 2000 µL       |
| Dextran  | PBS     | 0.1 mg/µL            | 50 mg → 500 µL         |

> **Verify the constants before you use this at the bench.** They live at the
> top of [`R/calculations.R`](R/calculations.R) and were carried over from the
> original script; they are not independently sourced. Change them there, add
> a citation in the comment, and the whole app follows.

## Install and run

Requires R ≥ 4.1.

```r
install.packages(c("shiny", "ggplot2"))

# from the repository root
shiny::runApp()
```

Or without cloning:

```r
shiny::runGitHub("dexchat", "richard-ortiz")
```

## Repository layout

```
dexchat/
├── app.R                  # Shiny entry point — UI and server only
├── R/
│   ├── calculations.R     # protocol constants + pure math (tested)
│   └── plots.R            # ggplot helpers, no Shiny dependency
├── tests/
│   ├── testthat.R         # test runner
│   └── testthat/
│       ├── setup.R        # sources R/ before tests run
│       └── test-calculations.R
├── www/                   # static assets served by Shiny (logo, CSS)
├── .github/workflows/     # CI: runs the tests on every push
├── DESCRIPTION            # dependencies and authorship, machine-readable
├── CITATION.cff           # how to cite — GitHub renders this as a button
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

The organizing rule: **`app.R` holds no science.** Every number the app
reports comes from a plain function in `R/` that can be called, tested, and
reviewed without launching Shiny. That is what makes the calculation
auditable by a collaborator who does not write Shiny code.

## Testing

```bash
Rscript tests/testthat.R
```

The suite pins the documented conversions (100 mg chitosan → 2000 µL,
50 mg dextran → 500 µL) so a future refactor cannot quietly change a
concentration.

## Citation

If DEXCHAT contributes to published work, please cite it. GitHub reads
[`CITATION.cff`](CITATION.cff) and offers a formatted citation from the
sidebar of the repository page.

## License

MIT — see [LICENSE](LICENSE).

---

### Before you push

One thing still needs your input: a `www/logo.png`, if you want the sidebar
logo back. The original app hot-linked it from a Twitter URL; see
[`www/README.md`](www/README.md) for why that is worth replacing.

Consider also swapping the contact address in `DESCRIPTION` and
`CITATION.cff` for your NIU address — an institutional email ages better on
a cited research tool than a personal one.
