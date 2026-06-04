release <- function() {
  if (requireNamespace("fcrdev", quietly = TRUE)) {
    fcrdev::pkg_version_bump_and_git_commit()
    fcrdev::pkg_local_release()
    return(NULL)
  }
  
  requireNamespace("desc")

  ask_yes_no <- function(question) {
    message(question)
    answer <- ""
    while (!answer %in% c("y", "n")) {
      answer <- tolower(readline(": "))
    }
    return(answer == "y")
  }

  s1 <- system2("git", "status", stdout = TRUE)
  stopifnot(
    "nothing to commit, working tree clean" %in% s1
  )
  message("which number to bump in version? [major/minor/patch/none]")
  a <- readline(": ")
  if (a != "none") {
    desc::desc_bump_version(a)
  }
  system2("git", c("add", "DESCRIPTION"))
  new_v <- desc::desc_get_version()
  tag_version <- paste0("v", new_v)
  system2("git", c("commit", paste0("-m \"build: ", tag_version, "\"")))
    
  if (ask_yes_no("push commits? [y/n]")) {
    system2("git", "push")
  }
  
  if (ask_yes_no(sprintf("automatically add tags `%s` and `release` to local and remote repo? [y/n]", tag_version))) {
    s2 <- system2("git", "status", stdout = TRUE)
    if (!identical(s1, s2)) {
      for (tag in c("release", tag_version)) {
        if (length(system2("git", c("tag", "-l", tag), stdout = TRUE)) > 0) {
          system2("git", c("tag", "-d", tag))
          system2("git", c("push", "--delete", "origin", tag))
        }
        system2("git", c("tag", "-f", tag))
      }
      system2("git", c("push", "--tags"))
    }
  }
}
release()
