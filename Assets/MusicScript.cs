using UnityEngine;

public class MusicScript : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        // PLAY SOUND: main theme
        AudioManager.audioManagerRef.PlaySound("main_theme", 0.4f);
    }
}
