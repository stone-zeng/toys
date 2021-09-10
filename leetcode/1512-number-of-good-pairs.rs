// 1512. Number of Good Pairs
// https://leetcode.com/problems/number-of-good-pairs/

struct Solution {}

impl Solution {
    pub fn num_identical_pairs(nums: Vec<i32>) -> i32 {
        nums.iter()
            .enumerate()
            .map(|(k, i)| nums.iter().skip(k + 1).filter(|&j| i == j).count() as i32)
            .sum()
    }
}

fn main() {
    for (nums, res) in [
        (vec![1, 2, 3, 1, 1, 3], 4),
        (vec![1, 1, 1, 1], 6),
        (vec![1, 2, 3], 0),
    ] {
        assert_eq!(Solution::num_identical_pairs(nums), res);
    }
}
