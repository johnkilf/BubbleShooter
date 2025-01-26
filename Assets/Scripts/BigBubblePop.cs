using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;


public class BigBubblePop : MonoBehaviour
{
    Material material;

    InputSystem_Actions inputActions;

    static readonly int Progress = Shader.PropertyToID("_Progress");


    [SerializeField] AnimationCurve animationCurve;
    [SerializeField] float animationDuration = 0.5f;

    [SerializeField] GameObject bigBubblePrefab;
    [SerializeField] GameObject creatureWithGravityPrefab;


    void OnEnable()
    {
        Bubble.OnBubbleExploded += StartAnimation;
    }
    
    void OnDisable()
    {
        Bubble.OnBubbleExploded -= StartAnimation;
    }


    void Start()
    {
        inputActions = new InputSystem_Actions();
        inputActions.Enable();
        inputActions.Player.Press.Enable();
        inputActions.Player.Press.performed += DebugImpactWithMouse;
    }

    public bool isDebugging = false;
    
    
    void DebugImpactWithMouse(InputAction.CallbackContext obj)
    {
        if (!isDebugging)
        {
            return;
        }
    
        Vector2 mousePosition = inputActions.Player.Position.ReadValue<Vector2>();
    
        //obj.ReadValue<Vector2>();
        Vector2 worldPosition = Camera.main.ScreenToWorldPoint(mousePosition);
        StartAnimation(worldPosition);
    }


    public void StartAnimation(Vector2 positionWorld)
    {
        StartCoroutine(ImpactAnimation(positionWorld));
    }



    IEnumerator ImpactAnimation(Vector2 position)
    {

        GameObject creature = Instantiate(creatureWithGravityPrefab, position, Quaternion.identity);
        GameObject bubble = Instantiate(bigBubblePrefab, position, Quaternion.identity);

        Renderer bubbleRenderer = bubble.GetComponent<Renderer>();

        material = Instantiate(bubbleRenderer.material);
        bubbleRenderer.material = material;
       
        float time = 0;

        while (time < animationDuration)
        {
            time += Time.deltaTime;
            float t = time / animationDuration;

            float curveAdjustedT = Mathf.Clamp01(animationCurve.Evaluate(t));

            bubbleRenderer.material.SetFloat(Progress, curveAdjustedT);
            Debug.Log(curveAdjustedT);

            yield return null;
        }

        Destroy(bubble);

        yield return new WaitForSeconds(1f);
        Destroy(creature);

    }
}