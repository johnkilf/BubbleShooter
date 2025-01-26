using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelManager : MonoBehaviour
{
    public Transform levelsPanel;
    public LevelButtonScript levelButton;

    private List<string> _levels = new();

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
                _levels.Add(sceneName);
            }
        }
    }

    public void PlayLevel(string levelName)
    {
        SceneManager.LoadSceneAsync(levelName);
    }

    public void PlayGame()
    {
        if (_levels.Count > 0)
            PlayLevel(_levels[0]);
        else
            Debug.Log("There aren't any levels to play! Add Scenes with the word 'Level' in them to get them automatically added.");
    }

    public void PlayNextLevel()
    {
        string currentScene = SceneManager.GetActiveScene().name;

        int sceneIndex = 0;

        foreach(string s in _levels)
        {
            sceneIndex++;
            if (s == currentScene)
                break;
        }

        // If we beat the last level go to Main Menu
        if (sceneIndex < _levels.Count)
            PlayLevel(_levels[sceneIndex]);
        else
            QuitToMainMenu();

    }

    public void ReloadLevel()
    {
        PlayLevel(SceneManager.GetActiveScene().name);
    }

    public void QuitToMainMenu()
    {
        try
        {
            PlayLevel("MainMenu");
        }
        catch (Exception e)
        {
            Debug.Log("Scene MainMenu doesn't exist or can't be loaded!");
        }
    }

    public void QuitGame()
    {
        Application.Quit();
    }
}
