#version 150
#pragma include "common.glsl"

layout (points) in;
layout (points) out;
layout (max_vertices = 1) out;

uniform mat4 modelViewMatrix;

in vec4 vColor[];

out vec4 Color;


void main(void)
{
    int i;
    for(i=0; i<gl_in.length(); i++){
        
        vec4 inVec = gl_in[i].gl_Position;
        vec4 p = modelViewMatrix * inVec;
        p.xyz = p.xyz/p.w;
        
        vec3 zAxis = vec3(0,0,1);
        vec3 pXZ = vec3(p.x, 0, p.z);
        float theta = angle(zAxis, pXZ, vec3(0,1,0));
        
        float x = theta/PI;
        
        vec4 outVec = vec4(x,0.5,0,1);
        
        gl_Position = outVec;
        
        Color = vColor[i];
        EmitVertex();
    }
    
    EndPrimitive();
}
