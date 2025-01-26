using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameInput : MonoBehaviour
{
    [SerializeField] private RectTransform disallowedArea;

    private InputSystem_Actions _inputSystemActions;

    private bool _isPressed;
    private Vector2 _start;

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

    private Vector2 NormalizedDelta(Vector2 position1, Vector2 position2)
    {
        // Normalize screen positions to [0, 1]
        Vector2 normalizedPosition1 = new Vector2(position1.x / Screen.width, position1.y / Screen.height);
        Vector2 normalizedPosition2 = new Vector2(position2.x / Screen.width, position2.y / Screen.height);
        Debug.Log("Normalized position 1: " + normalizedPosition1);
        Debug.Log("Normalized position 2: " + normalizedPosition2);

        // Calculate delta
        Vector2 delta = normalizedPosition1 - normalizedPosition2;
        return delta;
    }

    private void HandlePos(InputAction.CallbackContext obj)
    {
        var position = obj.ReadValue<Vector2>();

        if (_isPressed)
        {
            // var delta = Camera.main.ScreenToWorldPoint(position) - Camera.main.ScreenToWorldPoint(_start);
            var delta = NormalizedDelta(position, _start);
            Debug.Log("Original delta: " + delta);
            ActiveDelta?.Invoke(delta);
        }
    }

    private void HandlePressStarted(InputAction.CallbackContext obj)
    {
        var position = _inputSystemActions.Player.Position.ReadValue<Vector2>();

        if (IsWithinDisallowedArea(position))
        {
            Debug.Log("Disallowed click");
            return;
        }

        _start = position;
        _isPressed = true;
    }

    private void HandlePressCanceled(InputAction.CallbackContext obj)
    {
        if (!_isPressed)
        {
            return;
        }

        var position = _inputSystemActions.Player.Position.ReadValue<Vector2>();
        Debug.Log("Press cancelled");
        // Vector2 dragVector = Camera.main.ScreenToWorldPoint(_start) - Camera.main.ScreenToWorldPoint(position);
        Vector2 dragVector = NormalizedDelta(_start, position);
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
            null,
            out Vector2 localPoint
        );

        return disallowedArea.rect.Contains(localPoint);
    }

}
