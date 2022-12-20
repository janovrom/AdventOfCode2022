string fileData = File.ReadAllText("./input.txt");
bool[] isRightWind = fileData.Select(x => x == '>').ToArray();

bool isPart2 = true;
long height = GetCycle(isRightWind.Length, isPart2 ? 1000000000000 : 2022);
Console.WriteLine($"The tower is {height} rocks tall.");

long GetHeight(long maxRocks, long rockStart = 0, int startStep = 0, int startHighest = 0)
{
    List<bool[]> shaft = new List<bool[]>
    {
        new bool[7],
        new bool[7],
        new bool[7],
        new bool[7]
    };

    long highestRock = startHighest;

    long rockCount = rockStart;
    int step = startStep;

    while (rockCount < maxRocks)
    {
        Rock rock = SpawnRock(rockCount);
        rockCount++;
        rock.X = 2;
        rock.Y = (int)(highestRock) + 3;

        int toAdd = rock.Y + rock.Height - shaft.Count;
        if (toAdd > 0)
        {
            for (int i = 0; i < toAdd; i++)
                shaft.Add(new bool[7]);
        }

        int x = rock.X;
        int y = rock.Y;
        while (y >= 0 && !rock.Intersects(shaft, x, y))
        {
            // Wind moves x
            if (isRightWind[step])
            {
                if (rock.CanMoveRight() && !rock.Intersects(shaft, x + 1, y))
                {
                    x++;
                }
            }
            else
            {
                if (rock.CanMoveLeft() && !rock.Intersects(shaft, x - 1, y))
                {
                    x--;
                }
            }
            rock.X = x;

            step = (step + 1) % isRightWind.Length;
            // Gravity moves y
            if (y > 0 && !rock.Intersects(shaft, x, y - 1))
            {
                y--;
                rock.Y = y;
            }
            else
            {
                break;
            }
        }

        rock.Place(shaft);
        highestRock = Math.Max(highestRock, rock.Y + rock.Height);
    }

    return highestRock;
}

long GetCycle(int windCycle, long maxRocks)
{
    List<bool[]> shaft = new List<bool[]>
    {
        new bool[7],
        new bool[7],
        new bool[7],
        new bool[7]
    };

    Dictionary<int, List<(int, int)>> tracker = new();

    int highestRock = 0;
    int index = -1;
    int step = 0;
    long cycleLength = -1;
    long heightBeforeCycle = -1;
    long heightCycle = -1;
    long rocksAfterCycle = -1;

    while (true)
    {
        index++;

        Rock rock = SpawnRock(index);
        rock.X = 2;
        rock.Y = highestRock + 3;

        int toAdd = rock.Y + rock.Height - shaft.Count;
        if (toAdd > 0)
        {
            for (int i = 0; i < toAdd; i++)
                shaft.Add(new bool[7]);
        }

        int x = rock.X;
        int y = rock.Y;
        while (y >= 0 && !rock.Intersects(shaft, x, y))
        {
            // Wind moves x
            if (isRightWind[step])
            {
                if (rock.CanMoveRight() && !rock.Intersects(shaft, x + 1, y))
                {
                    x++;
                }
            }
            else
            {
                if (rock.CanMoveLeft() && !rock.Intersects(shaft, x - 1, y))
                {
                    x--;
                }
            }
            rock.X = x;

            step = (step + 1) % isRightWind.Length;
            // Gravity moves y
            if (y > 0 && !rock.Intersects(shaft, x, y - 1))
            {
                y--;
                rock.Y = y;
            }
            else
            {
                break;
            }
        }

        rock.Place(shaft);
        highestRock = Math.Max(highestRock, rock.Y + rock.Height);

        if (rocksAfterCycle == index)
        {
            long modulus = highestRock - (heightBeforeCycle + ((index / cycleLength) - 1) * heightCycle);
            return heightBeforeCycle + (maxRocks / cycleLength - 1) * heightCycle + modulus;
        }

        if (index > 0)
            tracker[index] = new List<(int, int)>() { (highestRock, highestRock) };

        foreach (int i in tracker.Keys)
        {
            if (index % i != 0)
                continue;

            tracker[i].Add((highestRock, highestRock - tracker[i][^1].Item1));
            if (tracker[i].Count > 3 && 
                tracker[i][^1].Item2 == tracker[i][^2].Item2 && 
                tracker[i][^1].Item2 == tracker[i][^3].Item2 &&
                tracker[i][^1].Item2 == tracker[i][^4].Item2)
            {
                cycleLength = i;
                heightBeforeCycle = tracker[i][0].Item1;
                heightCycle = tracker[i][^1].Item2;
                rocksAfterCycle = index + ((maxRocks - 1) % cycleLength);
                break;
            }
            else if (tracker[i].Count > 3 && tracker[i][^1].Item2 != tracker[i][^2].Item2)
            {
                tracker.Remove(i);
            }
        }
    }
}

