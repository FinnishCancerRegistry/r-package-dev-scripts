update_data <- function() {
  r_script_paths <- dir("data-raw", pattern = "[.][rR]$", full.names = TRUE)
  r_script_paths <- r_script_paths[
    !grepl("^[0-9]+_[0-9]+", r_script_paths)
  ]

  s1 <- system2("git", "status", stdout = TRUE)
  stopifnot(
    "nothing to commit, working tree clean" %in% s1
  )

  lapply(r_script_paths, function(r_script_path) {
    source(r_script_path)
    system2("git", c("add", "-A"))
    msg <- sprintf("\"feat: run %s\"", substr(r_script_path, 1, 30))
    system2("git", c("commit", "-m", msg))
  })
  invisible(NULL)
}
update_data()
