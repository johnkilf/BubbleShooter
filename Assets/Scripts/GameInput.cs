using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameInput : MonoBehaviour
{
    [SerializeField] private float distanceToDragForMaximumSpeed = 8f;

    [SerializeField] private float offset = 0.5f;
    [SerializeField] private RectTransform disallowedArea;

    private InputSystem_Actions _inputSystemActions;

    private bool _isPressed;
    private Vector2 _start;
    private Vector2 _currentPos;

    public static Action<Vector2> ActiveDelta;
    public static Action<Vector2> ReleasedDelta;
    public static Action ChangeProjectileType;
    protected void Awake()
    {
        _inputSystemActions = new InputSystem_Actions();
        _inputSystemActions.Player.Enable();
        _inputSystemActions.Player.Press.Enable();

        _inputSystemActions.Player.Press.started += HandlePressStarted;
        _inputSystemActions.Player.Press.canceled += HandlePressCanceled;
        _inputSystemActions.Player.Position.performed += HandlePos;
        _inputSystemActions.Player.ChangeType.performed += HandleProjectileTypeChange;
    }

    private void OnDisable()
    {
        _inputSystemActions.Player.Disable();
        _inputSystemActions.Player.Press.Disable();
        _inputSystemActions.Dispose();
    }

    private float ScaleDragVector(Vector2 delta)
    {
        return Mathf.Min(delta.magnitude / distanceToDragForMaximumSpeed, distanceToDragForMaximumSpeed) / distanceToDragForMaximumSpeed;
    }

    private void HandlePos(InputAction.CallbackContext obj)
    {
        _currentPos = obj.ReadValue<Vector2>();

        if (_isPressed)
        {
            var delta = Camera.main.ScreenToWorldPoint(_currentPos) - Camera.main.ScreenToWorldPoint(_start);
            Debug.Log("Original delta: " + delta);
            ActiveDelta?.Invoke(delta);
        }
    }

    private void HandlePressStarted(InputAction.CallbackContext obj)
    {
        if (IsWithinDisallowedArea(_currentPos))
        {
            Debug.Log("Disallowed click");
            return;
        }

        _start = _currentPos;
        _isPressed = true;
    }

    private void HandlePressCanceled(InputAction.CallbackContext obj)
    {
        if (!_isPressed)
        {
            return;
        }

        Debug.Log("Press cancelled");
        Vector2 dragVector = Camera.main.ScreenToWorldPoint(_start) - Camera.main.ScreenToWorldPoint(_currentPos);
        ReleasedDelta?.Invoke(dragVector);
        _isPressed = false;
    }

    private void HandleProjectileTypeChange(InputAction.CallbackContext obj)
    {
        Debug.Log("Change projectile type");
        ChangeProjectileType?.Invoke();

    }

    private bool IsWithinDisallowedArea(Vector2 screenPosition)
    {
        RectTransformUtility.ScreenPointToLocalPointInRectangle(
            disallowedArea,
            screenPosition,
            null, // You can specify a camera if required
            out Vector2 localPoint
        );

        return disallowedArea.rect.Contains(localPoint);
    }

}
