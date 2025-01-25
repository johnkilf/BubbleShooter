using UnityEngine;
using System.Collections.Generic;


public class BubbleGun : MonoBehaviour
{

    public GameObject explosivePrefab;
    public GameObject implosivePrefab;
    public GameObject basicProjectilePrefab;

    public SpriteRenderer spriteRenderer;

    ProjectileType currentType = ProjectileType.Explosive;

    List<ProjectileType> availableTypes = new List<ProjectileType> { ProjectileType.Explosive, ProjectileType.Implosive, ProjectileType.BasicProjectile };

    // min force per projectile type
    public float minForceExplosive = 10f;
    public float minForceImplosive = 10f;
    public float minForceBasicProjectile = 10f;

    // max force per projectile type
    public float maxForceExplosive = 40f;
    public float maxForceImplosive = 40f;
    public float maxForceBasicProjectile = 40f;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        SetGunType(currentType);
        GameInput.ChangeProjectileType += ChangeGunType;
        HudEvents.ProjectileClicked += SetGunType;
    }

    // Update is called once per frame
    void Update()
    {
    }

    public void LaunchBubble(Vector2 velocity)
    {
        float minForce = 0;
        float maxForce = 0;
        float magnitude = velocity.magnitude;
        if (currentType == ProjectileType.Explosive)
        {
            minForce = minForceExplosive;
            maxForce = maxForceExplosive;
        }
        else if (currentType == ProjectileType.Implosive)
        {
            minForce = minForceImplosive;
            maxForce = maxForceImplosive;
        }
        else if (currentType == ProjectileType.BasicProjectile)
        {
            minForce = minForceBasicProjectile;
            maxForce = maxForceBasicProjectile;
        }
        Debug.Log("Magnitude: " + magnitude);
        float force = Mathf.Lerp(minForce, maxForce, magnitude);

        // Instantiate projectile
        GameObject projectile;
        if (currentType == ProjectileType.Explosive)
        {
            projectile = Instantiate(explosivePrefab, transform.position, Quaternion.identity);
        }
        else if (currentType == ProjectileType.BasicProjectile)
        {
            projectile = Instantiate(basicProjectilePrefab, transform.position, Quaternion.identity);
        }
        else if (currentType == ProjectileType.Implosive)
        {
            projectile = Instantiate(implosivePrefab, transform.position, Quaternion.identity);
        }
        else
        {
            Debug.LogError("Unknown projectile type");
            return;
        }

        // Get direction and apply force
        Vector2 direction = velocity;
        direction.Normalize();

        Debug.Log("Force: " + force);
        Debug.Log("Direction: " + direction);

        Rigidbody2D rb = projectile.GetComponent<Rigidbody2D>();
        rb.AddForce(direction * force, ForceMode2D.Impulse);
    }

    private void ChangeGunType()
    {
        int currentIndex = availableTypes.IndexOf(currentType);
        currentIndex = (currentIndex + 1) % availableTypes.Count;
        SetGunType(availableTypes[currentIndex]);
    }

    private void SetGunType(ProjectileType type)
    {
        currentType = type;
        // Change gun sprite
        if (currentType == ProjectileType.Explosive)
        {
            // Set sprite to explosive 
            spriteRenderer.color = Color.red;
        }
        else if (currentType == ProjectileType.BasicProjectile)
        {
            // Set sprite to basic
            spriteRenderer.color = Color.green;
        }
        else if (currentType == ProjectileType.Implosive)
        {
            // Set sprite to implosive
            spriteRenderer.color = Color.blue;
        }
        else
        {
            Debug.LogError("Unknown projectile type");
        }
    }
}
