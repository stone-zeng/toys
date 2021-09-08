// 836. Rectangle Overlap
// https://leetcode.com/problems/rectangle-overlap/

struct Solution {}

impl Solution {
    pub fn is_rectangle_overlap(rec1: Vec<i32>, rec2: Vec<i32>) -> bool {
        let overlap = |a1, a2, b1| (a1 <= b1 && b1 < a2);
        let (x11, y11, x12, y12) = (rec1[0], rec1[1], rec1[2], rec1[3]);
        let (x21, y21, x22, y22) = (rec2[0], rec2[1], rec2[2], rec2[3]);
        (overlap(x11, x12, x21) || overlap(x21, x22, x11)) &&
        (overlap(y11, y12, y21) || overlap(y21, y22, y11))
    }
}

fn main() {
    [
        ([0, 0, 2, 2], [1, 1, 3, 3], true),
        ([0, 0, 1, 1], [1, 0, 2, 1], false),
        ([0, 0, 1, 1], [2, 2, 3, 3], false),
        ([7, 8, 13, 15], [10, 8, 12, 20], true),
    ]
    .iter()
    .for_each(|(rec1, rec2, res)| {
        assert_eq!(Solution::is_rectangle_overlap(rec1.to_vec(), rec2.to_vec()), *res)
    })
}
