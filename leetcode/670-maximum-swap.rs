// 670. Maximum Swap
// https://leetcode.com/problems/maximum-swap/

struct Solution {}

impl Solution {
    pub fn maximum_swap(num: i32) -> i32 {
        if num <= 11 {
            return num;
        }
        let digits = Self::digits(num);
        let mut res = num;
        for i in 0..digits.len() {
            for j in (i + 1)..digits.len() {
                if digits[i] < digits[j] {
                    res = std::cmp::max(res, Self::swap(num, &digits, i, j));
                }
            }
        }
        res
    }

    fn digits(n: i32) -> Vec<i32> {
        let mut n = n;
        let mut res = Vec::new();
        while n >= 1 {
            res.push(n % 10);
            n /= 10;
        }
        res.reverse();
        res
    }

    fn swap(num: i32, digits: &Vec<i32>, i: usize, j: usize) -> i32 {
        let pow_i = 10_i32.pow((digits.len() - i - 1) as u32);
        let pow_j = 10_i32.pow((digits.len() - j - 1) as u32);
        num - (digits[i] - digits[j]) * (pow_i - pow_j)
    }
}

fn main() {
    for n in &[0, 13, 2736, 9973, 1502, 6601, 423, 100_000_000] {
        println!("{}: {}", n, Solution::maximum_swap(*n))
    }
}
