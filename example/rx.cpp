#include <iostream>
#include <boost/regex.hpp>

using namespace boost;

int main() {
    std::string s("foo BAR baz");

    std::cout << "/foo/   " << regex_search(s, regex("foo")) << std::endl;
    std::cout << "/bar/   " << regex_search(s, regex("bar")) << std::endl;
    std::cout << "/./     " << regex_search(s, regex(".")) << std::endl;
    std::cout << "/[a-z]/ " << regex_search(s, regex("[a-z]")) << std::endl;

    return 0;
}

