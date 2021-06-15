// 120. Triangle
// https://leetcode.com/problems/triangle/

use std::cmp::min;
use std::collections::HashMap;

struct Solution {}

impl Solution {
    pub fn minimum_total(triangle: Vec<Vec<i32>>) -> i32 {
        let mut map = HashMap::new();
        Self::minimum_total_helper(&triangle, &mut map, 0, 0)
    }

    fn minimum_total_helper(
        triangle: &Vec<Vec<i32>>,
        map: &mut HashMap<(usize, usize), i32>,
        i: usize,
        j: usize,
    ) -> i32 {
        if map.contains_key(&(i, j)) {
            return map[&(i, j)];
        }
        let res = if triangle.len() == i + 1 {
            triangle[i][j]
        } else {
            let left = Self::minimum_total_helper(triangle, map, i + 1, j);
            let right = Self::minimum_total_helper(triangle, map, i + 1, j + 1);
            triangle[i][j] + min(left, right)
        };
        map.insert((i, j), res);
        res
    }
}

fn main() {
    for triangle in vec![
        vec![vec![-10]],
        vec![vec![2], vec![3, 4], vec![6, 5, 7], vec![4, 1, 8, 3]],
        vec![
            vec![72],
            vec![94, 97],
            vec![75, 22, 84],
            vec![12, 0, 67, 44],
            vec![89, 58, 2, 84, 87],
            vec![78, 3, 1, 64, 51, 56],
            vec![74, 37, 25, 83, 94, 15, 54],
            vec![85, 52, 89, 94, 52, 57, 8, 48],
            vec![59, 35, 88, 46, 59, 45, 21, 85, 57],
            vec![32, 65, 74, 56, 88, 6, 17, 79, 88, 10],
        ],
    ] {
        println!("{}", Solution::minimum_total(triangle))
    }
}
