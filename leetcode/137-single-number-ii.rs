// 137. Single Number II
// https://leetcode.com/problems/single-number-ii/

use std::collections::HashMap;

struct Solution {}

impl Solution {
    pub fn single_number(nums: Vec<i32>) -> i32 {
        let mut count = HashMap::new();
        nums.iter().for_each(|&n| {
            let c = count.entry(n).or_insert(0);
            *c += 1;
        });
        *count.iter().find(|(_, &c)| c == 1).unwrap().0
    }
}

fn main() {
    for nums in [
        vec![2,2,3,2],
        vec![0,1,0,1,0,1,99],
    ] {
        println!("{}", Solution::single_number(nums));
    }
}
