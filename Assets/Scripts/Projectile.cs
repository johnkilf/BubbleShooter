using UnityEngine;

public enum ProjectileType
{
    Explosive,
    Implosive,
    BasicProjectile
}

public enum DistanceEffect
{
    Linear,
    Quadratic,
    Exponential
}

public class Projectile : MonoBehaviour
{
    public float forceMultiplier = 20;
    public float maxForce = 10;
    public float maxEffectDistance = 0.5f;
    public float maxLifetime = 3;
    public ProjectileType type = ProjectileType.Explosive;
    public int maxCollisions = 3;
    public DistanceEffect distanceEffect = DistanceEffect.Quadratic;
    public bool explodeOnCollision = false;

    public ExplosionImplosion explosionManager;


    int collisionCount = 0;
    float creationTime;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        creationTime = Time.time;
        if (type == ProjectileType.Explosive)
        {
            // // If Explosion Manager is not found, instantiate it from the prefab
            // if (GameObject.Find("ExplosionManager") == null)
            // {
            //     GameObject explosionManagerPrefab = Resources.Load<GameObject>("Prefabs/ExplosionManager");
            //     if (explosionManagerPrefab != null)
            //     {
            //         GameObject explosionManager = Instantiate(explosionManagerPrefab);
            //         explosionManager.name = "ExplosionManager";
            //     }
            // }
            explosionManager = GameObject.Find("ExplosionManager").GetComponent<ExplosionImplosion>();
        }
        else if (type == ProjectileType.Implosive)
        {
            // // If Implosion Manager is not found, instantiate it from the prefab
            // if (GameObject.Find("ImplosionManager") == null)
            // {
            //     GameObject implosionManager = Instantiate(Resources.Load("ImplosionManager")) as GameObject;
            //     implosionManager.name = "ImplosionManager";
            // }
            explosionManager = GameObject.Find("ImplosionManager").GetComponent<ExplosionImplosion>();
        }
        else if (type == ProjectileType.BasicProjectile)
        {
            explosionManager = GameObject.Find("BaseProjectilePopManager").GetComponent<ExplosionImplosion>();
        }
    }

    // Update is called once per frame
    void Update()
    {
        // Destroy the projectile if it has been alive for too long
        if (Time.time - creationTime > maxLifetime)
        {
            Debug.Log("Projectile reached max lifetime");
            Explode();
        }
    }

    void OnDrawGizmos()
    {
        // Draw an effect radius around the bomb
        Gizmos.color = Color.red;
        if (type == ProjectileType.Implosive || type == ProjectileType.Explosive)
        {
            Gizmos.DrawWireSphere(transform.position, maxEffectDistance);
        }
    }

    public void Explode()
    {
        Debug.Log("Projectile exploded");
        // Find all Rigidbody2D objects in the scene and apply movement to them
        Rigidbody2D[] rbs = FindObjectsByType<Rigidbody2D>(FindObjectsSortMode.None);
        foreach (Rigidbody2D rb in rbs)
        {
            ApplyMovement(rb);
        }

        if (type == ProjectileType.Implosive || type == ProjectileType.Explosive)
        {
            explosionManager?.StartAnimation(transform.position, maxEffectDistance * 0.7f);
        }
        if (type == ProjectileType.BasicProjectile)
        {
            explosionManager?.StartAnimation(transform.position, 1f);
        }

        Destroy(gameObject);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        // We only want to apply force from the explosion, not from the collision with the bubble
        // That's why we have a separate OnTriggerEnter2D method so we can detect the collision with the bubble
        // earlier than the OnCollisionEnter2D method and destroy the projectile before it collides with the bubble
        // ignoring the collision forces.
        if (explodeOnCollision && collision.gameObject.CompareTag("Bubble"))
        {
            Debug.Log("Projectile collided with bubble");
            Explode();
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (type == ProjectileType.BasicProjectile && collision.gameObject.CompareTag("Bubble"))
        {
            Debug.Log("Basic projectile collided with bubble");
            Explode();
        }
        if (explodeOnCollision && collision.gameObject.CompareTag("Bubble"))
        {
            Debug.Log("Projectile collided with bubble");
            Explode();
        }
        if (collision.gameObject.CompareTag("Spikes"))
        {
            Debug.Log("Bubble collided with spikes");
            Explode();
        }
        collisionCount++;
        if (collisionCount >= maxCollisions)
        {
            Debug.Log("Projectile reached max collisions");
            Explode();
        }
    }

    public void ApplyMovement(Rigidbody2D rb)
    {
        Debug.Log("Applying movement to bubble");
        Vector2 direction;
        if (type == ProjectileType.Implosive)
        {
            direction = transform.position - rb.transform.position;
        }
        else if (type == ProjectileType.Explosive)
        {
            direction = rb.transform.position - transform.position;
        }
        else if (type == ProjectileType.BasicProjectile)
        {
            return;
        }
        else
        {
            throw new System.Exception("Invalid projectile type");
        }

        float distance = direction.magnitude;
        if (distance > maxEffectDistance)
        {
            Debug.Log("Bubble is out of range");
            return;
        }

        direction.Normalize();
        float force;
        if (distanceEffect == DistanceEffect.Linear)
        {
            force = forceMultiplier / distance;
        }
        else if (distanceEffect == DistanceEffect.Quadratic)
        {
            force = forceMultiplier / (distance * distance);
        }
        else if (distanceEffect == DistanceEffect.Exponential)
        {
            force = forceMultiplier / Mathf.Pow(distance, 2);
        }
        else
        {
            throw new System.Exception("Invalid distance effect");
        }

        // Cap force
        force = Mathf.Min(force, maxForce);

        Debug.Log("Force: " + force);
        rb.AddForce(direction * force, ForceMode2D.Impulse);
    }
}
