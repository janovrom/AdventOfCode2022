internal abstract class MoveAction
{
    internal abstract bool Move(Player player);

    internal virtual void Reset() { }
}
