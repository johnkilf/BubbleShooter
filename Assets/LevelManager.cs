using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.IO;

public class LevelManager : MonoBehaviour
{
    public Transform levelsPanel;
    public LevelButtonScript levelButton;

    void Start()
    {
        PopulateLevels();
    }

    private void PopulateLevels()
    {
        // Fetch the list of levels in the game
        for (int i = 0; i < SceneManager.sceneCountInBuildSettings; i++)
        {
            string sceneName = Path.GetFileNameWithoutExtension(SceneUtility.GetScenePathByBuildIndex(i));

            if (sceneName.ToLower().Contains("level"))
            {
                // Create buttons from the Prefab and add them to the Panel
                if (levelButton != null && levelsPanel != null)
                {
                    // Create an instance of the button
                    LevelButtonScript newLevelButton = Instantiate(levelButton);
                    newLevelButton.transform.SetParent(levelsPanel, false);
                    //Set the level name
                    newLevelButton.SetLevel(sceneName);
                    newLevelButton.levelManager = this;
                }
                else
                {
                    if(levelButton == null)
                        Debug.LogWarning("Level button prefab not set in the Level Manager!");
                    if (levelsPanel == null)
                        Debug.LogWarning("Levels Panel prefab not set in the Level Manager!");
                }
            }
        }
    }

    public void PlayGame()
    {
        SceneManager.LoadSceneAsync("SampleScene");
    }

    public void PlayLevel(string levelName)
    {
        SceneManager.LoadSceneAsync(levelName);
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
