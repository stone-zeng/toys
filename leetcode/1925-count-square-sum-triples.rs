// 1925. Count Square Sum Triples
// https://leetcode.com/problems/count-square-sum-triples/

struct Solution {}

impl Solution {
    pub fn count_triples(n: i32) -> i32 {
        let is_square = |x| {
            x <= n * n && {
                let s = (x as f32).sqrt() as i32;
                s * s == x
            }
        };
        (1..n)
            .map(|i| (1..n).map(move |j| (i, j)))
            .flatten()
            .filter(|(i, j)| is_square(i * i + j * j))
            .count() as i32
    }
}

fn main() {
    [(1, 0), (5, 2), (10, 4), (250, 330)]
        .iter()
        .for_each(|(n, res)| assert_eq!(Solution::count_triples(*n), *res));
}
