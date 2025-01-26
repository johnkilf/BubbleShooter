using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameInput : MonoBehaviour

{
    [SerializeField] private float distanceToDragForMaximumSpeed = 8f;
    [SerializeField] private RectTransform disallowedArea;

    private InputSystem_Actions _inputSystemActions;

    private bool _isPressed;
    private Vector2 _start;
    private float _startTimestamp;
    private Vector2 _currentPos;

    public static Action<Vector2> ActiveDelta;
    public static Action<Vector2> ReleasedDelta;

    public static Action CancelledDelta;

    public static Action ChangeProjectileType;

    public float minPressDuration = 0.1f;

    private Vector2 launcherPosition;

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

    private void HandlePos(InputAction.CallbackContext obj)
    {
        _currentPos = obj.ReadValue<Vector2>();

        if (_isPressed)
        {
            Vector2 cursorWorldPosition = Camera.main.ScreenToWorldPoint(_currentPos);
            ActiveDelta?.Invoke(cursorWorldPosition);
        }
    }

    private void HandlePressStarted(InputAction.CallbackContext obj)
    {
        _isPressed = true;
        _start = _currentPos;
        _startTimestamp = Time.time;
        ActiveDelta?.Invoke(Camera.main.ScreenToWorldPoint(_start));
    }

    private void HandlePressCanceled(InputAction.CallbackContext obj)
    {
        if (!_isPressed)
        {
            return;
        }

        Debug.Log("Press cancelled");
        if (Time.time - _startTimestamp > minPressDuration)
        {
            Vector2 cursorWorldPosition = Camera.main.ScreenToWorldPoint(_currentPos);
            ReleasedDelta?.Invoke(cursorWorldPosition);
        }
        else
        {
            CancelledDelta?.Invoke();
        }

        _isPressed = false;
    }

    private void HandleProjectileTypeChange(InputAction.CallbackContext obj)
    {
        Debug.Log("Change projectile type");
        ChangeProjectileType?.Invoke();

    }


}
