use ciborium::{from_reader, into_writer};
use polyfit::MonomialFit;
use polyfit::score::Aic;
use wasm_minimal_protocol::*;

initiate_protocol!();

#[wasm_func]
pub fn fit_monomial(data: &[u8], degree: &[u8]) -> Vec<u8> {
    let degree = i8::from_le_bytes(degree.try_into().unwrap()) as usize;
    let data: Vec<(f64, f64)> = from_reader(data).unwrap();
    let fit = MonomialFit::new_auto(&data, degree, &Aic).unwrap();
    let mut out = Vec::new();
    into_writer(
        &(
            fit.coefficients(),
            fit.equation(),
            fit.degree(),
            fit.r_squared(None)
        ),
        &mut out
    )
    .unwrap();
    out
}
