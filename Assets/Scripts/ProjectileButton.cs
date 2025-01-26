using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ProjectileButton : MonoBehaviour, IPointerClickHandler
{

    [SerializeField] private ProjectileType projectileType;
    [SerializeField] private bool isActive = true;
    [SerializeField] private Image projectileSprite;

    private void Start()
    {
        if (!isActive)
        {
            projectileSprite.color = Color.grey;   
        }
    }

    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.Log(projectileType + " clicked");
        if (isActive)
        {
            AudioManager.audioManagerRef.PlaySound("click", 0.4f);
            HudEvents.ProjectileClicked?.Invoke(projectileType);
        }
    }
}
