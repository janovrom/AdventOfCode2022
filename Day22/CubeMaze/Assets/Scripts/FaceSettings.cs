using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "Maze/FaceSettings", order = 1)]
public class FaceSettings : ScriptableObject
{
    public TextAsset MazeData;
    public int SquareSize;
}
