using UnityEngine;

public class Bubble : MonoBehaviour
{
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
}
