// 989. Add to Array-Form of Integer
// https://leetcode.com/problems/add-to-array-form-of-integer/

struct Solution {}

impl Solution {
    pub fn add_to_array_form(num: Vec<i32>, k: i32) -> Vec<i32> {
        let k_arr = Self::num_to_vec(k);
        if k_arr.len() <= num.len() {
            Self::add_to_array_form_helper(num, k_arr)
        } else {
            Self::add_to_array_form_helper(k_arr, num)
        }
    }

    fn add_to_array_form_helper(num1: Vec<i32>, num2: Vec<i32>) -> Vec<i32> {
        let mut res = num1.clone();
        let mut flag = 0;
        for i in 0..num2.len() {
            let k_i = num2[num2.len() - i - 1];
            let pos = res.len() - i - 1;
            let res_i = res[pos];
            if flag + res_i + k_i < 10 {
                res[pos] += flag + k_i;
                flag = 0;
            } else {
                res[pos] += flag + k_i - 10;
                flag = 1;
            }
        }
        for i in num2.len()..num1.len() {
            let pos = res.len() - i - 1;
            let res_i = res[pos];
            if flag + res_i < 10 {
                res[pos] += flag;
                flag = 0;
            } else {
                res[pos] += flag - 10;
                flag = 1;
            }
        }
        if flag == 1 { res.insert(0, 1); }
        res
    }

    fn num_to_vec(k: i32) -> Vec<i32> {
        let mut k = k;
        let mut res = Vec::new();
        while k > 0 {
            let x = k % 10;
            res.push(x);
            k = (k - x) / 10;
        }
        res.reverse();
        res
    }
}

fn main() {
    println!("{:?}", Solution::add_to_array_form(vec![1,2,0,0], 34));
    println!("{:?}", Solution::add_to_array_form(vec![2,7,4], 181));
    println!("{:?}", Solution::add_to_array_form(vec![2,1,5], 806));
    println!("{:?}", Solution::add_to_array_form(vec![1,9], 124));
    println!("{:?}", Solution::add_to_array_form(vec![9,9,9,9,9,9,9,9,9,9], 1));
}
