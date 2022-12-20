using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;

public class SandMover : MonoBehaviour
{
    private int _minX, _minY, _maxX, _maxY;
    private HashSet<Tuple<int, int>> _occupancy = new HashSet<Tuple<int, int>>();
    private GameObject _fallingSand;

    public Input Input;
    public GameObject SandPrefab;
    public bool IsGroundInfinite;
    public bool IsRunning;

    [Range(0f, 0.1f)]
    public float Delay = 0.025f;

    // Start is called before the first frame update
    void Start()
    {
        IEnumerable<Tuple<int, int>> blocks = Input?.GetBlocks();
        _occupancy.AddRange(blocks);

        _minX = blocks.Min(x => x.Item1);
        _maxX = blocks.Max(x => x.Item1);
        _minY = blocks.Min(x => x.Item2);
        _maxY = blocks.Max(x => x.Item2);
        float sizeX = _maxX - _minX;
        float sizeY = _maxY;
        float halfSizeX = sizeX * 0.5f;
        float centerX = halfSizeX + _minX;
        float centerY = _maxY * 0.5f;

        BoxCollider collider = gameObject.AddComponent<BoxCollider>();
        collider.center = new Vector3(centerX, -centerY, 0);
        collider.size = new Vector3(sizeX + 1f, sizeY + 1f, 1f);
    }

    public void StartSimulation()
    {
        StartCoroutine(LetTheSandFall());
    }

    public void StartContinuousSimulation()
    {
        IsRunning = true;
        StartCoroutine(LetTheSandFallContinuous());
    }

    public void RunForResult()
    {
        IEnumerable<Tuple<int, int>> blocks = Input?.GetBlocks();
        var occupancy = new HashSet<Tuple<int, int>>();
        occupancy.AddRange(blocks);

        bool fallsOut = false;
        int droppedSand = 0;
        while (!fallsOut)
        {
            droppedSand++;
            int x = 500;
            int y = 0;

            while (Move(occupancy, ref x, ref y))
            {
                if (IsOutOfBounds(x, y))
                {
                    droppedSand -= 1;
                    fallsOut = true;
                    break;
                }
            }

            if (x == 500 && y == 0)
            {
                break;
            }
        }

        Debug.Log("Sand fallen down: " + (droppedSand));
    }

    IEnumerator LetTheSandFall()
    {
        bool fallsOut = false;
        int droppedSand = 0;
        while (!fallsOut)
        {
            droppedSand += 1;
            int x = 500;
            int y = 0;
            if (_fallingSand == null)
            {
                _fallingSand = Instantiate(SandPrefab);
                _fallingSand.transform.localPosition = new Vector3(x, y, 0);
            }

            while (Move(_fallingSand, ref x, ref y))
            {
                if (IsOutOfBounds(x, y))
                {
                    droppedSand -= 1; 
                    Destroy(_fallingSand);
                    _fallingSand = null;
                    fallsOut = true;
                    break;
                }

                yield return new WaitForSeconds(Delay);
            }
            
            _fallingSand = null;

            if (x == 500 && y == 0)
            {
                break;
            }
        }

        Debug.Log("Sand fallen down: " + (droppedSand));
    }

    IEnumerator LetTheSandFallContinuous()
    {
        IEnumerable<Tuple<int, int>> blocks = Input?.GetBlocks();
        var occupancy = new HashSet<Tuple<int, int>>();
        occupancy.AddRange(blocks);

        var fallingSand = new List<Sand>();
        while (IsRunning)
        {
            var go = Instantiate(SandPrefab);
            go.transform.localPosition = new Vector3(500, 0, 0);
            fallingSand.Add(new Sand() { x = 500, y = 0, GO = go });
            bool movedAny = false;

            for (int i = 0; i < fallingSand.Count; ++i)
            {
                Sand sand = fallingSand[i];
                if (CanMoveDown(occupancy, sand.x, sand.y))
                {
                    sand.y += 1;
                    sand.Move();
                    movedAny = true;
                }
                else if (CanMoveDownLeft(occupancy, sand.x, sand.y))
                {
                    sand.x -= 1;
                    sand.y += 1;
                    sand.Move();
                    movedAny = true;
                }
                else if (CanMoveDownRight(occupancy, sand.x, sand.y))
                {
                    sand.x += 1;
                    sand.y += 1;
                    sand.Move();
                    movedAny = true;
                }
                else
                {
                    // Stop, move a next one.
                    occupancy.Add(new Tuple<int, int>(sand.x, sand.y));
                    fallingSand.RemoveAt(i);
                    i--;
                }

                if (IsOutOfBounds(sand.x, sand.y))
                {
                    Destroy(sand.GO);
                }
            }

            yield return new WaitForSeconds(Delay);

            if (!movedAny)
            {
                IsRunning = false;
            }
        }
    }

    private bool Move(GameObject gameObject, ref int x, ref int y)
    {
        if (CanMoveDown(_occupancy, x, y))
        {
            y += 1;
            gameObject.transform.localPosition = new Vector3(x, -y, 0);
            return true;
        }
        else if (CanMoveDownLeft(_occupancy, x, y))
        {
            x -= 1;
            y += 1;
            gameObject.transform.localPosition = new Vector3(x, -y, 0);
            return true;

        }
        else if (CanMoveDownRight(_occupancy, x, y))
        {
            x += 1;
            y += 1;
            gameObject.transform.localPosition = new Vector3(x, -y, 0);
            return true;
        }
        else
        {
            // Stop, move a next one.
            _occupancy.Add(new Tuple<int, int>(x, y));
            return false;
        }
    }

    private bool Move(HashSet<Tuple<int, int>> occupancy, ref int x, ref int y)
    {
        if (CanMoveDown(occupancy, x, y))
        {
            y += 1;
            return true;
        }
        else if (CanMoveDownLeft(occupancy, x, y))
        {
            x -= 1;
            y += 1;
            return true;

        }
        else if (CanMoveDownRight(occupancy, x, y))
        {
            x += 1;
            y += 1;
            return true;
        }
        else
        {
            // Stop, move a next one.
            occupancy.Add(new Tuple<int, int>(x, y));
            return false;
        }
    }

    private bool IsOutOfBounds(int x, int y)
    {
        if (IsGroundInfinite)
            return false;
        else
            return x < _minX || x > _maxX || y < 0 || y > _maxY;
    }

    private bool CanMoveDown(HashSet<Tuple<int, int>> occupancy, int x, int y)
    {
        if (IsGroundInfinite)
        {
            return !occupancy.Contains(new Tuple<int, int>(x, y + 1)) && y < _maxY + 1;
        }

        return !occupancy.Contains(new Tuple<int, int>(x, y + 1));
    }

    private bool CanMoveDownLeft(HashSet<Tuple<int, int>> occupancy, int x, int y)
    {
        if (IsGroundInfinite)
        {
            return !occupancy.Contains(new Tuple<int, int>(x - 1, y + 1)) && y < _maxY + 1;
        }

        return !occupancy.Contains(new Tuple<int, int>(x - 1, y + 1));
    }

    private bool CanMoveDownRight(HashSet<Tuple<int, int>> occupancy, int x, int y)
    {
        if (IsGroundInfinite)
        {
            return !occupancy.Contains(new Tuple<int, int>(x + 1, y + 1)) && y < _maxY + 1;
        }

        return !occupancy.Contains(new Tuple<int, int>(x + 1, y + 1));
    }

    private class Sand
    {
        public int x;
        public int y;
        public GameObject GO;

        public void Move()
        {
            GO.transform.localPosition = new Vector3(x, -y, 0);
        }
    }
}
