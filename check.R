if (requireNamespace("fcrdev", quietly = TRUE)) {
  chk <- fcrdev::pkg_r_cmd_check()
} else {
  chk <- devtools::check()
}
print(chk)
