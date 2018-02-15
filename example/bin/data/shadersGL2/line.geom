#version 120
#extension GL_EXT_geometry_shader4 : enable
#pragma include "../common.glsl"

void main(void)
{
    float sub = 100;

    vec4 p0 = gl_PositionIn[0];
    vec4 p1 = gl_PositionIn[1];
    vec4 dir = (p1 - p0) / sub;

    int i;
    for(i=0; i<sub; i++){
        vec4 ep = project360(gl_ModelViewMatrix, p0 + dir * i);
        gl_Position = ep;
        gl_FrontColor = gl_FrontColorIn[0];
        EmitVertex();
    }

    EndPrimitive();
}
