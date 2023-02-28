#include <iostream>
#include <fstream>
#include <regex>
#include <set>

using namespace std;

int main() {
    string filename = "sample.txt";
    ifstream file(filename);
    if (!file.is_open()) {
        cerr << "Failed to open file: " << filename << endl;
        return -1;
    }

    string line;
    regex re("\\b[a-z_]+\\b");
    smatch match;
    set<string> matches;

    while (getline(file, line)) {
        auto words_begin = sregex_iterator(line.begin(), line.end(), re);
        auto words_end = sregex_iterator();

        for (sregex_iterator i = words_begin; i != words_end; ++i) {
            string match_str = i->str();
            if (match_str.front() != ' ' && match_str.back() != ' ') {
                matches.insert(match_str);
            }
        }
    }

    for (const auto& match : matches) {
        cout <<match<<" ";
    }

    return 0;
}
