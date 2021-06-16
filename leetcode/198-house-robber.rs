// 198. House Robber
// https://leetcode.com/problems/house-robber/

struct Solution { }

impl Solution {
    fn _rob(nums: &Vec<i32>, begin: usize, len: usize, temp: &mut Vec<i32>) -> i32 {
        match len - begin {
            0 => 0,
            1 => nums[begin],
            2 => i32::max(nums[begin], nums[begin + 1]),
            3 => i32::max(nums[begin] + nums[begin + 2], nums[begin + 1]),
            _ => {
                if temp[begin + 2] == -1 {
                    temp[begin + 2] = Solution::_rob(&nums, begin + 2, len, temp);
                }
                if temp[begin + 3] == -1 {
                    temp[begin + 3] = Solution::_rob(&nums, begin + 3, len, temp);
                }
                i32::max(nums[begin] + temp[begin + 2], nums[begin + 1] + temp[begin + 3])
            }
        }
    }

    pub fn rob(nums: Vec<i32>) -> i32 {
        let len = nums.len();
        let mut temp = vec![-1; len];
        Solution::_rob(&nums, 0, len, &mut temp)
    }
}

fn main() {
    for i in &[
        vec![],
        vec![1],
        vec![1,2],
        vec![1,2,3,1],
        vec![6,7,6,4],
        vec![52,87,1,60,8,46,87,92,55,45,18,36,49,15,72,34,49,59,55,93,82,65,8,6,60,76,90,13,11,51,12,69,71,67,59,59,56,40,66,94,38,81,93,54,85,16,76,65,38,29,50,94,53,31,3,35,14,10,20,65,64,4,88,2,54,54,99,49,39,61,20,90,22,41,40,58,86,28,73,66,24,77,77,35,13,47,53,69,82,98,87,4,77,24,22,85,5,58,17,9],
    ] {
        println!("{}", Solution::rob(i.to_vec()));
    }
}
