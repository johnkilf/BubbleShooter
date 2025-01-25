using UnityEngine;

using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class AutoSizeCollider : MonoBehaviour
{
    void Start()
    {
        BoxCollider2D collider = GetComponent<BoxCollider2D>();
        SpriteRenderer spriteRenderer = GetComponent<SpriteRenderer>();

        if (spriteRenderer != null)
        {
            collider.size = spriteRenderer.sprite.bounds.size;
            collider.offset = spriteRenderer.sprite.bounds.center;
        }
    }
}
