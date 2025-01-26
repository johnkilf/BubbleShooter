using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LevelManager : MonoBehaviour
{
    public Transform levelsPanel;
    public LevelButtonScript levelButton;

    private List<string> _levels = new();

    void Start()
    {
        var levelScenes = GetLevelScenes();
        _levels = levelScenes.Select(x => x.name).ToList();

        PopulateLevelSelectPanel(levelScenes);
    }

    private void PopulateLevelSelectPanel(List<(string name, int number)> levelScenes)
    {
        if (levelsPanel == null)
        {
            Debug.LogWarning("Levels Panel is not assigned in the Level Manager!");
            return;
        }

        // Configure the existing GridLayoutGroup for vertical layout
        var gridLayout = levelsPanel.GetComponent<GridLayoutGroup>();
        if (gridLayout != null)
        {
            gridLayout.constraint = GridLayoutGroup.Constraint.FixedColumnCount;
            gridLayout.constraintCount = 1; // Single column
            gridLayout.spacing = new Vector2(0, 10); // 10 units vertical spacing
            gridLayout.childAlignment = TextAnchor.UpperCenter;
        }
        else
        {
            Debug.LogWarning("No GridLayoutGroup found on LevelsPanel!");
        }

        // Create buttons
        if (levelButton != null && levelsPanel != null)
        {
            foreach (var level in levelScenes)
            {
                LevelButtonScript newLevelButton = Instantiate(levelButton, levelsPanel, false);
                newLevelButton.SetLevel(level.name);
                newLevelButton.levelManager = this;
            }
        }
        else
        {
            if (levelButton == null)
                Debug.LogWarning("Level button prefab not set in the Level Manager!");
            if (levelsPanel == null)
                Debug.LogWarning("Levels Panel prefab not set in the Level Manager!");
        }
    }

    private List<(string name, int number)> GetLevelScenes()
    {
        var levelScenes = new List<(string name, int number)>();

        // Fetch and parse level numbers
        for (int i = 0; i < SceneManager.sceneCountInBuildSettings; i++)
        {
            string sceneName = Path.GetFileNameWithoutExtension(SceneUtility.GetScenePathByBuildIndex(i));
            if (sceneName.ToLower().Contains("level"))
            {
                // Extract number from "Level1", "Level2", etc.
                if (int.TryParse(sceneName.Replace("Level", ""), out int levelNumber))
                {
                    levelScenes.Add((sceneName, levelNumber));
                }
            }
        }

        // Sort by level number
        levelScenes = levelScenes.OrderBy(x => x.number).ToList();
        
        return levelScenes;
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

        foreach (string s in _levels)
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
