du <- new.env()
source(
  "https://raw.githubusercontent.com/FinnishCancerRegistry/r-package-dev-scripts/refs/heads/main/utils.R",
  local = du
)
message(
  "Ignorable NOTEs:\n",
  "- the submission itself\n",
  "- inability of checking whether URLs work"
)
message("Running devtools::check(remote = TRUE)")
chk <- devtools::check(remote = TRUE)
print(chk)

message("Running revdepcheck::revdep_check(bioc = FALSE, num_workers = 4L)")
du$gitignore_append("revdepcheck")
tryCatch(revdepcheck::revdep_reset(), error = function(e) e)
rdchk <- revdepcheck::revdep_check(bioc = FALSE, num_workers = 4L)
