// 746. Min Cost Climbing Stairs
// https://leetcode.com/problems/min-cost-climbing-stairs/

use std::cmp::min;
use std::collections::HashMap;

struct Solution {}

impl Solution {
    pub fn min_cost_climbing_stairs(cost: Vec<i32>) -> i32 {
        let mut map = HashMap::new();
        min(
            Self::helper(&cost, &mut map, 0),
            Self::helper(&cost, &mut map, 1),
        )
    }

    fn helper(cost: &Vec<i32>, map: &mut HashMap<usize, i32>, n: usize) -> i32 {
        if map.contains_key(&n) {
            map[&n]
        } else {
            let mut res = cost[n];
            if n + 2 < cost.len() {
                let a = Self::helper(&cost, map, n + 1);
                let b = Self::helper(&cost, map, n + 2);
                res += min(a, b);
            }
            map.insert(n, res);
            res
        }
    }
}

fn main() {
    for cost in vec![
        vec![2, 3],
        vec![10, 15, 20],
        vec![1, 100, 1, 1, 100],
        vec![1, 100, 1, 1, 1, 100, 1, 1, 100, 1],
    ] {
        println!("{}", Solution::min_cost_climbing_stairs(cost))
    }
}
