using UnityEngine;

[ExecuteInEditMode]
public class Cube : MonoBehaviour
{
    void OnEnable()
    {
        foreach (var face in GetComponentsInChildren<Face>())
        {
            face.Load();
        }
    }

    void OnDisable()
    {
        foreach (var face in GetComponentsInChildren<Face>())
        {
            face.Clear();
        }
    }
}
