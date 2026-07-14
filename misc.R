misc <- function() {
  requireNamespace("usethis")
  requireNamespace("data.table")
  requireNamespace("desc")
  requireNamespace("rhub")
  s1 <- system2("git", "status", stdout = TRUE)
  stopifnot(
    "nothing to commit, working tree clean" %in% s1
  )
  update_license <- function() {
    license_file_names <- dir(pattern = "LICEN[CS]E")
    lapply(license_file_names, function(license_file_name) {
      license_lines <- readLines(license_file_name)
      license_lines[1:5] <- gsub(
        "20[0-9]{2}",
        data.table::year(Sys.Date()),
        license_lines[1:5]
      )
      license_lines <- license_lines[!license_lines %in% c(NA, "NA")]
      writeLines(license_lines, license_file_name)
    })
  }
  update_license()
  r_cmd_check_yaml_path <- ".github/workflows/R-CMD-check.yaml"
  if (file.exists(r_cmd_check_yaml_path)) {
    unlink(r_cmd_check_yaml_path, force = TRUE)
  }
  usethis::use_github_action(name = "check-release")
  usethis::use_github_file(
    "FinnishCancerRegistry/github-actions",
    path = "version-tag-release-caller.yaml",
    save_as = ".github/workflows/version-tag-release.yaml",
    overwrite = TRUE
  )
  stopifnot(file.exists(r_cmd_check_yaml_path))
  suppressMessages(capture.output(rhub::rhub_setup(overwrite = TRUE)))
  desc::desc_normalize()
  Sys.sleep(5)
  s2 <- system2("git", "status", stdout = TRUE)

  commit_message <- "\"build: run r-package-dev-scripts/misc.R from github"
  if (!identical(s1, s2)) {
    system2("git", c("add", "--all"))
    system2("git", c("commit", "-m", commit_message))
  }
}
misc()
