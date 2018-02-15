#version 120
#extension GL_EXT_geometry_shader4 : enable
#pragma include "../common.glsl"

void GenerateTriangle(vec4 v1, vec4 v2, vec4 v3)
{
    gl_Position = v1;
    gl_FrontColor = gl_FrontColorIn[0];
    EmitVertex();

    gl_Position = v2;
    gl_FrontColor = gl_FrontColorIn[0];
    EmitVertex();
    
    gl_Position = v3;
    gl_FrontColor = gl_FrontColorIn[0];
    EmitVertex();
    
    EndPrimitive();
}

void main(void)
{
    // Original Vertex
    vec4 iP0 = gl_PositionIn[0];
    vec4 iP1 = gl_PositionIn[1];
    vec4 iP2 = gl_PositionIn[2];
    
    vec4 P0 = (iP0 + iP1) * 0.5;
    vec4 P1 = (iP1 + iP2) * 0.5;
    vec4 P2 = (iP2 + iP0) * 0.5;
    
    iP0 = project360(gl_ModelViewMatrix, iP0);
    iP1 = project360(gl_ModelViewMatrix, iP1);
    iP2 = project360(gl_ModelViewMatrix, iP2);
    P0 = project360(gl_ModelViewMatrix, P0);
    P1 = project360(gl_ModelViewMatrix, P1);
    P2 = project360(gl_ModelViewMatrix, P2);
    
    GenerateTriangle(P0, P1, P2);
    GenerateTriangle(iP0, P0, P2);
    GenerateTriangle(iP1, P1, P0);
    GenerateTriangle(iP2, P2, P1);
}
