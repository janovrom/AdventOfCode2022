namespace Day19
{
    internal class Blueprint
    {

        public int[] CostsOre = new int[3];
        public int[] CostsClay = new int[3];
        public int[] CostsObsidian = new int[3];
        public int[] CostsGeode = new int[3];

        public int[] this[int key]
        {
            get
            {
                return key switch
                {
                    0 => CostsOre,
                    1 => CostsClay,
                    2 => CostsObsidian,
                    3 => CostsGeode,
                };
            }
        }

        public static List<Blueprint> Load(string path)
        {
            var fileData = File.ReadAllLines(path);

            List<Blueprint> blueprints = new();

            foreach (string line in fileData)
            {
                string[] costs = line.Split(":");

                Blueprint blueprint = new();
                blueprints.Add(blueprint);
                for (int i = 0; i < 4; ++i)
                {
                    string cost = costs[i];
                    string[] individualCosts = cost.Split(",");
                    for (int j = 0; j < 3; j++)
                    {
                        blueprint[i][j] = int.Parse(individualCosts[j]);
                    }
                }
            }

            return blueprints;
        }
    }
}
