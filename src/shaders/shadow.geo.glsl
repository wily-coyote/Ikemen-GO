#if __VERSION__ >= 130
#define COMPAT_POS_IN(i) gl_in[i].gl_Position

layout(triangles) in;
layout(triangle_strip, max_vertices = 18) out;
in vec4 vColor[];
in vec2 texcoord[];
out vec4 FragPos;
out vec4 vColor0;
out vec2 texcoord0;
uniform int layerOffset;
#else
#extension GL_EXT_geometry_shader4: enable
#define COMPAT_POS_IN(i) gl_PositionIn[i]

varying in vec4 vColor[3];
varying in vec2 texcoord[3];
varying out vec4 FragPos;
varying out vec4 vColor0;
varying out vec2 texcoord0;
const int layerOffset = 0;
#endif

uniform int lightType;

uniform mat4 lightMatrices[6];

const int LightType_Directional = 0;
const int LightType_Point = 1;
const int LightType_Spot = 2;
void main() {
    if(lightType == LightType_Point){
        for(int face = 0; face < 6; ++face)
        {
            gl_Layer = layerOffset+face; // built-in variable that specifies to which face we render.
            for(int i = 0; i < 3; ++i) // for each triangle vertex
            {
                FragPos = COMPAT_POS_IN(i);
                texcoord0 = texcoord[i];
                vColor0 = vColor[i];
                gl_Position = lightMatrices[face] * COMPAT_POS_IN(i);
                EmitVertex();
            }    
            EndPrimitive();
        }
    }else{
        gl_Layer = 0;
        for(int i = 0; i < 3; ++i) // for each triangle vertex
        {
            FragPos = COMPAT_POS_IN(i);
            texcoord0 = texcoord[i];
            vColor0 = vColor[i];
            gl_Position = lightMatrices[0] * COMPAT_POS_IN(i);
            EmitVertex();
        }
        EndPrimitive();
    }
} 