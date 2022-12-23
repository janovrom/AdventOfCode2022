using System.Collections.Generic;

string[] lines = File.ReadAllLines("./input.txt");
HashSet<(int,int)> elves = new();
Func<int, int, HashSet<(int, int)>, Dictionary<(int, int), List<(int, int)>>, bool>[] votingFunctions = new[]
{
    VoteNorth,
    VoteSouth,
    VoteWest,
    VoteEast
};
int currentVotingStrategy = 0;

for (int i = 0; i <  lines.Length; i++)
{
    for (int j = 0; j < lines[i].Length; j++)
    {
        if (lines[i][j] == '#')
        {
            // row, column
            elves.Add((i, j));
        }
    }
}

int round = 0;
int roundLimit = int.MaxValue;
bool elvesMoved = true;
while (elvesMoved && round < roundLimit)
{
    round++;
    Dictionary<(int, int), List<(int, int)>> votes = new();
    foreach ((int row, int col) in elves)
    {
        _ = Propose(row, col, elves, votes);
    }

    foreach (var pair in votes)
    {
        if (pair.Value.Count > 1)
            continue;

        elves.Remove(pair.Value.First());
        elves.Add(pair.Key);
    }

    elvesMoved = votes.Count > 0;
    currentVotingStrategy++;
}

int mincol = int.MaxValue; 
int maxcol = int.MinValue;
int minrow = int.MaxValue;
int maxrow = int.MinValue;
foreach ((int row, int col) in elves)
{
    mincol = Math.Min(mincol, col);
    maxcol = Math.Max(maxcol, col);
    minrow = Math.Min(minrow, row);
    maxrow = Math.Max(maxrow, row);
}

Console.WriteLine($"The area of bounding elf rectangle is {(maxrow - minrow + 1) * (maxcol - mincol + 1) - elves.Count}.");

if (elvesMoved)
    Console.WriteLine($"Elves didn't stop moving after {round} rounds.");
else
    Console.WriteLine($"Elves stopped moving after {round} rounds.");

bool AddVote((int,int) elf, (int,int) vote, Dictionary<(int, int), List<(int, int)>> votes)
{
    if (!votes.ContainsKey(vote))
    {
        votes[vote] = new List<(int,int)>();
        votes[vote].Add(elf);
        return true;
    }

    votes[vote].Add(elf);
    return false;
}

bool Propose(int row, int col, HashSet<(int,int)> elves, Dictionary<(int,int), List<(int,int)>> votes)
{
    if (!AnyElfAround(row, col, elves))
    {
        return true;
    }

    for (int i = 0; i < 4; i++)
    {
        int idx = (i + currentVotingStrategy) % 4;
        if (votingFunctions[idx].Invoke(row, col, elves, votes))
        {
            return true;
        }
    }
    

    return false;
}

bool VoteNorth(int row, int col, HashSet<(int, int)> elves, Dictionary<(int, int), List<(int, int)>> votes)
{
    int r = row - 1;
    if (!elves.Contains((r, col - 1)) && !elves.Contains((r, col)) && !elves.Contains((r, col + 1)))
    {
        AddVote((row, col), (r, col), votes);
        return true;
    }

    return false;
}

bool VoteSouth(int row, int col, HashSet<(int, int)> elves, Dictionary<(int, int), List<(int, int)>> votes)
{
    int r = row + 1;
    if (!elves.Contains((r, col - 1)) && !elves.Contains((r, col)) && !elves.Contains((r, col + 1)))
    {
        AddVote((row, col), (r, col), votes);
        return true;
    }

    return false;
}

bool VoteEast(int row, int col, HashSet<(int, int)> elves, Dictionary<(int, int), List<(int, int)>> votes)
{
    int c = col + 1;
    if (!elves.Contains((row - 1, c)) && !elves.Contains((row, c)) && !elves.Contains((row + 1, c)))
    {
        AddVote((row, col), (row, c), votes);
        return true;
    }

    return false;
}

bool VoteWest(int row, int col, HashSet<(int, int)> elves, Dictionary<(int, int), List<(int, int)>> votes)
{
    int c = col - 1;
    if (!elves.Contains((row - 1, c)) && !elves.Contains((row, c)) && !elves.Contains((row + 1, c)))
    {
        AddVote((row, col), (row, c), votes);
        return true;
    }

    return false;
}

bool AnyElfAround(int row, int col, HashSet<(int, int)> elves)
{
    for (int i = -1; i <= 1; i++)
    {
        for (int j = -1; j <= 1; j++)
        {
            if (i == 0 && j == 0)
                continue;

            if (elves.Contains((row + i, col + j)))
                return true;
        }
    }

    return false;
}