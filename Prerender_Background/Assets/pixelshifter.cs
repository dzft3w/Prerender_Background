using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pixelshifter : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //object controlling 3D parallax
        Shader.SetGlobalVector("_Scale", transform.position);
    }
}
