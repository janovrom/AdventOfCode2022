namespace Day19
{
    internal class State
    {
        private List<int> _robotsMade = new List<int>() { 0 };
        private int[] _state = new int[9] { 1, 0, 0, 0, 0, 0, 0, 0, 0 };
        private int _currentTarget = -1;

        private bool _hasClayRobot = false;
        private bool _hasObsidianRobot = false;

        private readonly int _MaxTime;

        public int Minute => _state[8];
        public int Geodes => _state[7];

        public Tuple<int, int, int, int> Robots => new Tuple<int, int, int, int>(_state[0], _state[1], _state[2], _state[3]);

        public State(int maxTime)
        {
            _MaxTime = maxTime;
        }

        public bool IsInTimeLimit()
        {
            return Minute < _MaxTime;
        }

        public int GetMaxRobot()
        {
            if (_hasObsidianRobot)
                return 3;

            if (_hasClayRobot)
                return 2;

            return 1;
        }

        public bool HasBuildTarget()
        {
            return _currentTarget != -1;
        }

        public bool Build(int robot, Blueprint blueprint)
        {
            _currentTarget = robot;

            switch (robot)
            {
                case 1:
                    _hasClayRobot = true;
                    break;
                case 2:
                    _hasObsidianRobot = true;
                    break;
            }

            return RunToBuildTarget(blueprint);
        }

        public State Clone()
        {
            var newState = new State(_MaxTime);
            newState.Copy(this);
            return newState;
        }

        public void Copy(State other)
        {
            _currentTarget = other._currentTarget;
            _hasClayRobot = other._hasClayRobot;
            _hasObsidianRobot = other._hasObsidianRobot;
            Array.Copy(other._state, _state, 9);
        }

        private bool RunToBuildTarget(Blueprint blueprint)
        {
            int[] costs = blueprint[_currentTarget];
            while (!(costs[0] <= _state[4] && costs[1] <= _state[5] && costs[2] <= _state[6]))
            {
                _state[4] += _state[0];
                _state[5] += _state[1];
                _state[6] += _state[2];
                _state[7] += _state[3];
                _state[8] += 1;
            }

            if (Minute >= _MaxTime)
                return false;

            _state[8] += 1;

            _state[4] += _state[0];
            _state[5] += _state[1];
            _state[6] += _state[2];
            _state[7] += _state[3];

            _state[_currentTarget] += 1;
            _state[4] -= costs[0];
            _state[5] -= costs[1];
            _state[6] -= costs[2];

            _currentTarget = -1;

            return true;
        }
    }
}
