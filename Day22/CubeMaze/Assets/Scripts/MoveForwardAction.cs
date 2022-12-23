internal class MoveForwardAction : MoveAction
{
    private int _step = 0;
    private readonly int _MaxSteps;

    internal MoveForwardAction(int steps)
    {
        _MaxSteps = steps;
    }

    internal override bool Move(Player player)
    {
        if (_step + 1 < _MaxSteps)
        {
            _step++;
            if (!player.Move())
            {
                // Player cannot be moved in that direction
                _step = _MaxSteps;
                return true;
            }

            return false;
        }

        if (_step + 1 ==  _MaxSteps)
        {
            _step++;
            player.Move();
        }

        return true;
    }

    internal override void Reset()
    {
        _step = 0;
    }
}
