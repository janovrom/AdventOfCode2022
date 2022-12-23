using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEngine;

public class Navigation : MonoBehaviour
{
    private List<MoveAction> _movements;
    private int _currentMovement = 0;
    private Vector3 _originalPosition;
    private Quaternion _originalRotation;
    private int _actionsCount = 0;
    private int _currentAction = 0;

    public TextAsset NavigationData;
    public Player Player;

    [Range(0f, 0.25f)]
    public float Delay;

    public float Progress => _actionsCount == 0 ? 0 : _currentAction / _actionsCount;

    public bool IsRunningToEnd { get; private set; } = false;

    public void RunToEnd()
    {
        StartCoroutine("ContinuousMovement");
    }

    public void StopSimulation()
    {
        IsRunningToEnd = false;
        StopCoroutine("ContinuousMovement");
    }

    public void RunForResult()
    {
        IsRunningToEnd = true;

        while (_currentMovement < _movements.Count && IsRunningToEnd)
        {
            Move();
        }

        IsRunningToEnd = false;
    }

    public void ResetNavigation()
    {
        Player.transform.localRotation = _originalRotation;
        Player.transform.localPosition = _originalPosition;
        _currentMovement = 0;
        _currentAction = 0;

        foreach (MoveAction action in _movements)
        {
            action.Reset();
        }
    }

    public void Move()
    {
        if (_movements.Count == _currentMovement)
            return;

        _currentAction++;
        // Move next item.
        if (_movements[_currentMovement].Move(Player))
        {
            _currentMovement += 1;
        }
    }

    void Start()
    {
        _originalPosition = Player.transform.localPosition;
        _originalRotation = Player.transform.localRotation;
        _actionsCount = 0;

        IEnumerable<int> movements = NavigationData.text
            .Replace("R", " ")
            .Replace("L", " ")
            .Split(' ')
            .Select(x => int.Parse(x));

        MatchCollection matches = Regex.Matches(NavigationData.text, "[RL]");
        var matchEnumerator = matches.GetEnumerator();

        _movements = new List<MoveAction>();
        foreach (int movement in movements)
        {
            _movements.Add(new MoveForwardAction(movement));
            _actionsCount += movement;

            if (matchEnumerator.MoveNext())
            {
                _actionsCount += 1;
                if (((Match)matchEnumerator.Current).Value == "R")
                {
                    _movements.Add(new TurnRightAction());
                }
                else
                {
                    _movements.Add(new TurnLeftAction());
                }
            }
        }
    }

    private void Update()
    {
        if (Input.GetKeyUp(KeyCode.Space))
            Move();
    }

    private IEnumerator ContinuousMovement()
    {
        IsRunningToEnd = true;
        
        while (_currentMovement < _movements.Count && IsRunningToEnd)
        {
            Move();
            yield return new WaitForSeconds(Delay);
        }

        IsRunningToEnd = false;
    }

}
