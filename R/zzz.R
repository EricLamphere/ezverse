.onAttach <- function(...) {
  needed <- core[!is_attached(core)]
  if (length(needed) == 0)
    return()

  crayon::num_colors(TRUE)
  ezverse_attach()

  if (!"package:conflicted" %in% search()) {
    x <- ezverse_conflicts()
    msg(ezverse_conflict_message(x), startup = TRUE)
  }

}

is_attached <- function(x) {
  paste0("package:", x) %in% search()
}






# .onAttach <- function(...) {
#   needed <- core[!is_attached(core)]
#   if (length(needed) == 0)
#     return()
#
#   crayon::num_colors(TRUE)
#   ezverse_attach()
#
#   packageStartupMessage(
#     emo::ji("beers"),
#     crayon::white(" ezverse "),
#     crayon::cyan(packageVersion("ezverse"))
#   )
# }
#
# is_attached <- function(x) {
#   paste0("package:", x) %in% search()
# }
