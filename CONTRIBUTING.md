# Contributing

Thanks for your interest in DEXCHAT. This is a small research tool, so the
process is light.

## Reporting a problem

Open an issue and include: what you entered, what you expected, what you got,
and the output of `sessionInfo()`.

## Making a change

1. Fork and branch off `main` (`git checkout -b fix-dextran-units`).
2. Put any calculation in `R/calculations.R`, not in `app.R`. If it produces
   a number a bench scientist will rely on, it needs a test in
   `tests/testthat/test-calculations.R`.
3. Run the suite before pushing:

   ```bash
   Rscript tests/testthat.R
   ```

4. Open a pull request describing the scientific rationale, not just the code
   change. If a protocol constant changes, cite the source.

## Style

- Two-space indent, `snake_case` names, lines under 80 characters.
- Comment *why*, not *what*. The code already says what.
- No `library()` calls inside `R/` — the app entry point loads packages, and
  helper files reference namespaces explicitly (`ggplot2::aes()`).
