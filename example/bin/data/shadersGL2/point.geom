#version 120
#extension GL_EXT_geometry_shader4 : enable
#pragma include "../common.glsl"

void GeneratePoint(vec4 v1)
{
    gl_Position = v1;
    gl_FrontColor = gl_FrontColorIn[0];
    EmitVertex();
}

void main(void)
{
    // Original Vertex
    int i;
    for(i=0; i<gl_VerticesIn; i++){
        vec4 p = project360(gl_ModelViewMatrix, gl_PositionIn[i]);
        GeneratePoint(p);
    }
    
    EndPrimitive();
}
