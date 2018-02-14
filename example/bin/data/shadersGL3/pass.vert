#version 150

in vec4 position;
in vec4 color;
in vec3 normal;

out vec4 vColor;

void main(){
    gl_Position = position;
    vColor = color;
}