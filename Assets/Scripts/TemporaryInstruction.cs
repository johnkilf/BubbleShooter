using System.Collections;
using TMPro;
using UnityEngine;

public class TemporaryInstruction : MonoBehaviour
{
    [SerializeField] private float secondsToWait = 1.5f;
    [SerializeField] private float fadeDuration = 1f;
    
    [SerializeField] private TextMeshProUGUI textMeshPro;
    void Start()
    {
        StartCoroutine(WaitAndDestroy());
    }

    private IEnumerator WaitAndDestroy()
    {
        yield return new WaitForSeconds(secondsToWait);
        
        Color originalColor = Color.white;
        float elapsedTime = 0f;

        while (elapsedTime < fadeDuration)
        {
            elapsedTime += Time.deltaTime;
            float alpha = Mathf.Lerp(1f, 0f, elapsedTime / fadeDuration);
            textMeshPro.color = new Color(originalColor.r, originalColor.g, originalColor.b, alpha);
            yield return null;
        }

        textMeshPro.color = new Color(originalColor.r, originalColor.g, originalColor.b, 0f);
    
        Destroy(gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
