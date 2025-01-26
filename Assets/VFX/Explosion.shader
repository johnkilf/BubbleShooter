// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Explosion"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_tex("tex", 2D) = "white" {}
		[HDR]_CenterColor("CenterColor", Color) = (0,0,0,0)
		_CenterColorFadeStart("CenterColorFadeStart", Range( 0 , 1)) = 0
		_CenterColorFadeEnd("CenterColorFadeEnd", Range( 0 , 1)) = 1
		[HDR]_MidColor("MidColor", Color) = (0,0,0,0)
		_MidColorFadeStart("MidColorFadeStart", Range( 0 , 1)) = 0
		_MidColorFadeEnd("MidColorFadeEnd", Range( 0 , 1)) = 0
		[HDR]_OuterColor("OuterColor", Color) = (0,0,0,0)
		_TexRadialSpeed("TexRadialSpeed", Range( -2 , 2)) = 2
		_ValueMultiStartPosition("ValueMultiStartPosition", Range( 0 , 1)) = 0
		_ValueMultiStartFactor("ValueMultiStartFactor", Range( 0 , 5)) = 1
		_MaxRadius("MaxRadius", Range( 0 , 2)) = 0
		_ValueMultiEndPosition("ValueMultiEndPosition", Range( 0 , 1)) = 1
		_ValueMultiEndFactor("ValueMultiEndFactor", Range( 0 , 5)) = 0
		_ValueMulitPower("ValueMulitPower", Range( 0.01 , 30)) = 1
		_RingValueStart("RingValueStart", Range( 0 , 1)) = 0
		_RingValueMid("RingValueMid", Range( 0 , 1)) = 0.4645969
		_RingValueEnd("RingValueEnd", Range( 0 , 1)) = 0
		_Progress("Progress", Range( 0 , 1)) = 0
		_StartAlphaFade("StartAlphaFade", Range( 0 , 1)) = 0

		[HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "UniversalMaterialType"="Lit" "ShaderGraphShader"="true" }

		Cull Off

		HLSLINCLUDE
		#pragma target 2.0
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		ENDHLSL

		
		Pass
		{
			Name "Sprite Lit"
            Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_SCREENPOSITION
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITELIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			#if USE_SHAPE_LIGHT_TYPE_0
			SHAPE_LIGHT(0)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_1
			SHAPE_LIGHT(1)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_2
			SHAPE_LIGHT(2)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_3
			SHAPE_LIGHT(3)
			#endif

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/CombinedShapeLightShared.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			sampler2D _tex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float _Progress;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _RingValueMid;
			float _MidColorFadeEnd;
			float _RingValueEnd;
			float _TexRadialSpeed;
			float _ValueMulitPower;
			float _ValueMultiEndPosition;
			float _ValueMultiStartPosition;
			float _ValueMultiEndFactor;
			float _ValueMultiStartFactor;
			float _MaxRadius;
			float _RingValueStart;
			float _StartAlphaFade;
			CBUFFER_END


			struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float4 screenPosition : TEXCOORD2;
				float3 positionWS : TEXCOORD3;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float ProgressAdjusted165 = _Progress;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * ( ProgressAdjusted165 * _MaxRadius ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.screenPosition = vertexInput.positionNDC;
				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float4 positionCS = IN.positionCS;
				float3 positionWS = IN.positionWS;

				float2 temp_output_34_0_g1 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float lerpResult154 = lerp( _ValueMultiStartFactor , _ValueMultiEndFactor , pow( saturate( (0.0 + (Radius0115 - _ValueMultiStartPosition) * (1.0 - 0.0) / (_ValueMultiEndPosition - _ValueMultiStartPosition)) ) , _ValueMulitPower ));
				float mulTime136 = _TimeParameters.x * _TexRadialSpeed;
				float2 appendResult140 = (float2(mulTime136 , 0.0));
				float2 temp_output_34_0_g3 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g3 = temp_output_34_0_g3;
				float2 appendResult50_g3 = (float2(( 1.0 * ( length( temp_output_34_0_g3 ) * 2.0 ) ) , ( ( atan2( break39_g3.x , break39_g3.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 temp_output_141_0 = ( appendResult140 + appendResult50_g3 );
				float4 tex2DNode157 = tex2D( _tex, temp_output_141_0 );
				float MainTexValue120 = saturate( ( ( tex2DNode157.r + tex2DNode157.b + tex2DNode157.g ) / 3.0 ) );
				float temp_output_125_0 = (0.0 + (MainTexValue120 - _RingValueStart) * (1.0 - 0.0) / (_RingValueEnd - _RingValueStart));
				float Texture_Value_Adjusted128 = ( temp_output_125_0 <= _RingValueMid ? saturate( (0.0 + (temp_output_125_0 - 0.0) * (0.5 - 0.0) / (_RingValueMid - 0.0)) ) : saturate( (0.5 + (temp_output_125_0 - 0.0) * (1.0 - 0.5) / (_RingValueMid - 0.0)) ) );
				float temp_output_17_0_g2 = ( lerpResult154 * Texture_Value_Adjusted128 );
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 break168 = ( step( Radius0115 , 1.0 ) * ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) );
				float ProgressAdjusted165 = _Progress;
				float4 appendResult169 = (float4(break168.r , break168.g , break168.b , ( break168.a * saturate( (1.0 + (ProgressAdjusted165 - _StartAlphaFade) * (0.0 - 1.0) / (1.0 - _StartAlphaFade)) ) )));
				
				float4 Color = appendResult169;
				float4 Mask = float4(1,1,1,1);
				float3 Normal = float3( 0, 0, 1 );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture);
				#endif

				SurfaceData2D surfaceData;
				InitializeSurfaceData(Color.rgb, Color.a, Mask, surfaceData);
				InputData2D inputData;
				InitializeInputData(IN.texCoord0.xy, half2(IN.screenPosition.xy / IN.screenPosition.w), inputData);
				SETUP_DEBUG_DATA_2D(inputData, positionWS, positionCS);
				return CombinedShapeLightShared(surfaceData, inputData);

				Color *= IN.color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "Sprite Normal"
            Tags { "LightMode"="NormalsRendering" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ SKINNED_SPRITE

			#define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITENORMAL

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			sampler2D _tex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float _Progress;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _RingValueMid;
			float _MidColorFadeEnd;
			float _RingValueEnd;
			float _TexRadialSpeed;
			float _ValueMulitPower;
			float _ValueMultiEndPosition;
			float _ValueMultiStartPosition;
			float _ValueMultiEndFactor;
			float _ValueMultiStartFactor;
			float _MaxRadius;
			float _RingValueStart;
			float _StartAlphaFade;
			CBUFFER_END


			struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 normalWS : TEXCOORD2;
				float4 tangentWS : TEXCOORD3;
				float3 bitangentWS : TEXCOORD4;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float ProgressAdjusted165 = _Progress;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * ( ProgressAdjusted165 * _MaxRadius ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.positionCS = vertexInput.positionCS;

				float3 normalWS = TransformObjectToWorldNormal(v.normal);
				o.normalWS = -GetViewForwardDir();
				float4 tangentWS = float4( TransformObjectToWorldDir(v.tangent.xyz), v.tangent.w);
				o.tangentWS = normalize(tangentWS);
				half crossSign = (tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
				o.bitangentWS = crossSign * cross(normalWS, tangentWS.xyz) * tangentWS.w;
				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float2 temp_output_34_0_g1 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float lerpResult154 = lerp( _ValueMultiStartFactor , _ValueMultiEndFactor , pow( saturate( (0.0 + (Radius0115 - _ValueMultiStartPosition) * (1.0 - 0.0) / (_ValueMultiEndPosition - _ValueMultiStartPosition)) ) , _ValueMulitPower ));
				float mulTime136 = _TimeParameters.x * _TexRadialSpeed;
				float2 appendResult140 = (float2(mulTime136 , 0.0));
				float2 temp_output_34_0_g3 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g3 = temp_output_34_0_g3;
				float2 appendResult50_g3 = (float2(( 1.0 * ( length( temp_output_34_0_g3 ) * 2.0 ) ) , ( ( atan2( break39_g3.x , break39_g3.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 temp_output_141_0 = ( appendResult140 + appendResult50_g3 );
				float4 tex2DNode157 = tex2D( _tex, temp_output_141_0 );
				float MainTexValue120 = saturate( ( ( tex2DNode157.r + tex2DNode157.b + tex2DNode157.g ) / 3.0 ) );
				float temp_output_125_0 = (0.0 + (MainTexValue120 - _RingValueStart) * (1.0 - 0.0) / (_RingValueEnd - _RingValueStart));
				float Texture_Value_Adjusted128 = ( temp_output_125_0 <= _RingValueMid ? saturate( (0.0 + (temp_output_125_0 - 0.0) * (0.5 - 0.0) / (_RingValueMid - 0.0)) ) : saturate( (0.5 + (temp_output_125_0 - 0.0) * (1.0 - 0.5) / (_RingValueMid - 0.0)) ) );
				float temp_output_17_0_g2 = ( lerpResult154 * Texture_Value_Adjusted128 );
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 break168 = ( step( Radius0115 , 1.0 ) * ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) );
				float ProgressAdjusted165 = _Progress;
				float4 appendResult169 = (float4(break168.r , break168.g , break168.b , ( break168.a * saturate( (1.0 + (ProgressAdjusted165 - _StartAlphaFade) * (0.0 - 1.0) / (1.0 - _StartAlphaFade)) ) )));
				
				float4 Color = appendResult169;
				float3 Normal = float3( 0, 0, 1 );

				Color *= IN.color;

				return NormalsRenderingShared(Color, Normal, IN.tangentWS.xyz, IN.bitangentWS, IN.normalWS);
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "Sprite Forward"
            Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX

			#define SHADERPASS SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			sampler2D _tex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float _Progress;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _RingValueMid;
			float _MidColorFadeEnd;
			float _RingValueEnd;
			float _TexRadialSpeed;
			float _ValueMulitPower;
			float _ValueMultiEndPosition;
			float _ValueMultiStartPosition;
			float _ValueMultiEndFactor;
			float _ValueMultiStartFactor;
			float _MaxRadius;
			float _RingValueStart;
			float _StartAlphaFade;
			CBUFFER_END


			struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE( v );

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float ProgressAdjusted165 = _Progress;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = ( v.positionOS * ( ProgressAdjusted165 * _MaxRadius ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);

				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;
				o.texCoord0 = v.uv0;
				o.color = v.color;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float4 positionCS = IN.positionCS;
				float3 positionWS = IN.positionWS;

				float2 temp_output_34_0_g1 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float lerpResult154 = lerp( _ValueMultiStartFactor , _ValueMultiEndFactor , pow( saturate( (0.0 + (Radius0115 - _ValueMultiStartPosition) * (1.0 - 0.0) / (_ValueMultiEndPosition - _ValueMultiStartPosition)) ) , _ValueMulitPower ));
				float mulTime136 = _TimeParameters.x * _TexRadialSpeed;
				float2 appendResult140 = (float2(mulTime136 , 0.0));
				float2 temp_output_34_0_g3 = ( IN.texCoord0.xy - float2( 0.5,0.5 ) );
				float2 break39_g3 = temp_output_34_0_g3;
				float2 appendResult50_g3 = (float2(( 1.0 * ( length( temp_output_34_0_g3 ) * 2.0 ) ) , ( ( atan2( break39_g3.x , break39_g3.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 temp_output_141_0 = ( appendResult140 + appendResult50_g3 );
				float4 tex2DNode157 = tex2D( _tex, temp_output_141_0 );
				float MainTexValue120 = saturate( ( ( tex2DNode157.r + tex2DNode157.b + tex2DNode157.g ) / 3.0 ) );
				float temp_output_125_0 = (0.0 + (MainTexValue120 - _RingValueStart) * (1.0 - 0.0) / (_RingValueEnd - _RingValueStart));
				float Texture_Value_Adjusted128 = ( temp_output_125_0 <= _RingValueMid ? saturate( (0.0 + (temp_output_125_0 - 0.0) * (0.5 - 0.0) / (_RingValueMid - 0.0)) ) : saturate( (0.5 + (temp_output_125_0 - 0.0) * (1.0 - 0.5) / (_RingValueMid - 0.0)) ) );
				float temp_output_17_0_g2 = ( lerpResult154 * Texture_Value_Adjusted128 );
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 break168 = ( step( Radius0115 , 1.0 ) * ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) );
				float ProgressAdjusted165 = _Progress;
				float4 appendResult169 = (float4(break168.r , break168.g , break168.b , ( break168.a * saturate( (1.0 + (ProgressAdjusted165 - _StartAlphaFade) * (0.0 - 1.0) / (1.0 - _StartAlphaFade)) ) )));
				
				float4 Color = appendResult169;

				#if defined(DEBUG_DISPLAY)
					SurfaceData2D surfaceData;
					InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
					InputData2D inputData;
					InitializeInputData(positionWS.xy, half2(IN.texCoord0.xy), inputData);
					half4 debugColor = 0;

					SETUP_DEBUG_DATA_2D(inputData, positionWS, positionCS);

					if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
					{
						return debugColor;
					}
				#endif

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif

				Color *= IN.color;
				return Color;
			}

			ENDHLSL
		}
		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENESELECTIONPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			sampler2D _tex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float _Progress;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _RingValueMid;
			float _MidColorFadeEnd;
			float _RingValueEnd;
			float _TexRadialSpeed;
			float _ValueMulitPower;
			float _ValueMultiEndPosition;
			float _ValueMultiStartPosition;
			float _ValueMultiEndFactor;
			float _ValueMultiStartFactor;
			float _MaxRadius;
			float _RingValueStart;
			float _StartAlphaFade;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			
			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float ProgressAdjusted165 = _Progress;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * ( ProgressAdjusted165 * _MaxRadius ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN) : SV_TARGET
			{
				float2 temp_output_34_0_g1 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float lerpResult154 = lerp( _ValueMultiStartFactor , _ValueMultiEndFactor , pow( saturate( (0.0 + (Radius0115 - _ValueMultiStartPosition) * (1.0 - 0.0) / (_ValueMultiEndPosition - _ValueMultiStartPosition)) ) , _ValueMulitPower ));
				float mulTime136 = _TimeParameters.x * _TexRadialSpeed;
				float2 appendResult140 = (float2(mulTime136 , 0.0));
				float2 temp_output_34_0_g3 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g3 = temp_output_34_0_g3;
				float2 appendResult50_g3 = (float2(( 1.0 * ( length( temp_output_34_0_g3 ) * 2.0 ) ) , ( ( atan2( break39_g3.x , break39_g3.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 temp_output_141_0 = ( appendResult140 + appendResult50_g3 );
				float4 tex2DNode157 = tex2D( _tex, temp_output_141_0 );
				float MainTexValue120 = saturate( ( ( tex2DNode157.r + tex2DNode157.b + tex2DNode157.g ) / 3.0 ) );
				float temp_output_125_0 = (0.0 + (MainTexValue120 - _RingValueStart) * (1.0 - 0.0) / (_RingValueEnd - _RingValueStart));
				float Texture_Value_Adjusted128 = ( temp_output_125_0 <= _RingValueMid ? saturate( (0.0 + (temp_output_125_0 - 0.0) * (0.5 - 0.0) / (_RingValueMid - 0.0)) ) : saturate( (0.5 + (temp_output_125_0 - 0.0) * (1.0 - 0.5) / (_RingValueMid - 0.0)) ) );
				float temp_output_17_0_g2 = ( lerpResult154 * Texture_Value_Adjusted128 );
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 break168 = ( step( Radius0115 , 1.0 ) * ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) );
				float ProgressAdjusted165 = _Progress;
				float4 appendResult169 = (float4(break168.r , break168.g , break168.b , ( break168.a * saturate( (1.0 + (ProgressAdjusted165 - _StartAlphaFade) * (0.0 - 1.0) / (1.0 - _StartAlphaFade)) ) )));
				
				float4 Color = appendResult169;

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

            ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			Cull Off

            HLSLPROGRAM

			#define ASE_ABSOLUTE_VERTEX_POS 1
			#define ASE_VERSION 19801
			#define ASE_SRP_VERSION 170003


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ DEBUG_DISPLAY SKINNED_SPRITE

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
            #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
            #define FEATURES_GRAPH_VERTEX

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        	#define ASE_NEEDS_VERT_POSITION


			sampler2D _tex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float _Progress;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _RingValueMid;
			float _MidColorFadeEnd;
			float _RingValueEnd;
			float _TexRadialSpeed;
			float _ValueMulitPower;
			float _ValueMultiEndPosition;
			float _ValueMultiStartPosition;
			float _ValueMultiEndFactor;
			float _ValueMultiStartFactor;
			float _MaxRadius;
			float _RingValueStart;
			float _StartAlphaFade;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_SKINNED_VERTEX_INPUTS
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			
			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float ProgressAdjusted165 = _Progress;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * ( ProgressAdjusted165 * _MaxRadius ) );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS = vertexValue;
				#else
					v.positionOS += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				float2 temp_output_34_0_g1 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float lerpResult154 = lerp( _ValueMultiStartFactor , _ValueMultiEndFactor , pow( saturate( (0.0 + (Radius0115 - _ValueMultiStartPosition) * (1.0 - 0.0) / (_ValueMultiEndPosition - _ValueMultiStartPosition)) ) , _ValueMulitPower ));
				float mulTime136 = _TimeParameters.x * _TexRadialSpeed;
				float2 appendResult140 = (float2(mulTime136 , 0.0));
				float2 temp_output_34_0_g3 = ( IN.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float2 break39_g3 = temp_output_34_0_g3;
				float2 appendResult50_g3 = (float2(( 1.0 * ( length( temp_output_34_0_g3 ) * 2.0 ) ) , ( ( atan2( break39_g3.x , break39_g3.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 temp_output_141_0 = ( appendResult140 + appendResult50_g3 );
				float4 tex2DNode157 = tex2D( _tex, temp_output_141_0 );
				float MainTexValue120 = saturate( ( ( tex2DNode157.r + tex2DNode157.b + tex2DNode157.g ) / 3.0 ) );
				float temp_output_125_0 = (0.0 + (MainTexValue120 - _RingValueStart) * (1.0 - 0.0) / (_RingValueEnd - _RingValueStart));
				float Texture_Value_Adjusted128 = ( temp_output_125_0 <= _RingValueMid ? saturate( (0.0 + (temp_output_125_0 - 0.0) * (0.5 - 0.0) / (_RingValueMid - 0.0)) ) : saturate( (0.5 + (temp_output_125_0 - 0.0) * (1.0 - 0.5) / (_RingValueMid - 0.0)) ) );
				float temp_output_17_0_g2 = ( lerpResult154 * Texture_Value_Adjusted128 );
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 break168 = ( step( Radius0115 , 1.0 ) * ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) );
				float ProgressAdjusted165 = _Progress;
				float4 appendResult169 = (float4(break168.r , break168.g , break168.b , ( break168.a * saturate( (1.0 + (ProgressAdjusted165 - _StartAlphaFade) * (0.0 - 1.0) / (1.0 - _StartAlphaFade)) ) )));
				
				float4 Color = appendResult169;
				half4 outColor = _SelectionID;
				return outColor;
			}

            ENDHLSL
        }
		
	}
	CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;133;-1152,-1904;Inherit;False;1465.24;666.3463;;3;140;136;134;Polar Coordinate for Tiled Textures;0.0360321,0.174492,0.2938005,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-896,-1728;Inherit;False;Property;_TexRadialSpeed;TexRadialSpeed;10;0;Create;True;0;0;0;False;0;False;2;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;136;-592,-1728;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-160,-1696;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;160;112,-1296;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.SimpleAddOpNode;141;432,-1360;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;157;784,-1312;Inherit;True;Property;_tex;tex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;158;1120,-1280;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;159;1264,-1280;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;183;1584,-1312;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;121;2555.913,-1621.545;Inherit;False;1748;466.75;;11;132;131;130;129;128;127;126;125;124;123;122;Adjust Texture Value;0.4609163,0,0.1071862,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;1680,-1168;Inherit;False;MainTexValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;752,-944;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.RangedFloatNode;122;2603.913,-1381.545;Inherit;False;Property;_RingValueStart;RingValueStart;20;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;2603.913,-1285.545;Inherit;False;Property;_RingValueEnd;RingValueEnd;22;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;2683.913,-1541.545;Inherit;False;120;MainTexValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;125;2971.913,-1397.545;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;2960,-1616;Inherit;False;Property;_RingValueMid;RingValueMid;21;0;Create;True;0;0;0;False;0;False;0.4645969;0.619;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;1024,-720;Inherit;False;Radius01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-2041.67,13.7085;Inherit;False;Property;_ValueMultiEndPosition;ValueMultiEndPosition;17;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-2041.67,-82.2915;Inherit;False;Property;_ValueMultiStartPosition;ValueMultiStartPosition;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-2025.67,-194.2915;Inherit;False;15;Radius01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;127;3435.913,-1573.545;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;129;3211.913,-1493.545;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;146;-1721.67,-130.2915;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;130;3387.913,-1349.545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;132;3595.913,-1253.545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;147;-1497.67,-2.291504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-1609.67,157.7085;Inherit;False;Property;_ValueMulitPower;ValueMulitPower;19;0;Create;True;0;0;0;False;0;False;1;1;0.01;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;131;3883.913,-1413.545;Inherit;False;5;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;150;-1177.67,125.7085;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-1353.67,-194.2915;Inherit;False;Property;_ValueMultiStartFactor;ValueMultiStartFactor;15;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-1353.67,-82.2915;Inherit;False;Property;_ValueMultiEndFactor;ValueMultiEndFactor;18;0;Create;True;0;0;0;False;0;False;0;0.59;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;4000,-1520;Inherit;False;Texture Value Adjusted;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;154;-969.6699,-34.2915;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;-80,-512;Inherit;False;1188;925.7445;;12;11;12;10;13;14;9;6;8;1;2;3;4;Color based on Radius;0.188822,0.1283375,0.2641509,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-752,208;Inherit;False;128;Texture Value Adjusted;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;2112,-1072;Inherit;False;Property;_Progress;Progress;25;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;208,-256;Inherit;False;Property;_CenterColorFadeStart;CenterColorFadeStart;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;208,-176;Inherit;False;Property;_CenterColorFadeEnd;CenterColorFadeEnd;5;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;288,176;Inherit;False;Property;_OuterColor;OuterColor;9;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;13;192,64;Inherit;False;Property;_MidColorFadeEnd;MidColorFadeEnd;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;192,-16;Inherit;False;Property;_MidColorFadeStart;MidColorFadeStart;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;272,-464;Inherit;False;Property;_CenterColor;CenterColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-448,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-32,-112;Inherit;False;Property;_MidColor;MidColor;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;2480,-1072;Inherit;False;ProgressAdjusted;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;832,-256;Inherit;False;3 Color Lerp;-1;;2;e2bec99fefb3b0346a911c5a84f3004b;0;8;17;FLOAT;0;False;22;COLOR;1,1,1,1;False;18;FLOAT;0;False;19;FLOAT;0;False;23;COLOR;0.5,0.5,0.5,1;False;20;FLOAT;0;False;21;FLOAT;0;False;24;COLOR;0,0,0,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;17;1280,-720;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;2000,-560;Inherit;False;165;ProgressAdjusted;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;2080,-240;Inherit;False;Property;_StartAlphaFade;StartAlphaFade;26;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;1520,-672;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;177;2448,-272;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;1984,-464;Inherit;False;Property;_MaxRadius;MaxRadius;16;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;168;2016,-896;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;178;2672,-272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-1744,-1008;Inherit;False;1491;229.85;;6;65;63;64;61;60;112;Scale UV Base;0.03875934,0.06604779,0.1226415,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;57;2544,-752;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;2560,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;2144,-688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;768,-1536;Inherit;True;Property;_tex2;tex2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;181;1088,-1488;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;180;1248,-1488;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;1440,-1424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-592,-80;Inherit;False;ValueFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;1920,-1184;Inherit;False;156;ValueFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;2016,-1568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;1040,-992;Inherit;True;Property;_MainTex;_MainTex;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;118;1440,-864;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;119;1552,-848;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1696,-960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-1424,-960;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1248,-960;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1232,-784;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1520,-592;Inherit;False;102;ImpactProximity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;107;-960,-784;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1152,-608;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;-896,-960;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-672,-944;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-528,-960;Inherit;False;ScaledUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;2288,-1600;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;92;1856,-1360;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-736,-608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1696,-752;Inherit;False;Property;_ImpactScaleStrength1;ImpactScaleStrength;11;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;1776,-1056;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-256,-1216;Inherit;False;Property;_Float1;Float 1;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-256,-1296;Inherit;False;Property;_Float0;Float 0;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;169;2320,-864;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2800,-640;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;87;816,-2188;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;88;1184,-2124;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;81;1040,-1932;Inherit;False;Property;_ImpactPosition;ImpactPosition;13;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;83;1408,-1868;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;1472,-2060;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;94;1664,-2044;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;1888,-2028;Inherit;False;ImpactDirection;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;91;1712,-1808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;1840,-1712;Inherit;False;ImpactProximity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;90;1504,-1808;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;1136,-1744;Inherit;False;Property;_ImpactDeformRadius;ImpactDeformRadius;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=NormalsRendering;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;ScenePickingPass;0;4;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;3072,-912;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;Explosion;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;0;638734060164143657;Debug Display;0;0;External Alpha;0;0;0;5;True;True;True;True;True;False;;False;0
WireConnection;136;0;134;0
WireConnection;140;0;136;0
WireConnection;141;0;140;0
WireConnection;141;1;160;0
WireConnection;157;1;141;0
WireConnection;158;0;157;1
WireConnection;158;1;157;3
WireConnection;158;2;157;2
WireConnection;159;0;158;0
WireConnection;183;0;159;0
WireConnection;120;0;183;0
WireConnection;125;0;124;0
WireConnection;125;1;122;0
WireConnection;125;2;123;0
WireConnection;15;0;7;55
WireConnection;127;0;125;0
WireConnection;127;2;126;0
WireConnection;129;0;125;0
WireConnection;129;2;126;0
WireConnection;146;0;143;0
WireConnection;146;1;145;0
WireConnection;146;2;144;0
WireConnection;130;0;129;0
WireConnection;132;0;127;0
WireConnection;147;0;146;0
WireConnection;131;0;125;0
WireConnection;131;1;126;0
WireConnection;131;2;132;0
WireConnection;131;3;130;0
WireConnection;150;0;147;0
WireConnection;150;1;148;0
WireConnection;128;0;131;0
WireConnection;154;0;151;0
WireConnection;154;1;152;0
WireConnection;154;2;150;0
WireConnection;155;0;154;0
WireConnection;155;1;76;0
WireConnection;165;0;164;0
WireConnection;8;17;155;0
WireConnection;8;22;6;0
WireConnection;8;18;11;0
WireConnection;8;19;12;0
WireConnection;8;23;9;0
WireConnection;8;20;14;0
WireConnection;8;21;13;0
WireConnection;8;24;10;0
WireConnection;17;0;15;0
WireConnection;117;0;17;0
WireConnection;117;1;8;0
WireConnection;177;0;166;0
WireConnection;177;1;176;0
WireConnection;168;0;117;0
WireConnection;178;0;177;0
WireConnection;167;0;166;0
WireConnection;167;1;116;0
WireConnection;173;0;168;3
WireConnection;173;1;178;0
WireConnection;179;1;141;0
WireConnection;181;0;179;1
WireConnection;181;1;179;2
WireConnection;181;2;179;3
WireConnection;180;0;181;0
WireConnection;182;0;180;0
WireConnection;156;0;154;0
WireConnection;85;0;163;0
WireConnection;5;1;7;0
WireConnection;118;0;5;1
WireConnection;118;1;5;2
WireConnection;118;2;5;3
WireConnection;119;0;118;0
WireConnection;61;0;60;0
WireConnection;64;0;61;0
WireConnection;106;0;61;0
WireConnection;107;0;64;0
WireConnection;107;1;106;0
WireConnection;107;2;105;0
WireConnection;112;0;64;0
WireConnection;112;1;107;0
WireConnection;112;2;111;0
WireConnection;63;0;112;0
WireConnection;65;0;63;0
WireConnection;84;0;85;0
WireConnection;84;1;85;0
WireConnection;84;2;85;0
WireConnection;56;1;5;0
WireConnection;169;0;168;0
WireConnection;169;1;168;1
WireConnection;169;2;168;2
WireConnection;169;3;173;0
WireConnection;59;0;57;0
WireConnection;59;1;167;0
WireConnection;88;0;87;1
WireConnection;88;1;87;2
WireConnection;83;0;88;0
WireConnection;83;1;81;0
WireConnection;93;0;81;0
WireConnection;93;1;88;0
WireConnection;94;0;93;0
WireConnection;95;0;94;0
WireConnection;91;0;90;0
WireConnection;102;0;91;0
WireConnection;90;0;83;0
WireConnection;90;2;79;0
WireConnection;0;1;169;0
WireConnection;0;4;59;0
ASEEND*/
//CHKSM=5410A0A0C9B4C2D8E334BE78CEFD4045F9BED1CC