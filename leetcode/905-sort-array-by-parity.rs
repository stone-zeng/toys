// 905. Sort Array By Parity
// https://leetcode.com/problems/sort-array-by-parity/

struct Solution {}

impl Solution {
    pub fn sort_array_by_parity(nums: Vec<i32>) -> Vec<i32> {
        let mut res = nums;
        res.sort_unstable_by(|a, b| (a % 2).partial_cmp(&(b % 2)).unwrap());
        res
    }
}

fn main() {
    for nums in [
        vec![0],
        vec![3,1,2,4],
    ] {
        println!("{:?}", Solution::sort_array_by_parity(nums))
    }
}
