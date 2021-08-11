// 954. Array of Doubled Pairs
// https://leetcode.com/problems/array-of-doubled-pairs/

use std::cmp::Ordering;
use std::collections::BTreeMap;

#[derive(PartialEq, Eq, Clone, Copy, Debug)]
struct Item(i32);

impl PartialOrd for Item {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.0.partial_cmp(&(other.0))
    }
}

impl Ord for Item {
    fn cmp(&self, other: &Self) -> Ordering {
        let ord = self.0.abs().cmp(&(other.0.abs()));
        match ord {
            Ordering::Equal => self.0.cmp(&(other.0)),
            _ => ord,
        }
    }
}

struct Solution {}

impl Solution {
    pub fn can_reorder_doubled(arr: Vec<i32>) -> bool {
        let mut map = BTreeMap::new();
        arr.iter().for_each(|&i| *map.entry(Item(i)).or_insert(0) += 1);

        if let Some(zero_count) = map.get(&Item(0)) {
            if zero_count % 2 == 0 {
                map.remove(&Item(0));
            } else {
                return false;
            }
        }

        macro_rules! map_pop {
            ($key:expr, $count:expr) => {
                if $count == 1 {
                    map.remove(&$key);
                } else {
                    map.entry($key).and_modify(|e| *e -= 1);
                }
            };
        }

        loop {
            if let Some((&first, &first_count)) = map.iter().next() {
                let doubled = Item(first.0 * 2);
                match map.get(&doubled) {
                    Some(&doubled_count) => {
                        map_pop!(first, first_count);
                        map_pop!(doubled, doubled_count);
                    }
                    _ => {
                        return false;
                    }
                }
            } else {
                return true;
            }
        }

        // // The Vec implementation is much slower.
        // let mut arr = arr;
        // arr.sort_unstable_by_key(|a| a.abs());
        // loop {
        //     if let Some(first) = arr.first() {
        //         if let Some(index) = arr[1..].iter().position(|&n| n == first * 2) {
        //             arr.remove(index + 1);
        //             arr.remove(0);
        //         } else {
        //             return false;
        //         }
        //     } else {
        //         return true;
        //     }
        // }
    }
}

fn main() {
    for (arr, res) in [
        (vec![3, 1, 3, 6], false),
        (vec![2, 1, 2, 6], false),
        (vec![4, -2, 2, -4], true),
        (vec![1, 2, 4, 16, 8, 4], false),
        (vec![0, -33], false),
        (vec![0, 0], true),
    ] {
        assert_eq!(Solution::can_reorder_doubled(arr), res);
    }
}
