// 682. Baseball Game
// https://leetcode.com/problems/baseball-game/

struct Solution {}

impl Solution {
    pub fn cal_points(ops: Vec<String>) -> i32 {
        let mut res = Vec::new();
        for op in ops {
            match op.as_str() {
                "C" => {
                    res.pop();
                }
                "D" => res.push(res[res.len() - 1] * 2),
                "+" => res.push(res[res.len() - 1] + res[res.len() - 2]),
                _ => res.push(op.parse().unwrap()),
            }
        }
        res.iter().sum()
    }
}

fn main() {
    for ops in [
        vec!["5","2","C","D","+"],
        vec!["5","-2","4","C","D","9","+","+"],
        vec!["1"],
    ] {
        let ops = ops.iter().map(|s| s.to_string()).collect();
        println!("{}", Solution::cal_points(ops));
    }
}
