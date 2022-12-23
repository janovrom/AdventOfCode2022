using System;
using UnityEngine;

public class Face : MonoBehaviour
{
    public FaceSettings Settings;
    public GameObject WallPrefab;
    public GameObject FloorPrefab;
    public int StartRow;
    public int StartColumn;

    public void Load()
    {
        Clear();
        string[] lines = Settings.MazeData.text.Split(Environment.NewLine);
        for (int col = 0; col < Settings.SquareSize; col++)
        {
            for (int row = 0; row < Settings.SquareSize; row++)
            {
                int c = StartColumn + col;
                int r = StartRow + row;
                bool isFloor = lines[r][c] == '.';
                Vector3 position = col * Vector3.right + row * Vector3.up;
                GameObject floor = GameObject.Instantiate(FloorPrefab, transform, false);
                floor.transform.localPosition = position;

                if (!isFloor)
                {
                    GameObject wall = GameObject.Instantiate(WallPrefab, transform, false);
                    wall.transform.localPosition = position + Vector3.forward;
                }
            }
        }
    }

    public void Clear()
    {
        for (int i = transform.childCount - 1; i >= 0; i--)
        {
#if UNITY_EDITOR
            DestroyImmediate(transform.GetChild(i).gameObject);
#else
            Destroy(transform.GetChild(i).gameObject);
#endif
        }
    }
}
