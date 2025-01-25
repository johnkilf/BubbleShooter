using UnityEngine;

public class Launcher : MonoBehaviour
{
    [SerializeField] private GameObject forceIndicator;
    [SerializeField] private GameObject forceIndicatorVisual;

    [SerializeField] private float rotationLimit = 70f;

    public void Start()
    {
        GameInput.Instance.ActiveDelta += HandleActiveDelta;
        GameInput.Instance.ReleasedDelta += HandleReleasedDelta;
    }

    private void HandleReleasedDelta(Vector2 obj)
    {
        // TODO Launch ball
        Debug.Log("Launch ball");
        forceIndicator.gameObject.SetActive(false);
        GetComponent<BubbleGun>().LaunchBubble(obj);
    }

    private void HandleActiveDelta(Vector2 obj)
    {
        forceIndicator.gameObject.SetActive(true);
        var rotation = CalculateRotation(obj);
        forceIndicator.transform.rotation = Quaternion.Euler(0, 0, rotation);

        var force = obj.magnitude;
        forceIndicatorVisual.transform.localScale = new Vector3(1, force, 1);
    }

    private float CalculateRotation(Vector2 obj)
    {
        var rotation = Mathf.Atan2(obj.x, -obj.y) * Mathf.Rad2Deg;
        var clampedRotation = Mathf.Clamp(rotation, -rotationLimit, rotationLimit);
        return clampedRotation;
    }
}
