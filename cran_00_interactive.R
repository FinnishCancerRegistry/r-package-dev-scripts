local({
  make_r_script_options <- function() {
    # this can be run locally to update r_script_options
    stopifnot("cran_00_interactive.R" %in% dir())
    r_script_options <- dir(pattern = "^cran_[0-9]+_")
    this_script_name <- r_script_options[grepl("00", r_script_options)]
    r_script_options <- setdiff(r_script_options, this_script_name)
    lines <- readLines(this_script_name)
    replace_range <- which(grepl("^ *# *%r_script_options", lines))
    replace_lines <- c(
      "  r_script_options <- c(",
      paste0(
        "    \"",
        r_script_options,
        "\"",
        c(rep(",", length(r_script_options) - 1L), "")
      ),
      "  )"
    )
    lines <- c(
      lines[seq_len(replace_range[1])],
      replace_lines,
      lines[replace_range[2]:length(lines)]
    )
    writeLines(lines, this_script_name)
  }

  # %r_script_options
  r_script_options <- c(
    "cran_01_check.R",
    "cran_02_check_remotely.R",
    "cran_03_misc.R",
    "cran_04_prerelease.R",
    "cran_05_release.R",
    "cran_06_post_accept.R"
  )
  # %r_script_options

  message(
    "Select script to run:\n",
    paste0(seq_along(r_script_options), ": ", r_script_options, "\n")
  )
  a <- ""
  while (!a %in% seq_along(r_script_options)) {
    a <- readline(": ")
  }
  a <- as.integer(a)

  script_url <- paste0(
    "https://raw.githubusercontent.com/FinnishCancerRegistry/r-package-dev-scripts/refs/heads/main/",
    r_script_options[a]
  )
  script_lines <- readLines(script_url)
  cat(script_lines, sep = "\n")
  message("Run the script containing the above code? [y/n]")
  a <- ""
  while (!a %in% c("y", "n")) {
    a <- readline(": ")
  }
  a <- a == "y"

  if (a) {
    source(script_url, encoding = "UTF-8", local = globalenv())
  }
})
