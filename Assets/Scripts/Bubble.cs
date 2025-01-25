using UnityEngine;

public class Bubble : MonoBehaviour
{
    public float force_multiplier = 20;
    Rigidbody2D rb;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Explode()
    {
        Debug.Log("Bubble exploded");
        Destroy(gameObject);
    }

    public void ApplyMovement(Bomb bomb)
    {
        Debug.Log("Applying movement to bubble");
        // Move 
        Vector2 direction = transform.position - bomb.transform.position;
        float distance = direction.magnitude;
        direction.Normalize();
        rb.AddForce(direction * force_multiplier / distance, ForceMode2D.Impulse);
    }
}
