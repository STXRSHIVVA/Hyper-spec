use extendr_api::prelude::*;
use faer::Mat;

#[extendr]
fn row_sums(x: RMatrix<f64>) -> Doubles {
    let nrows = x.nrows();
    let ncols = x.ncols();
    let matrix = Mat::from_fn(nrows, ncols, |row, col| x[[row, col]]);

    let sums = (0..nrows)
        .map(|row| (0..ncols).map(|col| matrix[(row, col)]).sum::<f64>())
        .collect::<Vec<_>>();

    sums.into_iter().collect()
}

extendr_module! {
    mod faerextendr;
    fn row_sums;
}
