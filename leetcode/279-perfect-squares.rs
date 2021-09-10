// 279. Perfect Squares
// https://leetcode.com/problems/perfect-squares/

struct Solution {}

impl Solution {
    pub fn num_squares(n: i32) -> i32 {
        let n = n as usize;
        let mut v = vec![0; n];
        let squares: Vec<_> = (1..=n).map(|i| i * i).filter(|&i| i <= n).collect();
        (1..=n).for_each(|i| {
            let next = squares
                .iter()
                .filter(|&&s| s <= i)
                .map(|s| v[i - s] + 1)
                .min()
                .unwrap();
            v.insert(i, next);
        });
        v[n]
    }
}

fn main() {
    [(1, 1), (12, 3), (13, 2), (9765, 3)]
        .iter()
        .for_each(|(n, res)| assert_eq!(Solution::num_squares(*n), *res))
}
