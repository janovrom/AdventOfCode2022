using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

public class Input : MonoBehaviour
{
    public TextAsset InputText;

    public IEnumerable<Tuple<int, int>> GetBlocks()
    {
        foreach (var positions in GetLines())
        {
            for (int i = 1; i < positions.Length; i++)
            {
                var p0 = positions[i - 1];
                var p1 = positions[i];
                foreach (var block in GetLineBlocks(p0, p1))
                {
                    yield return block;
                }
            }
        }
    }

    private IEnumerable<Tuple<int, int>> GetLineBlocks(Tuple<int, int> start, Tuple<int, int> end)
    {
        int count = Math.Max(Math.Abs(end.Item1 - start.Item1), Math.Abs(end.Item2 - start.Item2));
        int dx = Math.Sign(end.Item1 - start.Item1);
        int dy = Math.Sign(end.Item2 - start.Item2);

        int cx = start.Item1;
        int cy = start.Item2;

        for (int i = 0; i <= count; i++)
        {
            yield return new Tuple<int, int>(cx, cy);

            cx += dx;
            cy += dy;
        }
    }

    private IEnumerable<Tuple<int, int>[]> GetLines()
    {
        if (string.IsNullOrEmpty(InputText.text))
        {
            yield break;
        }

        string[] lines = InputText.text.Split("\r\n");
        foreach (string line in lines)
        {
            yield return GetPositions(line).ToArray();
        }
    }

    private IEnumerable<Tuple<int, int>> GetPositions(string line)
    {
        foreach (string segment in line.Split(" -> "))
        {
            string[] positions = segment.Split(",");
            yield return new Tuple<int, int>(int.Parse(positions[0]), int.Parse(positions[1]));
        }
    }

}
