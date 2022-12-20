#include <iostream>
#include "Day1.h"

int main()
{
    Program1 day1;
    day1.Initialize();
    std::cout << day1.RunPart1() << std::endl;
    std::cout << day1.RunPart2();
}