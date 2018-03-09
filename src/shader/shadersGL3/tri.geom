#version 150
#pragma include "../common.glsl"

layout (triangles) in;
layout (triangle_strip) out;
layout (max_vertices = 12) out;

uniform mat4 modelViewMatrix;
uniform float clipAngle;

in vec4 vColor[];

out vec4 Color;

void GenerateTriangle(vec4 v1, vec4 v2, vec4 v3, vec4 c)
{
    gl_Position = v1;
    Color = c;
    EmitVertex();

    gl_Position = v2;
    Color = c;
    EmitVertex();
    
    gl_Position = v3;
    Color = c;
    EmitVertex();
    
    EndPrimitive();
}

void main(void)
{
    // Original Vertex
    vec4 iP0 = gl_in[0].gl_Position;
    vec4 iP1 = gl_in[1].gl_Position;
    vec4 iP2 = gl_in[2].gl_Position;
    
    
    {
        vec4 p0 = modelViewMatrix * iP0;
        vec4 p1 = modelViewMatrix * iP1;
        vec4 p2 = modelViewMatrix * iP2;
        
        vec4 test01 = intersect_SP(p0.xyz, p1.xyz, vec3(0,1,1), vec3(1,0,0));
        if(test01.w == 1 && test01.z>0){
            return;
        }

        vec4 test12 = intersect_SP(p1.xyz, p2.xyz, vec3(0,1,1), vec3(1,0,0));
        if(test12.w == 1 && test12.z>0){
            return;
        }

        vec4 test20 = intersect_SP(p2.xyz, p0.xyz, vec3(0,1,1), vec3(1,0,0));
        if(test20.w == 1 && test20.z>0){
            return;
        }
    }
    
    
    // original Color
    vec4 c0 = vColor[0];
    vec4 c1 = vColor[1];
    vec4 c2 = vColor[2];    

    vec4 P0 = (iP0 + iP1) * 0.5;
    vec4 P1 = (iP1 + iP2) * 0.5;
    vec4 P2 = (iP2 + iP0) * 0.5;
    
    iP0 = project360(modelViewMatrix, iP0);
    iP1 = project360(modelViewMatrix, iP1);
    iP2 = project360(modelViewMatrix, iP2);
    P0  = project360(modelViewMatrix, P0);
    P1  = project360(modelViewMatrix, P1);
    P2  = project360(modelViewMatrix, P2);
    
    GenerateTriangle(iP0, iP1, iP2, c0);
    
    //GenerateTriangle(P0, P1, P2, c0);
    //GenerateTriangle(iP0, P0, P2, c0);
    //GenerateTriangle(iP1, P1, P0, c0);
    //GenerateTriangle(iP2, P2, P1, c0);
}
