// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Bubble 2D Lit"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_MainTex("_MainTex", 2D) = "white" {}
		[HDR]_CenterColor("CenterColor", Color) = (0,0,0,0)
		[HDR]_MidColor("MidColor", Color) = (0,0,0,0)
		[HDR]_OuterColor("OuterColor", Color) = (0,0,0,0)
		_CenterColorFadeStart("CenterColorFadeStart", Range( 0 , 1)) = 0
		_CenterColorFadeEnd("CenterColorFadeEnd", Range( 0 , 1)) = 0
		_MidColorFadeEnd("MidColorFadeEnd", Range( 0 , 1)) = 0
		_MidColorFadeStart("MidColorFadeStart", Range( 0 , 1)) = 0
		_WobbleStrength("WobbleStrength", Range( 0 , 1)) = 0.9227096
		_WobbleScale("WobbleScale", Range( 0 , 5)) = 5
		_WobbleSpeed("WobbleSpeed", Range( 0 , 5)) = 0.08485421
		_UseTexture("UseTexture", Int) = 0
		_ImpactPushedAwayStrength("ImpactPushedAwayStrength", Range( 0 , 4)) = 0
		_ImpactScaleStrength1("ImpactScaleStrength", Float) = 1
		_ImpactDeformRadius("ImpactDeformRadius", Float) = 0
		_ImpactPosition("ImpactPosition", Vector) = (0,0,0,0)
		_ImpactMaster("ImpactMaster", Range( 0 , 1)) = 0
		_RandomSeed("RandomSeed", Float) = 0
		_Progress("Progress", Range( 0 , 1)) = 0
		_PopMaxStrengthValue("PopMaxStrengthValue", Range( 0 , 1)) = 0
		_PopScaleStrength("PopScaleStrength", Range( 1 , 2)) = 1
		_PopMaxStrengthTime("PopMaxStrengthTime", Range( 0 , 1)) = 0
		_PopStartFadeTime("PopStartFadeTime", Range( 0 , 1)) = 0
		_PopStartScale("PopStartScale", Range( 0 , 1)) = 0

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
			#define ASE_NEEDS_FRAG_POSITION


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float2 _ImpactPosition;
			float _Progress;
			float _MidColorFadeEnd;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _ImpactPushedAwayStrength;
			float _PopMaxStrengthTime;
			float _PopMaxStrengthValue;
			float _WobbleStrength;
			float _WobbleScale;
			float _RandomSeed;
			float _WobbleSpeed;
			float _ImpactMaster;
			float _ImpactDeformRadius;
			float _ImpactScaleStrength1;
			float _PopScaleStrength;
			float _PopStartScale;
			int _UseTexture;
			float _PopStartFadeTime;
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
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float PopAlphaboostgg136 = ( ( saturate( (0.0 + (_Progress - _PopStartScale) * (1.0 - 0.0) / (1.0 - _PopStartScale)) ) * _PopScaleStrength ) + 1.0 );
				
				o.ase_texcoord4 = float4(v.positionOS,1);
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * float3( 2,2,2 ) * PopAlphaboostgg136 );
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

				float2 texCoord60 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_61_0 = ( texCoord60 - float2( 0.5,0.5 ) );
				float2 temp_output_64_0 = ( temp_output_61_0 * float2( 2,2 ) );
				float2 appendResult88 = (float2(IN.ase_texcoord4.xyz.x , IN.ase_texcoord4.xyz.y));
				float temp_output_91_0 = saturate( (1.0 + (distance( appendResult88 , _ImpactPosition ) - 0.0) * (0.0 - 1.0) / (_ImpactDeformRadius - 0.0)) );
				float ImpactProximity102 = temp_output_91_0;
				float2 lerpResult107 = lerp( temp_output_64_0 , ( temp_output_61_0 * _ImpactScaleStrength1 ) , ImpactProximity102);
				float ImpactMasterPT110 = _ImpactMaster;
				float2 lerpResult112 = lerp( temp_output_64_0 , lerpResult107 , ImpactMasterPT110);
				float2 ScaledUV65 = ( lerpResult112 + float2( 0.5,0.5 ) );
				float2 break69 = ScaledUV65;
				float mulTime45 = _TimeParameters.x * _WobbleSpeed;
				float3 appendResult35 = (float3(break69.x , break69.y , ( mulTime45 + _RandomSeed )));
				float simplePerlin3D31 = snoise( appendResult35*_WobbleScale );
				simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
				float lerpResult121 = lerp( _WobbleStrength , _PopMaxStrengthValue , saturate( (0.0 + (_Progress - 0.0) * (1.0 - 0.0) / (_PopMaxStrengthTime - 0.0)) ));
				float2 break72 = ScaledUV65;
				float2 break67 = ScaledUV65;
				float3 appendResult47 = (float3(break67.x , break67.y , ( mulTime45 + 385535.0 + _RandomSeed )));
				float simplePerlin3D42 = snoise( appendResult47*_WobbleScale );
				simplePerlin3D42 = simplePerlin3D42*0.5 + 0.5;
				float2 appendResult37 = (float2(( (-lerpResult121 + (simplePerlin3D31 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.x ) , ( (-lerpResult121 + (simplePerlin3D42 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.y )));
				float2 WobbledUVs52 = appendResult37;
				float2 normalizeResult94 = normalize( ( _ImpactPosition - appendResult88 ) );
				float2 ImpactDirection95 = normalizeResult94;
				float2 temp_output_99_0 = ( WobbledUVs52 + ( _ImpactPushedAwayStrength * ImpactDirection95 * ImpactProximity102 * _ImpactMaster ) );
				float2 temp_output_34_0_g1 = ( temp_output_99_0 - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float temp_output_17_0_g2 = Radius0115;
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) , step( Radius0115 , 1.0 ));
				float4 lerpResult56 = lerp( lerpResult18 , tex2D( _MainTex, temp_output_99_0 ) , (float)_UseTexture);
				float4 break127 = lerpResult56;
				float AlphaMultiPop125 = saturate( (1.0 + (_Progress - _PopStartFadeTime) * (0.0 - 1.0) / (1.0 - _PopStartFadeTime)) );
				float4 appendResult126 = (float4(break127.r , break127.g , break127.b , ( break127.a * AlphaMultiPop125 )));
				
				float4 Color = appendResult126;
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
			#define ASE_NEEDS_FRAG_POSITION


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float2 _ImpactPosition;
			float _Progress;
			float _MidColorFadeEnd;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _ImpactPushedAwayStrength;
			float _PopMaxStrengthTime;
			float _PopMaxStrengthValue;
			float _WobbleStrength;
			float _WobbleScale;
			float _RandomSeed;
			float _WobbleSpeed;
			float _ImpactMaster;
			float _ImpactDeformRadius;
			float _ImpactScaleStrength1;
			float _PopScaleStrength;
			float _PopStartScale;
			int _UseTexture;
			float _PopStartFadeTime;
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
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float PopAlphaboostgg136 = ( ( saturate( (0.0 + (_Progress - _PopStartScale) * (1.0 - 0.0) / (1.0 - _PopStartScale)) ) * _PopScaleStrength ) + 1.0 );
				
				o.ase_texcoord5 = float4(v.positionOS,1);
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * float3( 2,2,2 ) * PopAlphaboostgg136 );
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

				float2 texCoord60 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_61_0 = ( texCoord60 - float2( 0.5,0.5 ) );
				float2 temp_output_64_0 = ( temp_output_61_0 * float2( 2,2 ) );
				float2 appendResult88 = (float2(IN.ase_texcoord5.xyz.x , IN.ase_texcoord5.xyz.y));
				float temp_output_91_0 = saturate( (1.0 + (distance( appendResult88 , _ImpactPosition ) - 0.0) * (0.0 - 1.0) / (_ImpactDeformRadius - 0.0)) );
				float ImpactProximity102 = temp_output_91_0;
				float2 lerpResult107 = lerp( temp_output_64_0 , ( temp_output_61_0 * _ImpactScaleStrength1 ) , ImpactProximity102);
				float ImpactMasterPT110 = _ImpactMaster;
				float2 lerpResult112 = lerp( temp_output_64_0 , lerpResult107 , ImpactMasterPT110);
				float2 ScaledUV65 = ( lerpResult112 + float2( 0.5,0.5 ) );
				float2 break69 = ScaledUV65;
				float mulTime45 = _TimeParameters.x * _WobbleSpeed;
				float3 appendResult35 = (float3(break69.x , break69.y , ( mulTime45 + _RandomSeed )));
				float simplePerlin3D31 = snoise( appendResult35*_WobbleScale );
				simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
				float lerpResult121 = lerp( _WobbleStrength , _PopMaxStrengthValue , saturate( (0.0 + (_Progress - 0.0) * (1.0 - 0.0) / (_PopMaxStrengthTime - 0.0)) ));
				float2 break72 = ScaledUV65;
				float2 break67 = ScaledUV65;
				float3 appendResult47 = (float3(break67.x , break67.y , ( mulTime45 + 385535.0 + _RandomSeed )));
				float simplePerlin3D42 = snoise( appendResult47*_WobbleScale );
				simplePerlin3D42 = simplePerlin3D42*0.5 + 0.5;
				float2 appendResult37 = (float2(( (-lerpResult121 + (simplePerlin3D31 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.x ) , ( (-lerpResult121 + (simplePerlin3D42 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.y )));
				float2 WobbledUVs52 = appendResult37;
				float2 normalizeResult94 = normalize( ( _ImpactPosition - appendResult88 ) );
				float2 ImpactDirection95 = normalizeResult94;
				float2 temp_output_99_0 = ( WobbledUVs52 + ( _ImpactPushedAwayStrength * ImpactDirection95 * ImpactProximity102 * _ImpactMaster ) );
				float2 temp_output_34_0_g1 = ( temp_output_99_0 - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float temp_output_17_0_g2 = Radius0115;
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) , step( Radius0115 , 1.0 ));
				float4 lerpResult56 = lerp( lerpResult18 , tex2D( _MainTex, temp_output_99_0 ) , (float)_UseTexture);
				float4 break127 = lerpResult56;
				float AlphaMultiPop125 = saturate( (1.0 + (_Progress - _PopStartFadeTime) * (0.0 - 1.0) / (1.0 - _PopStartFadeTime)) );
				float4 appendResult126 = (float4(break127.r , break127.g , break127.b , ( break127.a * AlphaMultiPop125 )));
				
				float4 Color = appendResult126;
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
			#define ASE_NEEDS_FRAG_POSITION


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float2 _ImpactPosition;
			float _Progress;
			float _MidColorFadeEnd;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _ImpactPushedAwayStrength;
			float _PopMaxStrengthTime;
			float _PopMaxStrengthValue;
			float _WobbleStrength;
			float _WobbleScale;
			float _RandomSeed;
			float _WobbleSpeed;
			float _ImpactMaster;
			float _ImpactDeformRadius;
			float _ImpactScaleStrength1;
			float _PopScaleStrength;
			float _PopStartScale;
			int _UseTexture;
			float _PopStartFadeTime;
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
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE( v );

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float PopAlphaboostgg136 = ( ( saturate( (0.0 + (_Progress - _PopStartScale) * (1.0 - 0.0) / (1.0 - _PopStartScale)) ) * _PopScaleStrength ) + 1.0 );
				
				o.ase_texcoord3 = float4(v.positionOS,1);
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = ( v.positionOS * float3( 2,2,2 ) * PopAlphaboostgg136 );
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

				float2 texCoord60 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_61_0 = ( texCoord60 - float2( 0.5,0.5 ) );
				float2 temp_output_64_0 = ( temp_output_61_0 * float2( 2,2 ) );
				float2 appendResult88 = (float2(IN.ase_texcoord3.xyz.x , IN.ase_texcoord3.xyz.y));
				float temp_output_91_0 = saturate( (1.0 + (distance( appendResult88 , _ImpactPosition ) - 0.0) * (0.0 - 1.0) / (_ImpactDeformRadius - 0.0)) );
				float ImpactProximity102 = temp_output_91_0;
				float2 lerpResult107 = lerp( temp_output_64_0 , ( temp_output_61_0 * _ImpactScaleStrength1 ) , ImpactProximity102);
				float ImpactMasterPT110 = _ImpactMaster;
				float2 lerpResult112 = lerp( temp_output_64_0 , lerpResult107 , ImpactMasterPT110);
				float2 ScaledUV65 = ( lerpResult112 + float2( 0.5,0.5 ) );
				float2 break69 = ScaledUV65;
				float mulTime45 = _TimeParameters.x * _WobbleSpeed;
				float3 appendResult35 = (float3(break69.x , break69.y , ( mulTime45 + _RandomSeed )));
				float simplePerlin3D31 = snoise( appendResult35*_WobbleScale );
				simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
				float lerpResult121 = lerp( _WobbleStrength , _PopMaxStrengthValue , saturate( (0.0 + (_Progress - 0.0) * (1.0 - 0.0) / (_PopMaxStrengthTime - 0.0)) ));
				float2 break72 = ScaledUV65;
				float2 break67 = ScaledUV65;
				float3 appendResult47 = (float3(break67.x , break67.y , ( mulTime45 + 385535.0 + _RandomSeed )));
				float simplePerlin3D42 = snoise( appendResult47*_WobbleScale );
				simplePerlin3D42 = simplePerlin3D42*0.5 + 0.5;
				float2 appendResult37 = (float2(( (-lerpResult121 + (simplePerlin3D31 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.x ) , ( (-lerpResult121 + (simplePerlin3D42 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.y )));
				float2 WobbledUVs52 = appendResult37;
				float2 normalizeResult94 = normalize( ( _ImpactPosition - appendResult88 ) );
				float2 ImpactDirection95 = normalizeResult94;
				float2 temp_output_99_0 = ( WobbledUVs52 + ( _ImpactPushedAwayStrength * ImpactDirection95 * ImpactProximity102 * _ImpactMaster ) );
				float2 temp_output_34_0_g1 = ( temp_output_99_0 - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float temp_output_17_0_g2 = Radius0115;
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) , step( Radius0115 , 1.0 ));
				float4 lerpResult56 = lerp( lerpResult18 , tex2D( _MainTex, temp_output_99_0 ) , (float)_UseTexture);
				float4 break127 = lerpResult56;
				float AlphaMultiPop125 = saturate( (1.0 + (_Progress - _PopStartFadeTime) * (0.0 - 1.0) / (1.0 - _PopStartFadeTime)) );
				float4 appendResult126 = (float4(break127.r , break127.g , break127.b , ( break127.a * AlphaMultiPop125 )));
				
				float4 Color = appendResult126;

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
			#define ASE_NEEDS_FRAG_POSITION


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float2 _ImpactPosition;
			float _Progress;
			float _MidColorFadeEnd;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _ImpactPushedAwayStrength;
			float _PopMaxStrengthTime;
			float _PopMaxStrengthValue;
			float _WobbleStrength;
			float _WobbleScale;
			float _RandomSeed;
			float _WobbleSpeed;
			float _ImpactMaster;
			float _ImpactDeformRadius;
			float _ImpactScaleStrength1;
			float _PopScaleStrength;
			float _PopStartScale;
			int _UseTexture;
			float _PopStartFadeTime;
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
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            int _ObjectId;
            int _PassValue;

			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float PopAlphaboostgg136 = ( ( saturate( (0.0 + (_Progress - _PopStartScale) * (1.0 - 0.0) / (1.0 - _PopStartScale)) ) * _PopScaleStrength ) + 1.0 );
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord1 = float4(v.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * float3( 2,2,2 ) * PopAlphaboostgg136 );
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
				float2 texCoord60 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_61_0 = ( texCoord60 - float2( 0.5,0.5 ) );
				float2 temp_output_64_0 = ( temp_output_61_0 * float2( 2,2 ) );
				float2 appendResult88 = (float2(IN.ase_texcoord1.xyz.x , IN.ase_texcoord1.xyz.y));
				float temp_output_91_0 = saturate( (1.0 + (distance( appendResult88 , _ImpactPosition ) - 0.0) * (0.0 - 1.0) / (_ImpactDeformRadius - 0.0)) );
				float ImpactProximity102 = temp_output_91_0;
				float2 lerpResult107 = lerp( temp_output_64_0 , ( temp_output_61_0 * _ImpactScaleStrength1 ) , ImpactProximity102);
				float ImpactMasterPT110 = _ImpactMaster;
				float2 lerpResult112 = lerp( temp_output_64_0 , lerpResult107 , ImpactMasterPT110);
				float2 ScaledUV65 = ( lerpResult112 + float2( 0.5,0.5 ) );
				float2 break69 = ScaledUV65;
				float mulTime45 = _TimeParameters.x * _WobbleSpeed;
				float3 appendResult35 = (float3(break69.x , break69.y , ( mulTime45 + _RandomSeed )));
				float simplePerlin3D31 = snoise( appendResult35*_WobbleScale );
				simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
				float lerpResult121 = lerp( _WobbleStrength , _PopMaxStrengthValue , saturate( (0.0 + (_Progress - 0.0) * (1.0 - 0.0) / (_PopMaxStrengthTime - 0.0)) ));
				float2 break72 = ScaledUV65;
				float2 break67 = ScaledUV65;
				float3 appendResult47 = (float3(break67.x , break67.y , ( mulTime45 + 385535.0 + _RandomSeed )));
				float simplePerlin3D42 = snoise( appendResult47*_WobbleScale );
				simplePerlin3D42 = simplePerlin3D42*0.5 + 0.5;
				float2 appendResult37 = (float2(( (-lerpResult121 + (simplePerlin3D31 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.x ) , ( (-lerpResult121 + (simplePerlin3D42 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.y )));
				float2 WobbledUVs52 = appendResult37;
				float2 normalizeResult94 = normalize( ( _ImpactPosition - appendResult88 ) );
				float2 ImpactDirection95 = normalizeResult94;
				float2 temp_output_99_0 = ( WobbledUVs52 + ( _ImpactPushedAwayStrength * ImpactDirection95 * ImpactProximity102 * _ImpactMaster ) );
				float2 temp_output_34_0_g1 = ( temp_output_99_0 - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float temp_output_17_0_g2 = Radius0115;
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) , step( Radius0115 , 1.0 ));
				float4 lerpResult56 = lerp( lerpResult18 , tex2D( _MainTex, temp_output_99_0 ) , (float)_UseTexture);
				float4 break127 = lerpResult56;
				float AlphaMultiPop125 = saturate( (1.0 + (_Progress - _PopStartFadeTime) * (0.0 - 1.0) / (1.0 - _PopStartFadeTime)) );
				float4 appendResult126 = (float4(break127.r , break127.g , break127.b , ( break127.a * AlphaMultiPop125 )));
				
				float4 Color = appendResult126;

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
        	#define ASE_NEEDS_FRAG_POSITION


			sampler2D _MainTex;
			CBUFFER_START( UnityPerMaterial )
			float4 _OuterColor;
			float4 _MidColor;
			float4 _CenterColor;
			float2 _ImpactPosition;
			float _Progress;
			float _MidColorFadeEnd;
			float _MidColorFadeStart;
			float _CenterColorFadeStart;
			float _CenterColorFadeEnd;
			float _ImpactPushedAwayStrength;
			float _PopMaxStrengthTime;
			float _PopMaxStrengthValue;
			float _WobbleStrength;
			float _WobbleScale;
			float _RandomSeed;
			float _WobbleSpeed;
			float _ImpactMaster;
			float _ImpactDeformRadius;
			float _ImpactScaleStrength1;
			float _PopScaleStrength;
			float _PopStartScale;
			int _UseTexture;
			float _PopStartFadeTime;
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
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }
			float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }
			float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }
			float snoise( float3 v )
			{
				const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
				float3 i = floor( v + dot( v, C.yyy ) );
				float3 x0 = v - i + dot( i, C.xxx );
				float3 g = step( x0.yzx, x0.xyz );
				float3 l = 1.0 - g;
				float3 i1 = min( g.xyz, l.zxy );
				float3 i2 = max( g.xyz, l.zxy );
				float3 x1 = x0 - i1 + C.xxx;
				float3 x2 = x0 - i2 + C.yyy;
				float3 x3 = x0 - 0.5;
				i = mod3D289( i);
				float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
				float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
				float4 x_ = floor( j / 7.0 );
				float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
				float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
				float4 h = 1.0 - abs( x ) - abs( y );
				float4 b0 = float4( x.xy, y.xy );
				float4 b1 = float4( x.zw, y.zw );
				float4 s0 = floor( b0 ) * 2.0 + 1.0;
				float4 s1 = floor( b1 ) * 2.0 + 1.0;
				float4 sh = -step( h, 0.0 );
				float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
				float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
				float3 g0 = float3( a0.xy, h.x );
				float3 g1 = float3( a0.zw, h.y );
				float3 g2 = float3( a1.xy, h.z );
				float3 g3 = float3( a1.zw, h.w );
				float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
				g0 *= norm.x;
				g1 *= norm.y;
				g2 *= norm.z;
				g3 *= norm.w;
				float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
				m = m* m;
				m = m* m;
				float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
				return 42.0 * dot( m, px);
			}
			

			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_SKINNED_VERTEX_COMPUTE(v);

				v.positionOS = UnityFlipSprite( v.positionOS, unity_SpriteProps.xy );

				float PopAlphaboostgg136 = ( ( saturate( (0.0 + (_Progress - _PopStartScale) * (1.0 - 0.0) / (1.0 - _PopStartScale)) ) * _PopScaleStrength ) + 1.0 );
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord1 = float4(v.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( v.positionOS * float3( 2,2,2 ) * PopAlphaboostgg136 );
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
				float2 texCoord60 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_61_0 = ( texCoord60 - float2( 0.5,0.5 ) );
				float2 temp_output_64_0 = ( temp_output_61_0 * float2( 2,2 ) );
				float2 appendResult88 = (float2(IN.ase_texcoord1.xyz.x , IN.ase_texcoord1.xyz.y));
				float temp_output_91_0 = saturate( (1.0 + (distance( appendResult88 , _ImpactPosition ) - 0.0) * (0.0 - 1.0) / (_ImpactDeformRadius - 0.0)) );
				float ImpactProximity102 = temp_output_91_0;
				float2 lerpResult107 = lerp( temp_output_64_0 , ( temp_output_61_0 * _ImpactScaleStrength1 ) , ImpactProximity102);
				float ImpactMasterPT110 = _ImpactMaster;
				float2 lerpResult112 = lerp( temp_output_64_0 , lerpResult107 , ImpactMasterPT110);
				float2 ScaledUV65 = ( lerpResult112 + float2( 0.5,0.5 ) );
				float2 break69 = ScaledUV65;
				float mulTime45 = _TimeParameters.x * _WobbleSpeed;
				float3 appendResult35 = (float3(break69.x , break69.y , ( mulTime45 + _RandomSeed )));
				float simplePerlin3D31 = snoise( appendResult35*_WobbleScale );
				simplePerlin3D31 = simplePerlin3D31*0.5 + 0.5;
				float lerpResult121 = lerp( _WobbleStrength , _PopMaxStrengthValue , saturate( (0.0 + (_Progress - 0.0) * (1.0 - 0.0) / (_PopMaxStrengthTime - 0.0)) ));
				float2 break72 = ScaledUV65;
				float2 break67 = ScaledUV65;
				float3 appendResult47 = (float3(break67.x , break67.y , ( mulTime45 + 385535.0 + _RandomSeed )));
				float simplePerlin3D42 = snoise( appendResult47*_WobbleScale );
				simplePerlin3D42 = simplePerlin3D42*0.5 + 0.5;
				float2 appendResult37 = (float2(( (-lerpResult121 + (simplePerlin3D31 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.x ) , ( (-lerpResult121 + (simplePerlin3D42 - 0.0) * (lerpResult121 - -lerpResult121) / (1.0 - 0.0)) + break72.y )));
				float2 WobbledUVs52 = appendResult37;
				float2 normalizeResult94 = normalize( ( _ImpactPosition - appendResult88 ) );
				float2 ImpactDirection95 = normalizeResult94;
				float2 temp_output_99_0 = ( WobbledUVs52 + ( _ImpactPushedAwayStrength * ImpactDirection95 * ImpactProximity102 * _ImpactMaster ) );
				float2 temp_output_34_0_g1 = ( temp_output_99_0 - float2( 0.5,0.5 ) );
				float2 break39_g1 = temp_output_34_0_g1;
				float2 appendResult50_g1 = (float2(( 1.0 * ( length( temp_output_34_0_g1 ) * 2.0 ) ) , ( ( atan2( break39_g1.x , break39_g1.y ) * ( 1.0 / TWO_PI ) ) * 1.0 )));
				float2 break53_g1 = appendResult50_g1;
				float Radius0115 = break53_g1.x;
				float temp_output_17_0_g2 = Radius0115;
				float temp_output_19_0_g2 = _CenterColorFadeEnd;
				float4 temp_output_23_0_g2 = _MidColor;
				float4 lerpResult11_g2 = lerp( _CenterColor , temp_output_23_0_g2 , saturate( (0.0 + (temp_output_17_0_g2 - _CenterColorFadeStart) * (1.0 - 0.0) / (temp_output_19_0_g2 - _CenterColorFadeStart)) ));
				float4 lerpResult6_g2 = lerp( temp_output_23_0_g2 , _OuterColor , saturate( (0.0 + (temp_output_17_0_g2 - _MidColorFadeStart) * (1.0 - 0.0) / (_MidColorFadeEnd - _MidColorFadeStart)) ));
				float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( temp_output_17_0_g2 <= temp_output_19_0_g2 ? lerpResult11_g2 : lerpResult6_g2 ) , step( Radius0115 , 1.0 ));
				float4 lerpResult56 = lerp( lerpResult18 , tex2D( _MainTex, temp_output_99_0 ) , (float)_UseTexture);
				float4 break127 = lerpResult56;
				float AlphaMultiPop125 = saturate( (1.0 + (_Progress - _PopStartFadeTime) * (0.0 - 1.0) / (1.0 - _PopStartFadeTime)) );
				float4 appendResult126 = (float4(break127.r , break127.g , break127.b , ( break127.a * AlphaMultiPop125 )));
				
				float4 Color = appendResult126;
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
Node;AmplifyShaderEditor.PosVertexDataNode;87;576,-1936;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;88;944,-1872;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;81;800,-1680;Inherit;False;Property;_ImpactPosition;ImpactPosition;15;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;83;1168,-1616;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;1072,-1488;Inherit;False;Property;_ImpactDeformRadius;ImpactDeformRadius;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;90;1360,-1552;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;74;-1744,-1008;Inherit;False;1491;229.85;;6;65;63;64;61;60;112;Scale UV Base;0.03875934,0.06604779,0.1226415,1;0;0
Node;AmplifyShaderEditor.SaturateNode;91;1568,-1552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-1696,-960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;75;-1760,-2000;Inherit;False;2313.125;933.7896;;29;66;52;37;51;49;72;39;48;71;42;41;31;36;47;35;69;67;46;68;45;43;97;98;99;78;103;108;113;114;Wobble;0.01601993,0.1131255,0.2264151,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;1696,-1456;Inherit;False;ImpactProximity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1632,-784;Inherit;False;Property;_ImpactScaleStrength1;ImpactScaleStrength;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-1424,-960;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-96,-1184;Inherit;False;Property;_ImpactMaster;ImpactMaster;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1248,-960;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1232,-784;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;16,-1008;Inherit;False;ImpactMasterPT;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1520,-592;Inherit;False;102;ImpactProximity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;107;-960,-784;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1152,-608;Inherit;False;110;ImpactMasterPT;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;112;-896,-960;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-672,-944;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-528,-960;Inherit;False;ScaledUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1792,-1552;Inherit;False;Property;_WobbleSpeed;WobbleSpeed;10;0;Create;True;0;0;0;False;0;False;0.08485421;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1936,-2704;Inherit;False;Property;_PopMaxStrengthTime;PopMaxStrengthTime;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-1904,-2816;Inherit;False;Property;_Progress;Progress;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1504,-1664;Inherit;False;65;ScaledUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1664,-1248;Inherit;False;65;ScaledUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1584,-1408;Inherit;False;Property;_RandomSeed;RandomSeed;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-1520,-1552;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;118;-1552,-2800;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1248,-1440;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;385535;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;67;-1264,-1248;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;69;-1312,-1680;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-1232,-1552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;119;-1184,-2768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-992,-2320;Inherit;False;Property;_WobbleStrength;WobbleStrength;8;0;Create;True;0;0;0;False;0;False;0.9227096;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1168,-2416;Inherit;False;Property;_PopMaxStrengthValue;PopMaxStrengthValue;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-1088,-1632;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1072,-1392;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1264,-1808;Inherit;False;Property;_WobbleScale;WobbleScale;9;0;Create;True;0;0;0;False;0;False;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-704,-2544;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;31;-864,-1712;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;41;-640,-1824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;-864,-1488;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-496,-1632;Inherit;False;65;ScaledUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;1232,-1808;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-432,-1488;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;39;-432,-1856;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;72;-272,-1632;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NormalizeNode;94;1424,-1792;Inherit;False;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-32,-1808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-224,-1392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;1643.552,-1778.159;Inherit;False;ImpactDirection;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-128,-1552;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-48,-1360;Inherit;False;95;ImpactDirection;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-208,-1264;Inherit;False;102;ImpactProximity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-80,-1440;Inherit;False;Property;_ImpactPushedAwayStrength;ImpactPushedAwayStrength;12;0;Create;True;0;0;0;False;0;False;0;0;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;128,-1648;Inherit;False;WobbledUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;240,-1440;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;480,-1552;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;7;1072,-752;Inherit;False;Polar Coordinates;-1;;1;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.CommentaryNode;77;-80,-512;Inherit;False;1188;925.7445;;13;11;12;10;13;14;9;6;8;1;2;3;4;76;Color based on Radius;0.188822,0.1283375,0.2641509,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;1264,-560;Inherit;False;Radius01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-1872,-2368;Inherit;False;Property;_PopStartScale;PopStartScale;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;208,-256;Inherit;False;Property;_CenterColorFadeStart;CenterColorFadeStart;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;208,-176;Inherit;False;Property;_CenterColorFadeEnd;CenterColorFadeEnd;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;288,176;Inherit;False;Property;_OuterColor;OuterColor;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;13;192,64;Inherit;False;Property;_MidColorFadeEnd;MidColorFadeEnd;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;192,-16;Inherit;False;Property;_MidColorFadeStart;MidColorFadeStart;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-32,-112;Inherit;False;Property;_MidColor;MidColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;6;272,-464;Inherit;False;Property;_CenterColor;CenterColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;76;624,-464;Inherit;False;15;Radius01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1920,-2592;Inherit;False;Property;_PopStartFadeTime;PopStartFadeTime;22;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;132;-1552,-2400;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;832,-256;Inherit;False;3 Color Lerp;-1;;2;e2bec99fefb3b0346a911c5a84f3004b;0;8;17;FLOAT;0;False;22;COLOR;1,1,1,1;False;18;FLOAT;0;False;19;FLOAT;0;False;23;COLOR;0.5,0.5,0.5,1;False;20;FLOAT;0;False;21;FLOAT;0;False;24;COLOR;0,0,0,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;17;1472,-416;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;123;-1552,-2608;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;133;-1344,-2352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1648,-2192;Inherit;False;Property;_PopScaleStrength;PopScaleStrength;20;0;Create;True;0;0;0;False;0;False;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;1712,-576;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;1440,-1072;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.IntNode;55;1584,-752;Inherit;False;Property;_UseTexture;UseTexture;11;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.SaturateNode;124;-1312,-2608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-1232,-2224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;1936,-896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-1136,-2544;Inherit;False;AlphaMultiPop;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-1024,-2192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;127;2112,-1040;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;128;1920,-720;Inherit;False;125;AlphaMultiPop;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-896,-2192;Inherit;False;PopAlphaboostgg;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;57;2128,-576;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;2256,-816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;2404.064,-448.0564;Inherit;False;136;PopAlphaboostgg;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;2016,-1568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;816,-752;Inherit;False;52;WobbledUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2448,-672;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;2,2,2;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;2288,-1600;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-736,-608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;1440,0;Inherit;False;52;WobbledUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;126;2416,-1088;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2624,-896;Float;False;True;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;Bubble 2D Lit;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;3;Vertex Position;0;638734060164143657;Debug Display;0;0;External Alpha;0;0;0;5;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=NormalsRendering;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;3;UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI;0;16;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;ScenePickingPass;0;4;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
WireConnection;88;0;87;1
WireConnection;88;1;87;2
WireConnection;83;0;88;0
WireConnection;83;1;81;0
WireConnection;90;0;83;0
WireConnection;90;2;79;0
WireConnection;91;0;90;0
WireConnection;102;0;91;0
WireConnection;61;0;60;0
WireConnection;64;0;61;0
WireConnection;106;0;61;0
WireConnection;106;1;104;0
WireConnection;110;0;108;0
WireConnection;107;0;64;0
WireConnection;107;1;106;0
WireConnection;107;2;105;0
WireConnection;112;0;64;0
WireConnection;112;1;107;0
WireConnection;112;2;111;0
WireConnection;63;0;112;0
WireConnection;65;0;63;0
WireConnection;45;0;43;0
WireConnection;118;0;115;0
WireConnection;118;2;120;0
WireConnection;46;0;45;0
WireConnection;46;2;113;0
WireConnection;67;0;66;0
WireConnection;69;0;68;0
WireConnection;114;0;45;0
WireConnection;114;1;113;0
WireConnection;119;0;118;0
WireConnection;35;0;69;0
WireConnection;35;1;69;1
WireConnection;35;2;114;0
WireConnection;47;0;67;0
WireConnection;47;1;67;1
WireConnection;47;2;46;0
WireConnection;121;0;22;0
WireConnection;121;1;116;0
WireConnection;121;2;119;0
WireConnection;31;0;35;0
WireConnection;31;1;36;0
WireConnection;41;0;121;0
WireConnection;42;0;47;0
WireConnection;42;1;36;0
WireConnection;93;0;81;0
WireConnection;93;1;88;0
WireConnection;48;0;42;0
WireConnection;48;3;41;0
WireConnection;48;4;121;0
WireConnection;39;0;31;0
WireConnection;39;3;41;0
WireConnection;39;4;121;0
WireConnection;72;0;71;0
WireConnection;94;0;93;0
WireConnection;49;0;39;0
WireConnection;49;1;72;0
WireConnection;51;0;48;0
WireConnection;51;1;72;1
WireConnection;95;0;94;0
WireConnection;37;0;49;0
WireConnection;37;1;51;0
WireConnection;52;0;37;0
WireConnection;97;0;78;0
WireConnection;97;1;98;0
WireConnection;97;2;103;0
WireConnection;97;3;108;0
WireConnection;99;0;52;0
WireConnection;99;1;97;0
WireConnection;7;1;99;0
WireConnection;15;0;7;55
WireConnection;132;0;115;0
WireConnection;132;1;130;0
WireConnection;8;17;76;0
WireConnection;8;22;6;0
WireConnection;8;18;11;0
WireConnection;8;19;12;0
WireConnection;8;23;9;0
WireConnection;8;20;14;0
WireConnection;8;21;13;0
WireConnection;8;24;10;0
WireConnection;17;0;15;0
WireConnection;123;0;115;0
WireConnection;123;1;122;0
WireConnection;133;0;132;0
WireConnection;18;1;8;0
WireConnection;18;2;17;0
WireConnection;5;1;99;0
WireConnection;124;0;123;0
WireConnection;135;0;133;0
WireConnection;135;1;131;0
WireConnection;56;0;18;0
WireConnection;56;1;5;0
WireConnection;56;2;55;0
WireConnection;125;0;124;0
WireConnection;134;0;135;0
WireConnection;127;0;56;0
WireConnection;136;0;134;0
WireConnection;129;0;127;3
WireConnection;129;1;128;0
WireConnection;85;0;91;0
WireConnection;59;0;57;0
WireConnection;59;2;137;0
WireConnection;84;0;85;0
WireConnection;84;1;85;0
WireConnection;84;2;85;0
WireConnection;126;0;127;0
WireConnection;126;1;127;1
WireConnection;126;2;127;2
WireConnection;126;3;129;0
WireConnection;0;1;126;0
WireConnection;0;4;59;0
ASEEND*/
//CHKSM=9A01DFCA0EE6D0D1EA9B1FE38EC030865D63C71E