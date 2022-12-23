using UnityEngine;

public class Player : MonoBehaviour
{
    public LayerMask MovementMask;
    public LayerMask FloorMask;

    public bool Move()
    {
        var moveRay = new Ray(transform.position + transform.up, transform.forward);
        Vector3 newPosition = transform.localPosition + transform.forward;

        var faceRay = new Ray(transform.position + transform.up + transform.forward, -transform.up);
        if (!Physics.Raycast(faceRay, 1f, FloorMask))
        {
            // We would be in air, try check if there is a wall in the new place
            if (Physics.Raycast(faceRay, 1f, MovementMask))
            {
                // There is a wall, we can't move there
                return false;
            }

            // We can move there, but it's not strictly a movement, but rotation
            // Compute using cross and look rotation to make sure that up is always face normal.
            transform.localRotation = Quaternion.LookRotation(faceRay.direction, Vector3.Cross(faceRay.direction, transform.right));
            return true;
        }
        else
        {
            if (!Physics.Raycast(moveRay, 1f, MovementMask))
            {
                // The way is free!
                transform.localPosition = newPosition;
                return true;
            }
        }

        return false;
    }

    public void TurnLeft()
    {
        transform.localRotation = Quaternion.LookRotation(-transform.right, transform.up);
    }

    public void TurnRight()
    {
        transform.localRotation = Quaternion.LookRotation(transform.right, transform.up);
    }

    private void OnDrawGizmos()
    {
        Debug.DrawRay(transform.position + transform.up, transform.forward, Color.blue);
        Debug.DrawRay(transform.position + transform.up, transform.right, Color.red);
    }
}
