using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class ExplosionImplosion : MonoBehaviour
{
    Material material;

    InputSystem_Actions inputActions;

    //[SerializeField] Transform debugImpactPoint;

    static readonly int Progress = Shader.PropertyToID("_Progress");
    // unique seed for each bubble and creature


    [SerializeField] AnimationCurve animationCurve;
    [SerializeField] float animationDuration = 0.5f;


    [SerializeField] GameObject vfxPrefab;

    // pass in a position and a radius
    // then coroutine sets the progress based on curve


    bool impactAnimationIsRunning;
    Coroutine impactAnimationCoroutine;
    
    static readonly int ImpactMaster = Shader.PropertyToID("_ImpactMaster");
    static readonly int RandomSeed = Shader.PropertyToID("_RandomSeed");

    void Start()
    {
        inputActions = new InputSystem_Actions();
        inputActions.Enable();
        inputActions.Player.Press.Enable();
        inputActions.Player.Press.performed += DebugImpactWithMouse;


        //      float randomSeed = UnityEngine.Random.value;
//        material.SetFloat(RandomSeed, randomSeed);
    }

    public bool isDebugging = false;
    public float debugRadius = 1f;
    static readonly int MaxRadius = Shader.PropertyToID("_MaxRadius");

    void DebugImpactWithMouse(InputAction.CallbackContext obj)
    {
        if (!isDebugging)
        {
            return;
        }
        Vector2 mousePosition = inputActions.Player.Position.ReadValue<Vector2>();

        //obj.ReadValue<Vector2>();
        Vector2 worldPosition = Camera.main.ScreenToWorldPoint(mousePosition);
        StartAnimation(worldPosition, debugRadius);
    }


    public void StartAnimation(Vector2 positionWorld, float radius)
    {
        StartCoroutine(ImpactAnimation(positionWorld, radius));
    }


    IEnumerator ImpactAnimation(Vector2 position, float radius = 0f)
    {
        impactAnimationIsRunning = true;

        GameObject newVfx = Instantiate(vfxPrefab, position, Quaternion.identity);

        Renderer render = newVfx.GetComponent<Renderer>();
        
        material = Instantiate(render.material);
        render.material = material;

        if (radius > 0f)
        {
            render.material.SetFloat(MaxRadius, radius);
        }

        
        float time = 0;

        while (time < animationDuration)
        {
            time += Time.deltaTime;
            float t = time / animationDuration;

            float curveAdjustedT = Mathf.Clamp01(animationCurve.Evaluate(t));

            render.material.SetFloat(Progress, curveAdjustedT);
            Debug.Log(curveAdjustedT);

            yield return null;
        }

        Destroy(newVfx);
    }
}