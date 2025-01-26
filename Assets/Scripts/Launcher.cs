using UnityEngine;

public class Launcher : MonoBehaviour
{
    [SerializeField] private GameObject forceIndicator;
    [SerializeField] private GameObject forceIndicatorBody;
    [SerializeField] private GameObject forceIndicatorHead;

    [SerializeField] private float rotationLimit = 70f;
    
    private float _forceIndicatorHeadZeroOffset = 0.6f;
    private float _forceIndicatorHeadFullOffset = 1.5f;

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
        forceIndicatorBody.transform.localScale = new Vector3(1, force, 1);

        forceIndicatorHead.transform.localPosition = new Vector3(forceIndicatorHead.transform.localPosition.x,
            CalculateForceIndicatorOffset(force), forceIndicatorHead.transform.localPosition.x);
    }

    private float CalculateForceIndicatorOffset(float force)
    {
        return _forceIndicatorHeadZeroOffset + force * (_forceIndicatorHeadFullOffset - _forceIndicatorHeadZeroOffset);
    }

    private float CalculateRotation(Vector2 obj)
    {
        var rotation = Mathf.Atan2(obj.x, -obj.y) * Mathf.Rad2Deg;
        var clampedRotation = Mathf.Clamp(rotation, -rotationLimit, rotationLimit);
        return clampedRotation;
    }
}
