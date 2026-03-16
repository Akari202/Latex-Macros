use std::collections::{HashMap, HashSet};
use std::fmt;

#[derive(Debug, Clone)]
pub enum Expression {
    Var(String),
    Not(Box<Expression>),
    And(Box<Expression>, Box<Expression>),
    Or(Box<Expression>, Box<Expression>),
    Xor(Box<Expression>, Box<Expression>),
    Implication(Box<Expression>, Box<Expression>),
    Equivalence(Box<Expression>, Box<Expression>)
}

impl fmt::Display for Expression {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.fmt_prec(f, 0)
    }
}

impl Expression {
    pub fn eval(&self, env: &HashMap<String, bool>) -> bool {
        match self {
            Expression::Var(name) => *env.get(name).unwrap_or(&false),
            Expression::Not(e) => !e.eval(env),
            Expression::And(l, r) => l.eval(env) && r.eval(env),
            Expression::Or(l, r) => l.eval(env) || r.eval(env),
            Expression::Xor(l, r) => l.eval(env) != r.eval(env),
            Expression::Implication(l, r) => !l.eval(env) || r.eval(env),
            Expression::Equivalence(l, r) => l.eval(env) == r.eval(env)
        }
    }

    fn precedence(&self) -> u8 {
        match self {
            Expression::Var(_) => 6,
            Expression::Not(_) => 5,
            Expression::And(_, _) => 4,
            Expression::Xor(_, _) => 3,
            Expression::Or(_, _) => 2,
            Expression::Implication(_, _) | Expression::Equivalence(_, _) => 1
        }
    }

    fn fmt_prec(&self, f: &mut fmt::Formatter<'_>, min_prec: u8) -> fmt::Result {
        let prec = self.precedence();
        let wrap = prec < min_prec;
        if wrap {
            write!(f, "(")?;
        }

        match self {
            Expression::Var(s) => write!(f, "{}", s)?,
            Expression::Not(e) => {
                write!(f, "not ")?;
                e.fmt_prec(f, 5)?;
            }
            Expression::And(l, r) => {
                l.fmt_prec(f, 4)?;
                write!(f, " and ")?;
                r.fmt_prec(f, 4 + 1)?;
            }
            Expression::Xor(l, r) => {
                l.fmt_prec(f, 3)?;
                write!(f, " xor ")?;
                r.fmt_prec(f, 3 + 1)?;
            }
            Expression::Or(l, r) => {
                l.fmt_prec(f, 2)?;
                write!(f, " or ")?;
                r.fmt_prec(f, 2 + 1)?;
            }
            Expression::Implication(l, r) => {
                l.fmt_prec(f, 1 + 1)?;
                write!(f, " => ")?;
                r.fmt_prec(f, 1)?;
            }
            Expression::Equivalence(l, r) => {
                l.fmt_prec(f, 1)?;
                write!(f, " <=> ")?;
                r.fmt_prec(f, 1 + 1)?;
            }
        }

        if wrap {
            write!(f, ")")?;
        }
        Ok(())
    }

    pub fn get_vars(&self, vars: &mut Vec<String>) {
        match self {
            Expression::Var(name) => {
                if !vars.contains(name) {
                    vars.push(name.clone());
                }
            }
            Expression::Not(e) => e.get_vars(vars),
            Expression::And(l, r)
            | Expression::Or(l, r)
            | Expression::Xor(l, r)
            | Expression::Implication(l, r)
            | Expression::Equivalence(l, r) => {
                l.get_vars(vars);
                r.get_vars(vars);
            }
        }
    }

    pub fn collect_steps(&self, seen: &mut HashSet<String>, steps: &mut Vec<Expression>) {
        match self {
            Expression::Var(_) => {}
            _ => {
                match self {
                    Expression::Not(e) => e.collect_steps(seen, steps),
                    Expression::And(l, r)
                    | Expression::Or(l, r)
                    | Expression::Xor(l, r)
                    | Expression::Implication(l, r)
                    | Expression::Equivalence(l, r) => {
                        l.collect_steps(seen, steps);
                        r.collect_steps(seen, steps);
                    }
                    _ => {}
                }

                let h = format!("{self}");
                if !seen.contains(&h) {
                    seen.insert(h);
                    steps.push(self.clone());
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_expression() {
        let expr = Expression::Or(
            Box::new(Expression::Not(Box::new(Expression::And(
                Box::new(Expression::Var("p".to_string())),
                Box::new(Expression::Var("q".to_string()))
            )))),
            Box::new(Expression::Or(
                Box::new(Expression::Var("p".to_string())),
                Box::new(Expression::Var("q".to_string()))
            ))
        );

        let cases = [(true, true), (true, false), (false, true), (false, false)];

        for (p_val, q_val) in cases {
            let mut env = HashMap::new();
            env.insert("p".to_string(), p_val);
            env.insert("q".to_string(), q_val);

            let result = expr.eval(&env);

            assert!(
                result,
                "Failed for p={}, q={}. Expected true, got false.",
                p_val, q_val
            );
        }
    }
}
