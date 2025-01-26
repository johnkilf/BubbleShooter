using System;
using System.Collections;
using UnityEngine;

public class SplashScreen : MonoBehaviour
{
    [SerializeField] private LevelManager levelManager;
    [SerializeField] private float secondsToWait = 1.5f;

    private void Start()
    {
        StartCoroutine(LaunchGame());
    }

    private IEnumerator LaunchGame()
    {
        yield return new WaitForSeconds(secondsToWait);
        levelManager.QuitToMainMenu();
    }
}