void Draw(List<bool[]> shaft)
{
    for (int i = shaft.Count - 1; i >= 0; i--)
    {
        Console.Write(i+1);
        Console.Write("\t|");
        foreach (bool b in shaft[i])
            Console.Write(b ? "#" : ".");
        Console.WriteLine("|");
    }

    Console.WriteLine("\t+-------+");
}

Rock SpawnRock(long step)
{
    long index = step % 5;
    return index switch
    {
        0 => new HorizontalLineRock(),
        1 => new StarRock(),
        2 => new LRock(),
        3 => new VerticalLineRock(),
        4 => new BlockRock()
    };
}

abstract class Rock
{
    public int X { get; set; }
    public int Y { get; set; }

    public abstract int Height { get; }
    public abstract int Width { get; }

    public abstract bool Intersects(List<bool[]> shaft, int x, int y);

    public abstract void Place(List<bool[]> shaft, bool value = true);

    public bool CanMoveLeft()
    {
        return X - 1 >= 0;
    }

    public bool CanMoveRight()
    {
        return X + Width < 7;
    }
}

class HorizontalLineRock : Rock
{
    public override int Height => 1;
    public override int Width => 4;

    public override bool Intersects(List<bool[]> shaft, int x, int y)
    {
        for (int i = x; i < x + 4;  ++i)
        {
            if (shaft[y][i])
                return true;
        }

        return false;
    }

    public override void Place(List<bool[]> shaft, bool value)
    {
        for (int i = X; i < X + 4; ++i)
        {
            shaft[Y][i] = value;
        }
    }
}

class StarRock : Rock
{
    public override int Height => 3;
    public override int Width => 3;

    public override bool Intersects(List<bool[]> shaft, int x, int y)
    {
        if (shaft[y][x + 1])
            return true;

        for (int i = x; i < x + 3; ++i)
        {
            if (shaft[y + 1][i])
                return true;
        }

        return shaft[y + 2][x + 1];
    }

    public override void Place(List<bool[]> shaft, bool value)
    {
        shaft[Y][X + 1] = value;

        for (int i = X; i < X + 3; ++i)
        {
            shaft[Y + 1][i] = value;
        }

        shaft[Y + 2][X + 1] = value;
    }
}

class LRock : Rock
{
    public override int Height => 3;
    public override int Width => 3;

    public override bool Intersects(List<bool[]> shaft, int x, int y)
    {
        for (int i = x; i < x + 3; ++i)
        {
            if (shaft[y][i])
                return true;
        }

        if (shaft[y + 1][x + 2])
            return true;

        return shaft[y + 2][x + 2];
    }

    public override void Place(List<bool[]> shaft, bool value)
    {
        for (int i = X; i < X + 3; ++i)
        {
            shaft[Y][i] = value;
        }

        shaft[Y + 1][X + 2] = value;

        shaft[Y + 2][X + 2] = value;
    }
}

class VerticalLineRock : Rock
{
    public override int Height => 4;
    public override int Width => 1;

    public override bool Intersects(List<bool[]> shaft, int x, int y)
    {
        for (int i = y; i < y + 4; ++i)
        {
            if (shaft[i][x])
                return true;
        }

        return false;
    }

    public override void Place(List<bool[]> shaft, bool value)
    {
        for (int i = Y; i < Y + 4; ++i)
        {
            shaft[i][X] = value;
        }
    }
}

class BlockRock : Rock
{
    public override int Height => 2;
    public override int Width => 2;

    public override bool Intersects(List<bool[]> shaft, int x, int y)
    {
        if (shaft[y][x])
            return true;

        if (shaft[y][x + 1])
            return true;

        if (shaft[y + 1][x])
            return true;

        if (shaft[y + 1][x + 1])
            return true;

        return false;
    }

    public override void Place(List<bool[]> shaft, bool value)
    {
        shaft[Y][X] = value;

        shaft[Y][X + 1] = value;

        shaft[Y + 1][X] = value;

        shaft[Y + 1][X + 1] = value;
    }
}