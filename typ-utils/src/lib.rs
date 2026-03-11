use std::collections::{HashMap, HashSet};
use std::error::Error;

use ciborium::{from_reader, into_writer};
use lalrpop_util::lalrpop_mod;
use polyfit::MonomialFit;
use polyfit::score::Aic;
use wasm_minimal_protocol::*;

use crate::logic::TableData;

mod logic;

lalrpop_mod!(boolean_logic);
initiate_protocol!();

#[cfg_attr(not(test), wasm_func)]
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

#[cfg_attr(not(test), wasm_func)]
pub fn truth_table(data: &[u8]) -> Result<Vec<u8>, Box<dyn Error>> {
    let statement = String::from_utf8(data.into())?;
    let parser = boolean_logic::ExprParser::new();
    let ast = parser.parse(&statement).map_err(|e| format!("{:?}", e))?;
    // Ok(format!("{ast}").into_bytes())

    let mut vars = Vec::new();
    ast.get_vars(&mut vars);
    vars.sort();

    let mut steps = Vec::new();
    let mut seen = HashSet::new();
    ast.collect_steps(&mut seen, &mut steps);

    let mut headers = vars.clone();
    for step in &steps {
        headers.push(format!("{step}"));
    }

    let mut rows = Vec::new();
    let num_vars = vars.len();
    for i in 0..(1 << num_vars) {
        let mut row = Vec::new();
        let mut env = HashMap::new();

        for (j, var) in vars.iter().enumerate() {
            let val = (i >> (num_vars - 1 - j)) & 1 == 1;
            env.insert(var.clone(), val);
            row.push(val);
        }

        for step in &steps {
            row.push(step.eval(&env));
        }
        rows.push(row);
    }

    let result = TableData { headers, rows };

    let mut buffer = Vec::new();
    into_writer(&result, &mut buffer)?;

    Ok(buffer)
}
