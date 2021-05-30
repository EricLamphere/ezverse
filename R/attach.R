core <-
  c(
    "ezextras", # must be first
    "ezxfig",
    # "ezexplore",
    # "ezdates",
    "ezviz"
  )



core_unloaded <- function() {
  search <- paste0("package:", core)
  core[!search %in% search()]
}

core_uninstalled <- function() {
  installed <- sapply(core, rlang::is_installed)
  installed[!installed]
}

# Attach the package from the same package library it was
# loaded from before. https://github.com/tidyverse/tidyverse/issues/171
same_library <- function(pkg) {
  loc <- if (pkg %in% loadedNamespaces()) dirname(getNamespaceInfo(pkg, "path"))
  do.call(
    "library",
    list(pkg, lib.loc = loc, character.only = TRUE, warn.conflicts = FALSE)
  )
}

ezverse_attach <- function() {
  to_install <- core_uninstalled()
  if (length(to_install) != 0) {
    lapply(to_install, install_ez_packages)
  }


  to_load <- core_unloaded()
  if (length(to_load) == 0)
    return(invisible())


  versions <- vapply(to_load, package_version, character(1))
  packages <- paste0(
    crayon::green(cli::symbol$tick), " ", crayon::blue(format(to_load)), " ",
    crayon::col_align(versions, max(crayon::col_nchar(versions)))
  )

  if (length(packages) %% 2 == 1) {
    packages <- append(packages, "")
  }
  col1 <- seq_len(length(packages) / 2)
  info <- paste0(packages[col1], "     ", packages[-col1])

  msg(paste(info, collapse = "\n"), startup = TRUE)

  suppressPackageStartupMessages(
    lapply(to_load, same_library)
  )

  invisible()
}

package_version <- function(x) {
  version <- as.character(unclass(utils::packageVersion(x))[[1]])

  if (length(version) > 3) {
    version[4:length(version)] <- crayon::red(as.character(version[4:length(version)]))
  }
  paste0(version, collapse = ".")
}



install_ez_packages <- function(pkgs, ...) {
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


