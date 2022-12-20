string[] lines = File.ReadAllLines("./input.txt");

Dictionary<string, HashSet<string>> edges = new();
Dictionary<string, int> rates = new();
Dictionary<string, Dictionary<string, int>> pathValues = new();

void AddRoute(string start, string end)
{
    if (!edges.ContainsKey(start))
        edges.Add(start, new HashSet<string>());

    if (!edges.ContainsKey(end))
        edges.Add(end, new HashSet<string>());

    edges[start].Add(end);
    edges[end].Add(start);
}

foreach (string line in lines)
{
    string sanitized = line.Substring(6)
        .Replace(" has flow rate=", ",")
        .Replace("tunnels", "tunnel")
        .Replace("leads", "lead")
        .Replace("valves", "valve")
        .Replace("; tunnel lead to valve ", ",").Replace(" ", "");
    string[] dataArray = sanitized.Split(",");
    string start = dataArray[0];

    rates[start] = int.Parse(dataArray[1]);

    for (int i = 2; i < dataArray.Length; i++)
    {
        AddRoute(start, dataArray[i]);
    }
}

foreach (string start in rates.Keys)
{
    pathValues[start] = new Dictionary<string, int>();
    FullyConnect(start, start, 0);
}

HashSet<string> toOpen = rates.Where(r => r.Value > 0).Select(r => r.Key).ToHashSet();
HashSet<string> opened = new();

List<List<string>> walkList = new();
Walk("AA", new List<string>() { }, 0, walkList);


int maxScore = 0;
foreach (List<string> walk in walkList)
{
    toOpen.RemoveWhere(x => walk.Contains(x));
    opened.Clear();
    int score = Traverse("AA", 0);
    score += EvaluateWalk(walk);

    maxScore = Math.Max(maxScore, score);

    foreach (string valve in walk)
        toOpen.Add(valve);
}

Console.WriteLine($"Best score is {maxScore}");

int EvaluateWalk(List<string> walk)
{
    int remaining = 26;
    int score = 0;
    string current = "AA";
    foreach (string valve in walk)
    {
        int time = pathValues[current][valve];
        remaining -= time + 1;
        score += rates[valve] * remaining;
        current = valve;
    }

    return score;
}

void Walk(string current, List<string> path, int minute, List<List<string>> walks)
{
    if (path.Count > 0)
    {
        walks.Add(path);
    }

    if (minute >= 26)
    {
        return;
    }

    foreach (string valve in toOpen)
    {
        if (path.Contains(valve))
            continue;

        opened.Add(valve);

        var l = new List<String>();
        l.AddRange(path);
        l.Add(valve);
        Walk(valve, l, minute + pathValues[current][valve] + 1, walks);

        opened.Remove(valve);
    }
}

int Traverse(string current, int minute)
{
    if (minute >= 26)
        return 0;

    if (toOpen.Count == 0)
        return 0;

    int maxScore = 0;
    int remainingTime = 26 - minute;
    foreach (string valve in toOpen)
    {
        if (opened.Contains(valve))
            continue;

        int time = pathValues[current][valve];

        if (remainingTime - time - 1 < 0)
            continue;

        int score = rates[valve] * (remainingTime - time - 1);

        opened.Add(valve);

        score += Traverse(valve, minute + time + 1);
        maxScore = Math.Max(score, maxScore);

        opened.Remove(valve);
    }

    return maxScore;
}

void FullyConnect(string start, string current, int length)
{
    foreach (string end in edges[current])
    {
        if (pathValues[start].ContainsKey(end))
        {
            if (length + 1 < pathValues[start][end])
            {
                pathValues[start][end] = length + 1;
                FullyConnect(start, end, length + 1);
            }
            continue;
        }

        pathValues[start].Add(end, length + 1);
        FullyConnect(start, end, length + 1);
    }
}