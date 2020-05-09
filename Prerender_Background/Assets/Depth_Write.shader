
Shader "Custom/DepthWrite" {
Properties {
		_DepthTex ("Depth Texture", 2D) = "white" {}
		_RenderedTex ("Rendered Image", 2D) = "white" {}
		//_Near("Near clipping plane", Float) = 1
		//_Far("Far clipping plane", Float) = 40
	}	
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertOut {
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD0;
			};

			vertOut vert(appdata_base v) {
				vertOut o;
				//Transforms a point from object space to the camera’s clip space in homogeneous coordinates. 
				//This is the equivalent of mul(UNITY_MATRIX_MVP, float4(pos, 1.0)), and should be used in its place.
				o.pos = UnityObjectToClipPos (v.vertex); 
				o.uv = v.texcoord.xy;
				return o;
			}

			uniform sampler2D _DepthTex;
			uniform sampler2D _RenderedTex;
			uniform float4x4 _Perspective;	// The perspective projection of the Unity camera
			uniform float _Near;
			uniform float _Far;
			//for 3D photo
			
			uniform fixed2 _Scale;
			uniform fixed2 displacement;
			

			struct fout {
                    half4 color : COLOR;
                    float depth : DEPTH;
                };    
			
			
			fout frag( vertOut i ) {      
			
					/*
					//original shader
			        fout fo;

					// Read the depth from the depth texture
					float4 imageDepth4 = tex2D(_DepthTex, i.uv);
					float imageDepth = -imageDepth4.x;

					// Go back to clip space by computing the depth as the depth of the pixel from the camera
					float4 temp = float4(0, 0, (imageDepth * (_Far - _Near) - _Near) , 1);
					float4 clipSpace = mul(_Perspective, temp);
					
					// Carry out the perspective division and map into screen space (DirectX)					
					// We only care about z
					//透视除法将Clip Space顶点的4个分量都除以w分量，就从Clip Space转换到了NDC了。
					// the depth coordinate will differ based on whether you are in an OpenGL-like platform or a Direct3D-like one.
					//Direct3D-like: The clip space depth goes from 0.0 at the near plane to +1.0 at the far plane. This applies to Direct3D, Metal and consoles.
					//OpenGL-like: The clip space depth goes from –1.0 at the near plane to +1.0 at the far plane. This applies to OpenGL and OpenGL ES.

					clipSpace.z /= clipSpace.w;
					clipSpace.z = 0.5*(1.0-clipSpace.z);
					float z = clipSpace.z;

					// Write out the pre-computed color and the correct depth.
					fo.color = tex2D(_RenderedTex, i.uv);
					fo.depth = z;
                    return fo;
					*/
					
			
                    fout pshift;

					// Read the depth from the depth texture
					float4 imageDepth3D = tex2D(_DepthTex, i.uv);
					//float imageDepth = -(1 - imageDepth3D).x;
					//1 - imageDepth3D:flip black&white, near&far.
					//.r:alpha. r,g,b,a. depth map is grey.use red channel. alpha is 1.
					//-1* : camera Z
					//translate : (imageDepth3D-1).x
					float imageDepth;
					imageDepth = (imageDepth3D-1.0).r;
					

					//Calc displace move pixels--dzf
					//imageDepth3D-0.5: shift pixels at middle grey area.
					displacement = _Scale * (imageDepth3D-0.5) *0.005;
					//for Z
					float4 newimageDepth3D = tex2D(_DepthTex, i.uv - displacement);
					imageDepth = (newimageDepth3D - 1.0).r;


					// Go back to clip space by computing the depth as the depth of the pixel from the camera
					
					//value scale: remap value range
					//It remaps value (that has an expected range of low1 to high1) into a target range of low2 to high2).
					//low2 + (value - low1) * (high2 - low2) / (high1 - low1)
					//old range 0-1, new range _Near - _Far.
					
					//float4 temp = float4(0, 0, (_Near + imageDepth * (_Far - _Near)) , 1);

					//old method:
					float4 temp = float4(0, 0, (imageDepth * (_Far - _Near) - _Near) , 1);
					float4 clipSpace = mul(_Perspective, temp);
					
					// Carry out the perspective division and map into screen space (DirectX)					
					// We only care about z
					clipSpace.z /= clipSpace.w;
					clipSpace.z = 0.5*(1.0 - clipSpace.z);
					float z = clipSpace.z;

					// Write out the pre-computed color and the correct depth.
					
					pshift.color = tex2D(_RenderedTex, i.uv - displacement);
					pshift.depth = z;
					
                    return pshift;
					
                }
			
			

			

			ENDCG
		}
	}
}