// 1629. Slowest Key
// https://leetcode.com/problems/slowest-key/

struct Solution {}

impl Solution {
    pub fn slowest_key(release_times: Vec<i32>, keys_pressed: String) -> char {
        let mut time = release_times[0];
        let mut key = keys_pressed.chars().next().unwrap();
        release_times
            .iter()
            .zip(release_times.iter().skip(1))
            .zip(keys_pressed.chars().skip(1))
            .for_each(|((i, j), c)| {
                if j - i > time {
                    time = j - i;
                    key = c;
                } else if j - i == time && c > key {
                    key = c;
                }
            });
        key
    }
}

fn main() {
    for (release_times, keys_pressed, c) in [
        (vec![9, 29, 49, 50], "cbcd", 'c'),
        (vec![12, 23, 36, 46, 62], "spuda", 'a'),
    ] {
        assert_eq!(Solution::slowest_key(release_times, keys_pressed.to_string()), c);
    }
}
