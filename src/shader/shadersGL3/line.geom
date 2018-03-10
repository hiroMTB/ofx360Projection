#version 150
#pragma include "../common.glsl"
layout (lines) in;
layout (line_strip) out;
layout (max_vertices = 128) out;

uniform mat4 modelViewMatrix;
uniform float clipAngle;

in vec4 vColor[];

out vec4 Color;

void main(void)
{
    float sub = 100;
    vec4 p0 = gl_in[0].gl_Position;
    vec4 p1 = gl_in[1].gl_Position;
    vec4 dir = (p1 - p0) / sub;
    
    {
        vec4 v0 = modelViewMatrix * p0;
        vec4 v1 = modelViewMatrix * p1;
        
        vec4 test01 = intersect_SP(v0.xyz, v1.xyz, vec3(0,1,1), vec3(1,0,0));
        if(test01.w == 1 && test01.z>0){
            return;
        }
    }
        
    int i;
    for(i=0; i<sub; i++){
        gl_Position = project360(modelViewMatrix, p0 + dir * i);
        Color = vColor[0];
        EmitVertex();
    }
    
    EndPrimitive();
}
