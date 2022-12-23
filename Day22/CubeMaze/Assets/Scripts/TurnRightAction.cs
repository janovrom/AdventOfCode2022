internal class TurnRightAction : MoveAction
{
    internal override bool Move(Player player)
    {
        player.TurnRight();
        return true;
    }
}
