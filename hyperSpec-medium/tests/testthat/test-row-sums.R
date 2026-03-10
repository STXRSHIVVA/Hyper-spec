test_that("row_sums returns row totals for a dense matrix", {
  x <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, byrow = TRUE)

  expect_equal(row_sums(x), c(6, 15))
})
