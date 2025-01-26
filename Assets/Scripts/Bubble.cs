using System;
using UnityEngine;

public class Bubble : MonoBehaviour
{
    public WinLoseScript winLoseScript;

    Rigidbody2D rb;


    public static event Action<Vector2> OnBubbleExploded = delegate { };

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Finish"))
        {
            Debug.Log("Bubble reached the finish line");
            Escape();
        }
        if (collision.gameObject.CompareTag("Spikes"))
        {
            Debug.Log("Bubble collided with spikes");
            Explode();
        }
        if (collision.gameObject.CompareTag("Projectile"))
        {
            float impactStrength = collision.relativeVelocity.magnitude;
            Vector2 impactPoint = collision.GetContact(0).point;
            GetComponent<BubbleVFX>().StartImpactAnimation(impactPoint);
            AudioManager.audioManagerRef.PlaySound("bubble_touching");
        }
    }

    public void Explode()
    {
        OnBubbleExploded?.Invoke(transform.position);
        
        Debug.Log("Bubble exploded");
        Destroy(gameObject);

        if (winLoseScript != null)
            winLoseScript.Lose();
    }

    public void Escape()
    {
        if (winLoseScript != null)
            winLoseScript.Win();

        Debug.Log("Bubble escaped!");
        Destroy(gameObject);

    }
}
