using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class BubbleVFX : MonoBehaviour
{
    Material bubbleMaterial;
    Material creatureMaterial;

    InputSystem_Actions inputActions;

    [SerializeField] Renderer bubbleRenderer;
    [SerializeField] Renderer creatureRenderer;


    [SerializeField] Transform debugImpactPoint;

    static readonly int ImpactPosition = Shader.PropertyToID("_ImpactPosition");
    // unique seed for each bubble and creature


    [SerializeField] AnimationCurve impactAnimationCurve;
    [SerializeField] float impactAnimationDuration = 0.5f;

    // debug object for deformation
    // click to trigger a deform
    // increase and decrease the radius
    // or just a main slider for the strength, polish later


    bool impactAnimationIsRunning;
    Coroutine impactAnimationCoroutine;
    static readonly int ImpactMaster = Shader.PropertyToID("_ImpactMaster");
    static readonly int RandomSeed = Shader.PropertyToID("_RandomSeed");
    static readonly int ImpactScaleStrength = Shader.PropertyToID("_ImpactScaleStrength");

    void Start()
    {

        bubbleMaterial = Instantiate(bubbleRenderer.material);
        bubbleRenderer.material = bubbleMaterial;

        creatureMaterial = Instantiate(creatureRenderer.material);
        creatureRenderer.material = creatureMaterial;

        float randomSeed = UnityEngine.Random.value;
        bubbleMaterial.SetFloat(RandomSeed, randomSeed);
        creatureMaterial.SetFloat(RandomSeed, randomSeed);
        //inputActions.Player.Position.performed += StoreMousePosition;
    }



    public void StartImpactAnimation(Vector2 impactPositionWorld)
    {
        Vector2 impactPositionLocal = transform.InverseTransformPoint(impactPositionWorld);
        if (impactAnimationIsRunning)
        {
            StopCoroutine(impactAnimationCoroutine);
        }
        impactAnimationCoroutine = StartCoroutine(ImpactAnimation(impactPositionLocal));
    }


    IEnumerator ImpactAnimation(Vector2 impactPosition, float impactStrength = 1)
    {
        impactAnimationIsRunning = true;

        bubbleMaterial.SetVector(ImpactPosition, impactPosition);
        bubbleMaterial.SetFloat(ImpactScaleStrength, impactStrength);
        creatureMaterial.SetVector(ImpactPosition, impactPosition);

        float time = 0;

        while (time < impactAnimationDuration)
        {
            time += Time.deltaTime;
            float t = time / impactAnimationDuration;

            float curveAdjustedT = Mathf.Clamp01(impactAnimationCurve.Evaluate(t));

            bubbleMaterial.SetFloat(ImpactMaster, curveAdjustedT);
            creatureMaterial.SetFloat(ImpactMaster, curveAdjustedT);

            yield return null;
        }
    }
}