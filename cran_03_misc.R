source(
  "https://raw.githubusercontent.com/FinnishCancerRegistry/r-package-dev-scripts/refs/heads/main/misc.R",
  encoding = "UTF-8"
)

du <- new.env()
source(
  "https://raw.githubusercontent.com/FinnishCancerRegistry/r-package-dev-scripts/refs/heads/main/utils.R",
  local = du,
  encoding = "UTF-8"
)

## spelling --------------------------------------------------------------------
message("Running devtools::spell_check()")
devtools::spell_check()
message(
  "Press enter when you have fixed + committed any and all",
  "devtools::spell_check() problems reported above"
)
readline(": ")

## README / NEWS ---------------------------------------------------------------
if ("README.Rmd" %in% dir() && du$ask_yn("Is README.Rmd up-to-date?")) {
  du$git_commit_if_changes_made(
    rmarkdown::render("README.Rmd"),
    message = "docs: render README.Rmd"
  )
}

message("Press enter when/if NEWS.md is up-to-date")
readline(": ")
message("Press enter when/if cran-comments.md is up-to-date")
readline(": ")
message("Press enter when/if the version in DESCRIPTION is the release version")
readline(": ")
