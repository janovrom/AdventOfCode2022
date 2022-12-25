string[] lines = File.ReadAllLines("./input.txt");
int maxx = lines.Length - 2;
int maxy = lines[0].Length - 2;
Dictionary<int, Dictionary<(int, int), List<Wind>>> winds = new();
HashSet<(int, int)> walls = new();
winds[0] = new();
/*
 * 0yyyy
 * x
 * x
 * x
 */
for (int i = 0; i < lines.Length; i++)
{
    string line = lines[i];
    for (int j = 0; j < line.Length; j++)
    {
        char c = line[j];
        if (c == '>')
        {
            AddWind(0, Wind.East, i - 1, j - 1);
        }
        else if (c == 'v')
        {
            AddWind(0, Wind.South, i - 1, j - 1);
        }
        else if (c == '<')
        {
            AddWind(0, Wind.West, i - 1, j - 1);
        }
        else if (c == '^')
        {
            AddWind(0, Wind.North, i - 1, j - 1);
        }
        else if (c == '#')
        {
            walls.Add((i - 1, j - 1));
        }
    }
}

// Just arbitrary guess on the upper bound. It's at least 2 times.
int expectedLongestTime = 10 * (lines.Length + lines[0].Length);
for (int i = 0; i < expectedLongestTime; i++)
{
    foreach (((int x, int y), List<Wind> windOnPosition) in winds[i])
    {
        foreach (Wind wind in windOnPosition)
        {
            (int newx, int newy) = MoveWind(x, y, wind);
            AddWind(i + 1, wind, newx, newy);
        }
    }
}

int endx = maxx;
int endy = maxy - 1;

int fastestTime = GetTraverseTime(-1, 0, endx, endy, 0);
int traverseBackTime = GetTraverseTime(endx, endy, -1, 0, fastestTime);
int traverseBackBackTime = GetTraverseTime(-1, 0, endx, endy, fastestTime + traverseBackTime);


Console.WriteLine($"We can finish in {fastestTime} minutes.");
Console.WriteLine($"We can finish part 2 in {fastestTime + traverseBackTime + traverseBackBackTime} minutes.");

int GetTraverseTime(int startx, int starty, int endx, int endy, int startminute)
{
    int fastestTime = int.MaxValue;
    Stack<(int, int, int)> states = new();
    states.Push((startx, starty, 0));

    Dictionary<(int, int, int), int> visitedStates = new();
    visitedStates.Add((startx, starty, 0), 0);

    while (states.Count > 0)
    {
        (int x, int y, int minute) = states.Pop();
        //Draw(x, y, minute);

        if (minute > fastestTime)
        {
            continue;
        }

        if (x == endx && y == endy)
        {
            // End state. We consider the end state as the one before the finish.
            fastestTime = Math.Min(fastestTime, minute);
            continue;
        }

        if (!winds.ContainsKey(startminute + minute + 1))
        {
            // We did not expect to be it that long. Stop.
            continue;
        }

        var winds1 = winds[startminute + minute + 1];
        if (CanMoveUp(x, y) && !winds1.ContainsKey((x - 1, y)))
        {
            AddState(x - 1, y, minute + 1, visitedStates, states);
        }

        if (CanMoveLeft(x, y) && !winds1.ContainsKey((x, y - 1)))
        {
            AddState(x, y - 1, minute + 1, visitedStates, states);
        }

        if (!winds1.ContainsKey((x, y)))
        {
            // Stay in place
            AddState(x, y, minute + 1, visitedStates, states);
        }

        if (CanMoveRight(x, y) && !winds1.ContainsKey((x, y + 1)))
        {
            AddState(x, y + 1, minute + 1, visitedStates, states);
        }

        if (CanMoveDown(x, y) && !winds1.ContainsKey((x + 1, y)))
        {
            AddState(x + 1, y, minute + 1, visitedStates, states);
        }
    }

    return fastestTime;
}

void AddState(int x, int y, int minute, Dictionary<(int, int, int), int> visitedStates, Stack<(int, int, int)> states)
{
    if (visitedStates.TryGetValue((x, y, minute), out int bestMinute))
    {
        if (bestMinute <= minute)
        {
            // We already got there faster, stop.
            return;
        }
    }
    
    visitedStates[(x, y, minute)] = minute;
    states.Push((x, y, minute));
}

bool CanMoveDown(int x, int y) => x + 1 <= maxx && !walls.Contains((x + 1, y));

bool CanMoveUp(int x, int y) => x - 1 >= -1 && !walls.Contains((x - 1, y));

bool CanMoveRight(int x, int y) => y + 1 <= maxy && !walls.Contains((x, y + 1));

bool CanMoveLeft(int x, int y) => y - 1 >= -1 && !walls.Contains((x, y - 1));

void Draw(int x, int y, int minute)
{
    Console.WriteLine($"Winds at {minute} minute.");
    for (int i = 0; i < lines.Length; i++)
    {
        for (int j = 0; j < lines[i].Length ; j++)
        {
            int ti = i - 1;
            int tj = j - 1;

            if (winds[minute].TryGetValue((ti, tj), out List<Wind> windsInTime))
            {
                if (windsInTime.Count == 1)
                {
                    Console.Write(ToChar(windsInTime.First()));
                }
                else
                {
                    Console.Write(windsInTime.Count);
                }
            }
            else
            {
                if (ti == x && tj == y)
                {
                    Console.Write("E");
                    continue;
                }

                if (walls.Contains((ti, tj)))
                    Console.Write('#');
                else
                    Console.Write(".");
            }
        }

        Console.WriteLine();
    }

    Console.ReadLine();
}

(int, int) MoveWind(int x, int y, Wind w)
{
    return w switch
    {
        Wind.North => (x - 1, y),
        Wind.East => (x, y + 1),
        Wind.South => (x + 1, y),
        Wind.West => (x, y - 1),
    };
}

char ToChar(Wind w)
{
    return w switch
    {
        Wind.North => '^',
        Wind.East => '>',
        Wind.South => 'v',
        Wind.West => '<',
    };
}

void AddWind(int minute, Wind w, int i, int j)
{
    if (i < 0)
    {
        i += maxx;
    }

    if (j < 0)
    {
        j += maxy;
    }

    i = i % maxx;
    j = j % maxy;

    if (!winds.ContainsKey(minute))
    {
        winds[minute] = new();
    }

    if (!winds[minute].ContainsKey((i, j)))
    {
        winds[minute][(i, j)] = new();
    }
    winds[minute][(i, j)].Add(w);
}

enum Wind
{
    North,
    East,
    South,
    West
}