using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class LevelButtonScript : MonoBehaviour
{
    public TMP_Text buttonText;
    public string levelName;
    public LevelManager levelManager;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        if (buttonText != null)
            buttonText.text = levelName;
    }

    public void SetLevel(string name)
    {
        levelName = name;
        if (buttonText != null)
            buttonText.text = name;
        else
            Debug.Log("Button Text instance missing in the Level Button prefab!");
    }

    public void LoadLevel()
    {
        AudioManager.audioManagerRef.PlaySound("click", 0.4f);
        if(levelManager != null && levelName != null)
            levelManager.PlayLevel(levelName);
    }
}
