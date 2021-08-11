// 537. Complex Number Multiplication
// https://leetcode.com/problems/complex-number-multiplication/

struct Solution {}

impl Solution {
    pub fn complex_number_multiply(num1: String, num2: String) -> String {
        let (re1, im1) = Self::re_im(num1);
        let (re2, im2) = Self::re_im(num2);
        format!("{}+{}i", re1 * re2 - im1 * im2, re1 * im2 + im1 * re2)
    }

    fn re_im(num: String) -> (i32, i32) {
        let mut split = num[..num.len() - 1].split('+');
        (
            split.next().unwrap().parse().unwrap(),
            split.next().unwrap().parse().unwrap(),
        )
    }
}

#[rustfmt::skip]
fn main() {
    for (num1, num2) in [
        ("1+1i", "1+1i"),
        ("1+-1i", "1+-1i"),
    ] {
        println!("{}", Solution::complex_number_multiply(num1.to_string(), num2.to_string()));
    }
}
