in vec2 position;
in vec2 uv;
out vec2 texcoord;
flat out int idx; 

struct IndexUniforms {
	int fragUniformIndex; 
	int vertexUniformIndex;
	int palLayer; 
	int texLayer;
};

struct VertexUniforms {
	mat4 modelview;
	mat4 projection;
}; 

layout (std140) uniform IndexUniformBlock {
    uvec4 indexMask[1024];
};

layout (std140) uniform VertexUniformBlock {
    VertexUniforms vertexUniforms[32]; 
};

void main(void) {
	int uniformBlockIndex = gl_VertexID / 4;
	int uniformElementIndex = gl_VertexID % 4; 

	uint packedIndex = indexMask[uniformBlockIndex][uniformElementIndex]; 
	uint vertexUniformIndex = packedIndex & uint(0x1F);                 

    mat4 modelview = vertexUniforms[vertexUniformIndex].modelview;
    mat4 projection = vertexUniforms[vertexUniformIndex].projection;

	texcoord = uv;
	idx = gl_VertexID;
	gl_Position = projection * (modelview * vec4(position, 0.0, 1.0));
}