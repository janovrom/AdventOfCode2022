namespace Day19
{
    internal class Solver
    {

        internal void Solve(int minutes, string path)
        {
            List<Blueprint> blueprints = Blueprint.Load(path);

            int qualityLevel = 0;
            Parallel.For(0, blueprints.Count, (index) =>
            {
                Blueprint blueprint = blueprints[index];
                int timeToCut = int.MaxValue;
                int highestGeodeCount = 0;
                var initialState = new int[] { 1, 0, 0, 0, 0, 0, 0, 0, 0 };
                var pool = new List<int[]>();
                var stack = new Stack<int[]>();
                stack.Push(initialState);

                int iteration = 0;
                while (stack.Count > 0)
                {
                    iteration++;
                    var state = stack.Pop();

                    if (state[8] >= timeToCut && state[3] == 0)
                    {
                        pool.Add(state);
                        continue;
                    }

                    if (state[8] == minutes - 1 && state[3] == 0)
                    {
                        pool.Add(state);
                        continue;
                    }

                    if (state[8] >= minutes)
                    {
                        pool.Add(state);
                        highestGeodeCount = Math.Max(highestGeodeCount, state[7]);
                        continue;
                    }

                    state[8] += 1;

                    bool canBuildOre = true;
                    for (int j = 0; j < 3; j++)
                    {
                        // Cut the one because the resource was not yet added
                        if (state[j + 4] < blueprint[0][j])
                            canBuildOre = false;
                    }
                    if (!canBuildOre)
                        stack.Push(state);

                    for (int i = 0; i < 4; i++)
                    {
                        bool canBuild = true;
                        for (int j = 0; j < 3; j++)
                        {
                            // Cut the one because the resource was not yet added
                            if (state[j + 4] < blueprint[i][j])
                                canBuild = false;
                        }

                        if (canBuild)
                        {
                            if (i == 3)
                            {
                                timeToCut = Math.Min(timeToCut, state[8]);
                                highestGeodeCount = Math.Max(highestGeodeCount, minutes - state[8]);
                            }

                            int[] newState;
                            if (pool.Count > 0)
                            {
                                newState = pool[pool.Count - 1];
                                pool.RemoveAt(pool.Count - 1);
                            }
                            else
                            {
                                newState = new int[9];
                            }
                            Array.Copy(state, newState, 9);

                            newState[i] += 1;

                            for (int j = 0; j < 3; j++)
                            {
                                newState[j + 4] -= blueprint[i][j];
                            }

                            newState[4] += state[0];
                            newState[5] += state[1];
                            newState[6] += state[2];
                            newState[7] += state[3];
                            stack.Push(newState);
                        }
                    }
                     
                    state[4] += state[0];
                    state[5] += state[1];
                    state[6] += state[2];
                    state[7] += state[3];
                }

                Console.WriteLine($"Blueprint {index + 1} has {highestGeodeCount} after {iteration} iterations");
                Interlocked.Add(ref qualityLevel, (index + 1) * highestGeodeCount);
            });

            Console.WriteLine($"These blueprints have quality level {qualityLevel}");
        }
    }
}
