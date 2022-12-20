using System;
using UnityEngine;

public class FallingSandRenderer : MonoBehaviour
{
    public Input Input;
    public GameObject RockPrefab;
    public GameObject SandSourcePrefab;

    // Start is called before the first frame update
    void Start()
    {
        foreach (var block in Input?.GetBlocks())
        {
            DrawBlock(block, RockPrefab);
        }

        AddSandSource();
    }

    private void DrawBlock(Tuple<int, int> block, GameObject prefab)
    {
        GameObject go = Instantiate(prefab, transform, false);
        go.transform.localPosition = new Vector3(block.Item1, -block.Item2, 0);
    }

    private void AddSandSource()
    {
        GameObject go = Instantiate(SandSourcePrefab, transform, false);
        go.transform.localPosition = new Vector3(500, 0, 0);
    }
}
