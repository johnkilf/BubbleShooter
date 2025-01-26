using System;
using UnityEngine;

public class Launcher : MonoBehaviour
{
    [SerializeField] private GameObject forceIndicator;
    [SerializeField] private GameObject forceIndicatorVisual;

    [SerializeField] private float rotationLimit = 70f;

    [SerializeField] private float offset = 1f;
    [SerializeField] private float distanceToDragForMaximumSpeed = 8f;

    [SerializeField] private float minForce = 0.01f;

    public void Start()
    {
        GameInput.ActiveDelta += HandleActiveDelta;
        GameInput.ReleasedDelta += HandleReleasedDelta;
    }

    private void OnDisable()
    {
        GameInput.ActiveDelta -= HandleActiveDelta;
        GameInput.ReleasedDelta -= HandleReleasedDelta;
    }

    private float ScaleDragVector(Vector2 delta)
    {
        return Mathf.Clamp(delta.magnitude - offset, 0, distanceToDragForMaximumSpeed) / distanceToDragForMaximumSpeed;
    }

    private void HandleReleasedDelta(Vector2 obj)
    {
        Debug.Log("Launch ball");
        obj = obj.normalized * ScaleDragVector(obj);
        // Hide force indicator
        forceIndicator.gameObject.SetActive(false);
        // Launch ball
        if (obj.magnitude > minForce)
        {
            GetComponent<BubbleGun>().LaunchBubble(obj);
        }
    }

    private void HandleActiveDelta(Vector2 obj)
    {
        forceIndicator.gameObject.SetActive(true);
        var rotation = CalculateRotation(obj);
        forceIndicator.transform.rotation = Quaternion.Euler(0, 0, rotation);

        var force = ScaleDragVector(obj);
        Debug.Log("Indicator force: " + force);

        forceIndicatorVisual.transform.localScale = new Vector3(1, force, 1);
    }

    private float CalculateRotation(Vector2 obj)
    {
        var rotation = Mathf.Atan2(obj.x, -obj.y) * Mathf.Rad2Deg;
        var clampedRotation = Mathf.Clamp(rotation, -rotationLimit, rotationLimit);
        return clampedRotation;
    }
}
