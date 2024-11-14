#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying
#define COMPAT_TEXTURE texture2D
#endif

uniform sampler2D tex;
uniform bool enableAlpha;
uniform bool useTexture;
uniform float alphaThreshold;
uniform vec4 baseColorFactor;
uniform int lightType;
uniform vec3 lightPos;
uniform float farPlane;
COMPAT_VARYING vec4 FragPos;
COMPAT_VARYING vec4 vColor0;
COMPAT_VARYING vec2 texcoord0;

const int LightType_Directional = 0;
const int LightType_Point = 1;
const int LightType_Spot = 2;
void main()
{
    vec4 color = baseColorFactor;
    if(useTexture){
        color = color * COMPAT_TEXTURE(tex, texcoord0);
    }
    color *= vColor0;
    if((enableAlpha && color.a <= 0) || (color.a < alphaThreshold)){
        discard;
    }
    if(lightType != LightType_Directional){
        float lightDistance = length(FragPos.xyz - lightPos);
    
        lightDistance = lightDistance / farPlane;
        
        gl_FragDepth = lightDistance;
    }else{
        gl_FragDepth = gl_FragCoord.z/gl_FragCoord.w;
    }
}