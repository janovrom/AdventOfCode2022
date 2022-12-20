//string[] lines = File.ReadAllLines("./input.txt");

//Dictionary<string, HashSet<string>> edges = new();
//Dictionary<string, int> rates = new();
//Dictionary<string, Dictionary<string, int>> pathValues = new();

//void AddRoute(string start, string end)
//{
//    if (!edges.ContainsKey(start))
//        edges.Add(start, new HashSet<string>());

//    if (!edges.ContainsKey(end))
//        edges.Add(end, new HashSet<string>());

//    edges[start].Add(end);
//    edges[end].Add(start);
//}

//foreach (string line in lines)
//{
//    string sanitized = line.Substring(6)
//        .Replace(" has flow rate=", ",")
//        .Replace("tunnels", "tunnel")
//        .Replace("leads", "lead")
//        .Replace("valves", "valve")
//        .Replace("; tunnel lead to valve ", ",").Replace(" ", "");
//    string[] dataArray = sanitized.Split(",");
//    string start = dataArray[0];

//    rates[start] = int.Parse(dataArray[1]);

//    for (int i = 2; i < dataArray.Length; i++)
//    {
//        AddRoute(start, dataArray[i]);
//    }
//}

//foreach (string start in rates.Keys)
//{
//    pathValues[start] = new Dictionary<string, int>();
//    FullyConnect(start, start, 0);
//}

//HashSet<string> toOpen = rates.Where(r => r.Value > 0).Select(r => r.Key).ToHashSet();
//HashSet<string> opened = new();

//int score = Traverse("AA", 0);
//Console.WriteLine($"Best score is {score}");


//int Traverse(string current, int minute)
//{
//    if (minute >= 30)
//        return 0;

//    if (toOpen.Count == 0)
//        return 0;

//    int maxScore = 0;
//    int remainingTime = 30 - minute;
//    foreach (string valve in toOpen)
//    {
//        if (opened.Contains(valve))
//            continue;

//        int time = pathValues[current][valve];

//        if (remainingTime - time - 1 < 0)
//            continue;

//        int score = rates[valve] * (remainingTime - time - 1);

//        opened.Add(valve);

//        score += Traverse(valve, minute + time + 1);
//        maxScore = Math.Max(score, maxScore);

//        opened.Remove(valve);
//    }

//    return maxScore;
//}

//void FullyConnect(string start, string current, int length)
//{
//    foreach (string end in edges[current])
//    {
//        if (pathValues[start].ContainsKey(end))
//        {
//            if (length + 1 < pathValues[start][end])
//            {
//                pathValues[start][end] = length + 1;
//                FullyConnect(start, end, length + 1);
//            }
//            continue;
//        }

//        pathValues[start].Add(end, length + 1);
//        FullyConnect(start, end, length + 1);
//    }
//}