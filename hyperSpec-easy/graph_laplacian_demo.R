ensure_hyperspec <- function() {
  if (!requireNamespace("hyperSpec", quietly = TRUE)) {
    install.packages("hyperSpec", repos = "https://cloud.r-project.org")
  }
}

build_adjacency <- function(nr, nc) {
  n <- nr * nc
  adj <- matrix(0, nrow = n, ncol = n)

  cell_index <- function(r, c) {
    (r - 1L) * nc + c
  }

  for (r in seq_len(nr)) {
    for (c in seq_len(nc)) {
      i <- cell_index(r, c)

      if (r > 1L) {
        j <- cell_index(r - 1L, c)
        adj[i, j] <- 1
        adj[j, i] <- 1
      }
      if (r < nr) {
        j <- cell_index(r + 1L, c)
        adj[i, j] <- 1
        adj[j, i] <- 1
      }
      if (c > 1L) {
        j <- cell_index(r, c - 1L)
        adj[i, j] <- 1
        adj[j, i] <- 1
      }
      if (c < nc) {
        j <- cell_index(r, c + 1L)
        adj[i, j] <- 1
        adj[j, i] <- 1
      }
    }
  }

  adj
}

matrix_to_image <- function(x, nr, nc) {
  matrix(x, nrow = nr, ncol = nc, byrow = TRUE)
}

ensure_hyperspec()
library(hyperSpec)

data("laser", package = "hyperSpec")

spc_matrix <- laser[[]]
n_pixels <- nrow(spc_matrix)
grid_nrow <- 7L
grid_ncol <- 12L

stopifnot(n_pixels == grid_nrow * grid_ncol)

pixel_signal <- rowMeans(spc_matrix)
adjacency <- build_adjacency(grid_nrow, grid_ncol)
degree <- diag(rowSums(adjacency))
laplacian <- degree - adjacency

eig <- eigen(laplacian, symmetric = TRUE)
fiedler <- eig$vectors[, order(eig$values)][, 2L]

signal_img <- matrix_to_image(pixel_signal, grid_nrow, grid_ncol)
fiedler_img <- matrix_to_image(fiedler, grid_nrow, grid_ncol)

png("hyperSpec_laplacian_plot.png", width = 1400, height = 1000)
op <- par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))

image(
  t(signal_img[grid_nrow:1, ]),
  col = hcl.colors(32, "YlOrRd", rev = TRUE),
  axes = FALSE,
  main = "laser mean intensity on 7x12 grid"
)
axis(1, at = seq(0, 1, length.out = grid_ncol), labels = seq_len(grid_ncol))
axis(2, at = seq(0, 1, length.out = grid_nrow), labels = grid_nrow:1)
box()

image(
  adjacency,
  col = c("white", "black"),
  axes = FALSE,
  main = "pixel adjacency matrix"
)
box()

image(
  laplacian,
  col = hcl.colors(32, "Blue-Red 3"),
  axes = FALSE,
  main = "graph Laplacian"
)
box()

image(
  t(fiedler_img[grid_nrow:1, ]),
  col = hcl.colors(32, "Blue-Red 3"),
  axes = FALSE,
  main = "Fiedler vector on the grid"
)
axis(1, at = seq(0, 1, length.out = grid_ncol), labels = seq_len(grid_ncol))
axis(2, at = seq(0, 1, length.out = grid_nrow), labels = grid_nrow:1)
box()

par(op)
dev.off()

cat("Saved plot to hyperSpec_laplacian_plot.png\n")
cat("Adjacency matrix dimension:", nrow(adjacency), "x", ncol(adjacency), "\n")
cat("Laplacian matrix dimension:", nrow(laplacian), "x", ncol(laplacian), "\n")
