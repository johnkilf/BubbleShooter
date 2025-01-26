using UnityEngine;
using UnityEngine.EventSystems;

public class ProjectileButton : MonoBehaviour, IPointerClickHandler
{

    [SerializeField] private ProjectileType projectileType;
    
    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log(projectileType + " clicked");
        HudEvents.ProjectileClicked?.Invoke(projectileType);
    }
}
