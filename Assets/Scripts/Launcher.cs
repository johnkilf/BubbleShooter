using System;
using UnityEngine;

public class Launcher : MonoBehaviour
{
    [SerializeField] private GameObject forceIndicator;
    [SerializeField] private GameObject forceIndicatorVisual;

    [SerializeField] private float rotationLimit = 70f;
    public float maxDragDistance = 2f;
    public float deltaOffset = 2f;

    public float minDragDistance = 0.01f;

    public void Start()
    {
        GameInput.ActiveDelta += HandleActiveDelta;
        GameInput.ReleasedDelta += HandleReleasedDelta;
        GameInput.CancelledDelta += HandleCancelledDelta;
    }

    private void OnDisable()
    {
        GameInput.ActiveDelta -= HandleActiveDelta;
        GameInput.ReleasedDelta -= HandleReleasedDelta;
        GameInput.CancelledDelta -= HandleCancelledDelta;
    }

    private void HandleReleasedDelta(Vector2 cursorPosition)

    {
        Debug.Log("Launch ball");
        forceIndicator.gameObject.SetActive(false);

        Vector2 delta = CalculateDelta(cursorPosition);
        // Opposite direction
        delta = -delta;
        Debug.Log("Delta: " + delta);
        if (delta.magnitude < minDragDistance)
        {
            return;
        }
        GetComponent<BubbleGun>().LaunchBubble(delta);
    }

    private void HandleCancelledDelta()
    {
        forceIndicator.gameObject.SetActive(false);
    }

    private Vector2 CalculateDelta(Vector2 cursorPosition)
    {
        Vector2 forceIndicatorPosition = new Vector2(forceIndicator.transform.position.x, forceIndicator.transform.position.y);
        Vector2 delta = forceIndicatorPosition - cursorPosition;
        float newMagnitude = Mathf.Clamp(delta.magnitude - deltaOffset, 0, maxDragDistance) / maxDragDistance;
        delta = delta.normalized * newMagnitude;
        return delta;
    }

    private void HandleActiveDelta(Vector2 cursorPosition)
    {

        Vector2 delta = CalculateDelta(cursorPosition);
        forceIndicator.gameObject.SetActive(true);
        var rotation = CalculateRotation(delta);
        forceIndicator.transform.rotation = Quaternion.Euler(0, 0, rotation);

        var force = delta.magnitude;
        forceIndicatorVisual.transform.localScale = new Vector3(1, force, 1);
    }

    private float CalculateRotation(Vector2 obj)
    {
        var rotation = Mathf.Atan2(obj.x, -obj.y) * Mathf.Rad2Deg;
        var clampedRotation = Mathf.Clamp(rotation, -rotationLimit, rotationLimit);
        return clampedRotation;
    }
}
