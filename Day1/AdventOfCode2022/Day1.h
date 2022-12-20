#pragma once

#include <vector>

class Elf
{
public:
	void AddCalories(int calorie);
	int SumCalories();

	Elf();
private:
	std::vector<int> _calories = std::vector<int>();
	int _sum = 0;
};

class Program1
{
public:
	void Initialize();
	int RunPart1();
	int RunPart2();

private:
	std::vector<Elf> _elves = std::vector<Elf>();
};