using UnityEngine;

public class SoundTestScript : MonoBehaviour
{
    public int soundIndex = 0;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonUp(0))
        {
            if(soundIndex < AudioManager.audioManagerRef.sounds.Length)
            {
                AudioManager.audioManagerRef.PlaySound(AudioManager.audioManagerRef.sounds[soundIndex].name);
                soundIndex++;
            }
            //AudioManager.audioManagerRef.PlaySound("bubble burst");

        }
    }
}
