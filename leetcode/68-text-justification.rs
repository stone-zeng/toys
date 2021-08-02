// 68. Text Justification
// https://leetcode.com/problems/text-justification/

struct Solution {}

impl Solution {
    pub fn full_justify(words: Vec<String>, max_width: i32) -> Vec<String> {
        let max_width = max_width as usize;
        let justify = |line: &Vec<String>| {
            if line.len() == 1 {
                format!("{:<0width$}", line[0], width = max_width)
            } else {
                let num_space = max_width - line.iter().map(|i| i.len()).sum::<usize>();
                let mut line = line.clone();
                let mut s = 0;
                loop {
                    for i in 0..line.len() - 1 {
                        line[i] += " ";
                        s += 1;
                        if s == num_space {
                            return line.join("");
                        }
                    }
                }
            }
        };
        let justify_last_line =
            |line: &Vec<String>| format!("{:<0width$}", line.join(" "), width = max_width);
        let mut width = 0;
        let mut line = Vec::new();
        let mut res = Vec::new();
        let mut i = 0;
        while i < words.len() {
            let word = words[i].clone();
            width += word.len();
            if width + line.len() > max_width {
                res.push(justify(&line));
                line.clear();
                width = 0;
            } else {
                line.push(word);
                i += 1;
            }
        }
        res.push(justify_last_line(&line));
        res
    }
}

#[rustfmt::skip]
fn main() {
    for (words, max_width) in [
        (vec!["Hello"], 8),
        (vec!["This", "is", "an", "example", "of", "text", "justification."], 16),
        (vec!["What","must","be","acknowledgment","shall","be"], 16),
        (vec!["Science","is","what","we","understand","well","enough","to","explain","to","a","computer.","Art","is","everything","else","we","do"], 20),
    ] {
        let words = words.iter().map(|&i| i.to_string()).collect();
        println!("{:#?}", Solution::full_justify(words, max_width));
    }
}
