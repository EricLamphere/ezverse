

#' Install ezverse Packages
#'
#' This function installs all of the core ezverse packages
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom cli cli_alert_info cli_alert_success
#' @importFrom remotes install_github
#' @export

install_ez_packages <- function(pkgs = core, ...) {
  tryCatch(
    {
      lapply(
        pkgs,
        function(x) {
          github_pkg_install(x, git_path = "https://github.com/EricLamphere/", ...)
        }
      )
    },
    error = function(e) {
      print(e)
    }
  )
}


github_pkg_install <- function(pkg, git_path, ...) {
  cli::cli_alert_info("installing '{pkg}' from '{paste0(git_path, pkg)}'")

  tryCatch(
    {
      remotes::install_github(paste0(git_path, pkg), ...)
    },
    error = function(e) {
      cli::cli_alert_danger("'{pkg}' install failed")
      print(e)
    },
    warning = function(w) {
      print(w)
    }
  )
}
