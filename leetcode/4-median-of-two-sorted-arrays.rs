// 4. Median of Two Sorted Arrays
// https://leetcode.com/problems/median-of-two-sorted-arrays/

struct Solution {}

impl Solution {
    pub fn find_median_sorted_arrays(nums1: Vec<i32>, nums2: Vec<i32>) -> f64 {
        let mut nums = nums1;
        nums.extend(nums2.iter());
        nums.sort();
        match nums.len() {
            0 => 0.0,
            1 => nums[0] as f64,
            _ => match nums.len() % 2 {
                0 => {
                    let mid = nums.len() / 2;
                    (nums[mid - 1] + nums[mid]) as f64 / 2.0
                }
                1 => nums[(nums.len() - 1) / 2] as f64,
                _ => unreachable!(),
            },
        }
    }
}

fn main() {
    for (nums1, nums2) in [
        (vec![1, 3], vec![2]),
        (vec![1, 2], vec![3, 4]),
        (vec![0, 0], vec![0, 0]),
        (vec![], vec![1]),
        (vec![2], vec![]),
    ] {
        println!("{:?}", Solution::find_median_sorted_arrays(nums1, nums2));
    }
}
