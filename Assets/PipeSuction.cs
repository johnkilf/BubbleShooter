using UnityEngine;

public class PipeSuction : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Bubble"))
        {
            Debug.Log("Pipe sucked the bubble");
            Rigidbody2D bubble_rb = collision.gameObject.GetComponent<Rigidbody2D>();
            ApplySuction(bubble_rb);
        }
    }

    public void ApplySuction(Rigidbody2D rb)
    {
        Debug.Log("Applying suction to bubble");
        Vector2 direction = transform.position - rb.transform.position;
        float distance = direction.magnitude;
        direction.Normalize();
        rb.AddForce(direction * 20 / distance, ForceMode2D.Impulse);

        // Destroy after 1 second
        Destroy(rb.gameObject, 0.3f);
    }
}
