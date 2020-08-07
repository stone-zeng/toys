// 14. Longest Collatz sequence

#include <algorithm>
#include <iostream>
#include <unordered_map>

class Collatz {
    typedef std::pair<uint32_t, uint32_t> Pair;

    std::unordered_map<uint32_t, uint32_t> data {{1, 1}};

    inline void next(uint32_t & n) {
        n = n % 2 ? 3 * n + 1: n / 2;
    }

    void update(uint32_t n) {
        uint32_t i = n;
        uint32_t len = 0;
        while(data.find(i) == data.end()) { next(i); ++len; }
        data[n] = len + data[i];
    }

public:
    uint32_t maxLength(uint32_t n) {
        for (auto i = 1; i <= n; ++i) update(i);
        auto result = std::max_element(
            data.begin(),
            data.end(),
            [] (const Pair & a, const Pair & b) -> bool {
                return a.second < b.second;
            });
        return result->first;
    }
};

int main() {
    Collatz collatz;
    std::cout << collatz.maxLength(1e6) << std::endl;
}
