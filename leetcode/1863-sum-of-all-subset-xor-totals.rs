// 1863. Sum of All Subset XOR Totals
// https://leetcode.com/problems/sum-of-all-subset-xor-totals/

struct Solution {}

impl Solution {
    pub fn subset_xor_sum(nums: Vec<i32>) -> i32 {
        // See https://stackoverflow.com/q/40718975.
        (0..2_i32.pow(nums.len() as u32))
            .map(|i| {
                nums.iter()
                    .enumerate()
                    .filter(|(t, _)| (i >> t) % 2 == 1)
                    .fold(0, |res, (_, x)| res ^ x)
            })
            .sum()
    }
}

fn main() {
    for nums in [
        vec![1, 3],
        vec![5, 1, 6],
        vec![3, 4, 5, 6, 7, 8],
        vec![20, 3, 10, 17, 5, 15, 13, 15, 17, 8, 14, 1],
    ] {
        println!("{:#?}", Solution::subset_xor_sum(nums));
    }
}
