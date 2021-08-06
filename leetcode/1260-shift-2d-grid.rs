// 1260. Shift 2D Grid
// https://leetcode.com/problems/shift-2d-grid/

struct Solution {}

impl Solution {
    pub fn shift_grid(grid: Vec<Vec<i32>>, k: i32) -> Vec<Vec<i32>> {
        let m = grid.len();
        let n = grid[0].len();
        let mut grid_1d = grid.into_iter().flatten().collect::<Vec<_>>();
        grid_1d.rotate_right(k as usize % (m * n));
        grid_1d.chunks(n).map(|v| v.to_vec()).collect()
    }
}

#[rustfmt::skip]
fn main() {
    for (grid, k) in [
        (vec![vec![1,2,3],vec![4,5,6],vec![7,8,9]], 1),
        (vec![vec![3,8,1,9],vec![19,7,2,5],vec![4,6,11,10],vec![12,0,21,13]], 4),
        (vec![vec![1,2,3],vec![4,5,6],vec![7,8,9]], 9),
        (vec![vec![1]], 9),
    ] {
        println!("{:?}", Solution::shift_grid(grid, k));
    }
}
