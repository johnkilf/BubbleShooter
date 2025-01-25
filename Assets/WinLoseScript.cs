using UnityEngine;

public class WinLoseScript : MonoBehaviour
{
    public Transform pauseButton;
    public Transform pauseMenu;
    public Transform winMenu;
    public Transform loseMenu;

    public void Win()
    {
        if (winMenu != null)
            winMenu.gameObject.SetActive(true);

        if (pauseMenu != null)
            winMenu.gameObject.SetActive(false);

        if (pauseButton != null)
            pauseButton.gameObject.SetActive(false);

        if (loseMenu != null)
            loseMenu.gameObject.SetActive(false);

        // Stop music
        AudioManager.audioManagerRef.StopSound("main_theme");
        // PLAY SOUND: win
        AudioManager.audioManagerRef.PlaySound("win");
    }

    public void Lose()
    {
        if (loseMenu != null)
            loseMenu.gameObject.SetActive(true);

        if (pauseMenu != null)
            winMenu.gameObject.SetActive(false);

        if (pauseButton != null)
            pauseButton.gameObject.SetActive(false);

        if (winMenu != null)
            winMenu.gameObject.SetActive(false);

        // Stop music
        AudioManager.audioManagerRef.StopSound("main_theme");
        // PLAY SOUND: lose
        AudioManager.audioManagerRef.PlaySound("lose");
    }

}
