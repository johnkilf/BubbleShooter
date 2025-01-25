using UnityEngine;
using System.Collections.Generic;


public class BubbleGun : MonoBehaviour
{

    public GameObject explosivePrefab;
    public GameObject implosivePrefab;
    public GameObject basicProjectilePrefab;

    ProjectileType currentType = ProjectileType.Explosive;

    List<ProjectileType> availableTypes = new List<ProjectileType> { ProjectileType.Explosive, ProjectileType.Implosive, ProjectileType.BasicProjectile };

    private float chargeStartTime = 0f;
    private bool isCharging = false;

    // min force per projectile type
    public float minForceExplosive = 10f;
    public float minForceImplosive = 10f;
    public float minForceBasicProjectile = 10f;

    // max force per projectile type
    public float maxForceExplosive = 40f;
    public float maxForceImplosive = 40f;
    public float maxForceBasicProjectile = 40f;

    public float maxChargeTime = 2f;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        SetGunType(currentType);
    }

    // Update is called once per frame
    void Update()
    {
        // Start charging when mouse button is pressed
        if (Input.GetMouseButtonDown(0))
        {
            isCharging = true;
            chargeStartTime = Time.time;
        }

        // Release projectile when mouse button is released
        if (Input.GetMouseButtonUp(0) && isCharging)
        {
            isCharging = false;
            float chargeTime = Mathf.Min(Time.time - chargeStartTime, maxChargeTime);
            float chargePercent = chargeTime / maxChargeTime;
            float minForce = 0;
            float maxForce = 0;
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
            float force = Mathf.Lerp(minForce, maxForce, chargePercent);

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
            Vector2 direction = Camera.main.ScreenToWorldPoint(Input.mousePosition) - transform.position;
            direction.Normalize();

            Rigidbody2D rb = projectile.GetComponent<Rigidbody2D>();
            rb.AddForce(direction * force, ForceMode2D.Impulse);
        }

        // Change projectile type with mouse wheel
        if (Input.mouseScrollDelta.y > 0)
        {
            int currentIndex = availableTypes.IndexOf(currentType);
            currentIndex = (currentIndex + 1) % availableTypes.Count;
            SetGunType(availableTypes[currentIndex]);
        }
        else if (Input.mouseScrollDelta.y < 0)
        {
            int currentIndex = availableTypes.IndexOf(currentType);
            currentIndex = (currentIndex - 1 + availableTypes.Count) % availableTypes.Count;
            SetGunType(availableTypes[currentIndex]);
        }

    }

    private void SetGunType(ProjectileType type)
    {
        currentType = type;
        // Change gun sprite
        if (currentType == ProjectileType.Explosive)
        {
            // Set sprite to explosive 
            GetComponent<SpriteRenderer>().color = Color.red;
        }
        else if (currentType == ProjectileType.BasicProjectile)
        {
            // Set sprite to basic
            GetComponent<SpriteRenderer>().color = Color.green;
        }
        else if (currentType == ProjectileType.Implosive)
        {
            // Set sprite to implosive
            GetComponent<SpriteRenderer>().color = Color.blue;
        }
        else
        {
            Debug.LogError("Unknown projectile type");
        }
    }
}
