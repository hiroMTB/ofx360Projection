#version 150
#pragma include "../common.glsl"

layout (points) in;
layout (points) out;
layout (max_vertices = 1) out;

uniform mat4 modelViewMatrix;
uniform float clipAngle;

in vec4 vColor[];

out vec4 Color;

void main(void){
    int i;
    for(i=0; i<gl_in.length(); i++){
        gl_Position = project360(modelViewMatrix, gl_in[i].gl_Position);
        Color = vColor[i];
        EmitVertex();
    }
    
    EndPrimitive();
}
