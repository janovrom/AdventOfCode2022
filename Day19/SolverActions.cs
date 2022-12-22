using System.Linq;

namespace Day19
{
    internal class SolverActions
    {
        internal void Solve(int minutes, string path)
        {
            List<Blueprint> blueprints = Blueprint.Load(path);
            int qualityLevel = 0;
            Parallel.For(0, blueprints.Count, (index) =>
            {
                Blueprint blueprint = blueprints[index];
                var stack = new Stack<State>();
                stack.Push(new State(minutes));
                int highestGeodeCount = 0;
                var pool = new List<State>()
                {
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes),
                    new State(minutes)
                };

                int iteration = 0;
                while (stack.Count > 0)
                {
                    iteration++;
                    var state = stack.Pop();
                    if (!state.IsInTimeLimit())
                    {
                        highestGeodeCount = Math.Max(highestGeodeCount, state.Geodes);
                        continue;
                    }

                    if (!state.HasBuildTarget())
                    {
                        for (int i = 0; i <= state.GetMaxRobot(); i++)
                        {
                            // Branch on this
                            State newState;
                            if (pool.Count > 0)
                            {
                                newState = pool[^1];
                                pool.RemoveAt(pool.Count - 1);
                                newState.Copy(state);
                            }
                            else
                            {
                                newState = state.Clone();
                            }

                            if (newState.Build(i, blueprint))
                                stack.Push(newState);
                        }
                    }

                    pool.Add(state);
                }

                Console.WriteLine($"Blueprint {index + 1} has {highestGeodeCount} after {iteration} iterations");
                Interlocked.Add(ref qualityLevel, (index + 1) * highestGeodeCount);
            });

            Console.WriteLine($"These blueprints have quality level {qualityLevel}");
        }
    }
}
