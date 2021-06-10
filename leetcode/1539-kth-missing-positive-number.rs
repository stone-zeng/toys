// 1539. Kth Missing Positive Number
// https://leetcode.com/problems/kth-missing-positive-number/

struct Solution { }

impl Solution {
    pub fn find_kth_positive(arr: Vec<i32>, k: i32) -> i32 {
        let mut x = 0;
        for i in 1.. {
            if arr.binary_search(&i).is_err() || arr.last().unwrap() < &i { x += 1; }
            if x == k { return i; }
        }
        unreachable!()
    }
}

fn main() {
    let arr = vec![6,17,21,34,52,71,77,90,110,116,118,124,132,136,149,158,164,165];
    println!("{:?}", Solution::find_kth_positive(arr, 13))
}
