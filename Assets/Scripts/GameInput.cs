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
        var position = obj.ReadValue<Vector2>();

        if (_isPressed)
        {
            var delta = position - _start;
            var portionOfFullDrag = ScaleDragVector(delta);
            ActiveDelta?.Invoke(delta.normalized * portionOfFullDrag);
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
        Vector2 dragVector = _start - position;
        var portionOfFullDrag = ScaleDragVector(dragVector);
        ReleasedDelta?.Invoke(dragVector.normalized * portionOfFullDrag);
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
