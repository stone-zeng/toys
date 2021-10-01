// 401. Sum of squares of divisors

const K: u128 = 1_000_000_000;
const N: u128 = 1_000_000_000_000_000;
const N_SQRT: u128 = 31_622_776;

#[rustfmt::skip]
const fn square_sum_mod_k(a: u128, b: u128) -> u128 {
    let mut x = b - a + 1;
    let mut y = b - a + 2 * (a * a + a * b + b * b);
    if x % 2 == 0 { x /= 2; } else { y /= 2; }
    if x % 3 == 0 { x /= 3; } else { y /= 3; }
    ((x % K) * (y % K)) % K
}

#[allow(non_snake_case)]
fn SIGMA2_mod_k() -> u128 {
    let res: u128 = (1..=N_SQRT)
        .map(|i| {
            let part_1 = i * i * (N / i);
            let a = N / (i + 1) + 1;
            let b = N / i;
            if a > N_SQRT {
                part_1 + i * square_sum_mod_k(a, b)
            } else {
                part_1
            }
        })
        .sum();
    res % K
}

fn main() {
    println!("{}", SIGMA2_mod_k());
}
