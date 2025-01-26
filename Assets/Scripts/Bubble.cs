using System;
using UnityEngine;
using System.Collections;

public class Bubble : MonoBehaviour
{

    [SerializeField] SpriteRenderer bubbleSpriteRenderer;
    [SerializeField] SpriteRenderer creatureSpriteRenderer;
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

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Finish"))
        {
            Debug.Log("Bubble reached the finish line");
            Escape();
        }
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
        bubbleSpriteRenderer.enabled = false;
        creatureSpriteRenderer.enabled = false;

        if (winLoseScript != null)
        {
            // winLoseScript.Lose();
            StartCoroutine(DelayLoseMenu());
        }
    }

    IEnumerator DelayLoseMenu()
    {
        Debug.Log("Waiting for 2 seconds");
        yield return new WaitForSeconds(2f);
        winLoseScript.Lose();
        Destroy(gameObject);
    }

    public void Escape()
    {
        if (winLoseScript != null)
            winLoseScript.Win();

        Debug.Log("Bubble escaped!");
        // Destroy(gameObject);

    }
}
