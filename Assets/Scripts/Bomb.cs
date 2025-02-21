using UnityEngine;

public class Bomb : MonoBehaviour
{
    public float force_multiplier = 20;
    Bubble bubble;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        bubble = GameObject.Find("Bubble").GetComponent<Bubble>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Explode();
        }
    }

    public void Explode()
    {
        Debug.Log("Bomb exploded");
        // bubble.ApplyMovement(this);
        Rigidbody2D bubble_rb = bubble.GetComponent<Rigidbody2D>();
        ApplyMovement(bubble_rb);
        Destroy(gameObject);
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Bubble"))
        {
            Debug.Log("Bomb collided with bubble");
            Explode();
        }
    }

    public void ApplyMovement(Rigidbody2D rb)
    {
        Debug.Log("Applying movement to bubble");
        Vector2 direction = rb.transform.position - transform.position;
        float distance = direction.magnitude;
        direction.Normalize();
        rb.AddForce(direction * force_multiplier / distance, ForceMode2D.Impulse);
    }
}
