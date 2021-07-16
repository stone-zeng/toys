// 503. Next Greater Element II
// https://leetcode.com/problems/next-greater-element-ii/

struct Solution {}

impl Solution {
    pub fn next_greater_elements(nums: Vec<i32>) -> Vec<i32> {
        nums.iter()
            .enumerate()
            .map(|(i, &n_i)| {
                for &n_j in nums.iter().skip(i + 1).chain(nums.iter().take(i)) {
                    if n_i < n_j {
                        return n_j;
                    }
                }
                -1
            })
            .collect()
    }
}

fn main() {
    for nums in [
        vec![3],
        vec![1, 2, 1],
        vec![1, 2, 3, 4, 3],
        vec![5, 18, 3, 3, 5, 4, 14, 9, 16, 18],
    ] {
        println!("{:?}", Solution::next_greater_elements(nums))
    }
}
