// 233. Number of Digit One
// https://leetcode.com/problems/number-of-digit-one/

struct Solution {}

impl Solution {
    pub fn count_digit_one(n: i32) -> i32 {
        Self::count_digit_one_i64(n as i64) as i32
    }

    fn count_digit_one_i64(n: i64) -> i64 {
        match n {
            0 => 0,
            _ => Self::digits(n)
                .iter()
                .enumerate()
                .map(|(i, d)| {
                    let b = 10_i64.pow(i as u32);
                    n / (10 * b) * b
                        + match d {
                            0 => 0,
                            1 => n % b + 1,
                            _ => b,
                        }
                })
                .sum(),
        }
    }

    fn digits(n: i64) -> Vec<i64> {
        let mut n = n;
        let mut res = Vec::new();
        while n >= 1 {
            res.push(n % 10);
            n /= 10;
        }
        res
    }
}

fn main() {
    for n in &[0, 2, 13, 102, 573, 1712, 1410065408, 2000000000] {
        println!("{}: {}", n, Solution::count_digit_one(*n))
    }
}
