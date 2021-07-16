// 1037. Valid Boomerang
// https://leetcode.com/problems/valid-boomerang/

struct Solution {}

impl Solution {
    pub fn is_boomerang(points: Vec<Vec<i32>>) -> bool {
        let (p0, p1, p2) = (&points[0], &points[1], &points[2]);
        if p0 == p1 || p1 == p2 {
            false
        } else {
            let (x0, x1, x2) = (p0[0], p1[0], p2[0]);
            let (y0, y1, y2) = (p0[1], p1[1], p2[1]);
            (x1 - x0) * (y2 - y1) != (x2 - x1) * (y1 - y0)
        }
    }
}

fn main() {
    for points in [
        [[1, 1], [2, 3], [3, 2]],
        [[1, 1], [2, 2], [3, 3]],
        [[0, 1], [0, 2], [1, 2]],
    ] {
        println!(
            "{}",
            Solution::is_boomerang(points.iter().map(|v| v.to_vec()).collect())
        )
    }
}
