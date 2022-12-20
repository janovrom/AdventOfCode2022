#include "Day1.h"
#include <numeric>
#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>

Elf::Elf()
{
}

void Elf::AddCalories(int calorie)
{
    _sum += calorie;
    _calories.emplace_back(calorie);
}

int Elf::SumCalories()
{
    return _sum;
    //return std::accumulate(_calories.begin(), _calories.end(), 0);
}

void Program1::Initialize()
{
    std::ifstream inputFile("input.txt");
    _elves.emplace_back(Elf());

    std::string line;
    while (std::getline(inputFile, line))
    {
        if (line.empty())
        {
            // Make new elf
            _elves.emplace_back(Elf());
        }
        else
        {
            int calories = std::stoi(line);
            _elves[_elves.size() - 1].AddCalories(calories);
        }
    }

    std::sort(_elves.begin(), _elves.end(), [](Elf& x, Elf& y)
    {
        return x.SumCalories() > y.SumCalories();
    });
}

int Program1::RunPart1()
{
    return _elves.front().SumCalories();
}

int Program1::RunPart2()
{
    return _elves[0].SumCalories() + _elves[1].SumCalories() + _elves[2].SumCalories();
}