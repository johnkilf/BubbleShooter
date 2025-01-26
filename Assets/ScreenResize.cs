using UnityEngine;

public class ScreenResize : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        float targetAspect = 9.0f / 16.0f;
        float windowAspect = (float)Screen.width / Screen.height; // Current screen aspect ratio
        float orthoSize = Camera.main.orthographicSize; // Default camera size for your reference resolution
        Camera camera = Camera.main;

        if (windowAspect < targetAspect)
        {
            // Screen is narrower than the target aspect ratio
            // Adjust the orthographic size to fit the width
            camera.orthographicSize = orthoSize * (targetAspect / windowAspect);

            // Move the camera up to stick the content to the bottom
            float extraHeight = camera.orthographicSize - orthoSize;
            camera.transform.position += new Vector3(0, extraHeight, 0);
        }
        else
        {
            // Screen is as wide or wider than the target aspect ratio
            camera.orthographicSize = orthoSize;
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
}
