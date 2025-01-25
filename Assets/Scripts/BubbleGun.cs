using UnityEngine;

public class BubbleGun : MonoBehaviour
{

    public GameObject bombPrefab;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // If mouse button is pressed
        if (Input.GetMouseButtonDown(0))
        {
            Debug.Log("Mouse button was pressed");
            Debug.Log("Instantiating bomb");
            // Instantiate bomb
            GameObject bomb = Instantiate(bombPrefab, transform.position, Quaternion.identity);

            // Get direction (from gun to mouse position)
            Vector2 direction = Camera.main.ScreenToWorldPoint(Input.mousePosition) - transform.position;
            direction.Normalize();
            
            // Apply force
            Rigidbody2D rb = bomb.GetComponent<Rigidbody2D>();
            rb.AddForce(direction * 20, ForceMode2D.Impulse);
        }
        
    }
}
