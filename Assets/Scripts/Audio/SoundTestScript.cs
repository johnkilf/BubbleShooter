using UnityEngine;

public class SoundTestScript : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonUp(0))
            AudioManager.audioManagerRef.PlaySound("bubble burst");
    }
}
