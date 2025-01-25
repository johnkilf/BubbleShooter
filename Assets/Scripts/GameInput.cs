using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameInput : Singleton<GameInput>
{
    [SerializeField] private float distanceToDragForMaximumSpeed = 8f;

    private InputSystem_Actions _inputSystemActions;

    private bool _isPressed;
    private Vector2 _start;
    private Vector2 _currentPos;

    public Action<Vector2> ActiveDelta;
    public Action<Vector2> ReleasedDelta;
    public Action ChangeProjectileType;
    protected override void Awake()
    {
        base.Awake();
        _inputSystemActions = new InputSystem_Actions();
        _inputSystemActions.Player.Enable();
        _inputSystemActions.Player.Press.Enable();

        _inputSystemActions.Player.Press.started += HandlePressStarted;
        _inputSystemActions.Player.Press.canceled += HandlePressCanceled;
        _inputSystemActions.Player.Position.performed += HandlePos;
        _inputSystemActions.Player.ChangeType.performed += HandleProjectileTypeChange;
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
            var delta = _currentPos - _start;
            var portionOfFullDrag = ScaleDragVector(delta);
            ActiveDelta?.Invoke(delta.normalized * portionOfFullDrag);
        }
    }

    private void HandlePressStarted(InputAction.CallbackContext obj)
    {
        Debug.Log("Press started");
        _start = _currentPos;
        _isPressed = true;
    }

    private void HandlePressCanceled(InputAction.CallbackContext obj)
    {
        Debug.Log("Press cancelled");
        Vector2 dragVector = _start - _currentPos;
        var portionOfFullDrag = ScaleDragVector(dragVector);
        ReleasedDelta?.Invoke(dragVector.normalized * portionOfFullDrag);
        _isPressed = false;
    }

    private void HandleProjectileTypeChange(InputAction.CallbackContext obj)
    {
        Debug.Log("Change projectile type");
        ChangeProjectileType?.Invoke();

    }
}
