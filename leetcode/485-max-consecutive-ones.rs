// 485. Max Consecutive Ones
// https://leetcode.com/problems/max-consecutive-ones/

struct Solution {}

impl Solution {
    pub fn find_max_consecutive_ones(nums: Vec<i32>) -> i32 {
        let mut res = 0;
        let mut temp = 0;
        nums.iter().for_each(|n| match n {
            0 => {
                res = res.max(temp);
                temp = 0;
            }
            1 => temp += 1,
            _ => unreachable!(),
        });
        res.max(temp)
    }
}

fn main() {
    [
        (vec![1, 1, 0, 1, 1, 1], 3),
        (vec![1, 0, 1, 1, 0, 1], 2),
        (vec![0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0], 5),
    ]
    .iter()
    .for_each(|(nums, res)| assert_eq!(Solution::find_max_consecutive_ones(nums.to_vec()), *res));
}
