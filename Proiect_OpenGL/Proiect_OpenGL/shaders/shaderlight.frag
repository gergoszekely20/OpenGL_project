//pass-through fragment shader for OpenGL lighting
#version 410 core

uniform vec3 baseColor;

in vec3 color;

out vec4 fColor;

void main()
{	
	fColor = vec4(color, 1.0f);
}
