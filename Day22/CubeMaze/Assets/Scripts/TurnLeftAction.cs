internal class TurnLeftAction : MoveAction
{
    internal override bool Move(Player player)
    {
        player.TurnLeft();
        return true;
    }
}
