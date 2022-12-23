using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(Navigation))]
public class NavigationEditor : Editor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        Navigation navigation = (Navigation)target;

        if (GUILayout.Button("Move"))
        {
            navigation.Move();
        }

        if (GUILayout.Button("Reset"))
        {
            navigation.ResetNavigation();
        }

        if (navigation.IsRunningToEnd)
        {
            if (GUILayout.Button("Stop"))
            {
                navigation.StopSimulation();
            }
        }
        else
        {
            if (GUILayout.Button("Run to end"))
            {
                navigation.RunToEnd();
            }

            if (GUILayout.Button("Run for result"))
            {
                navigation.RunForResult();
            }
        }

        GUILayout.Label($"Progress {string.Format("{0:P2}", navigation.Progress)}");
    }
}
