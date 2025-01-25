using UnityEngine;

public class Bomb : MonoBehaviour
{
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
        bubble.ApplyMovement(this);
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
}
