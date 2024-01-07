//vertex shader for ambient, diffuse and specular lighting
#version 410 core

layout(location=0) in vec3 vPosition;
layout(location=1) in vec3 vNormal;

//matrices
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform mat3 normalMatrix;

//lighting
uniform vec3 lightDir;
uniform vec3 lightColor;
uniform vec3 baseColor;

out vec3 color;

vec3 ambient;
float ambientStrength = 0.2f;
vec3 diffuse;
vec3 specular;
float specularStrength = 0.5f;
float shininess = 32.0f;

void main()
{		
	//compute ambient light
	ambient = ambientStrength * lightColor;
	
	//normalize the light's direction
	vec3 lightDirN = normalize(lightDir);

	//compute eye coordinates for normals (transform normals)
	vec3 normalEye = normalize(normalMatrix * vNormal);

	//compute diffuse light
	diffuse = max(dot(normalEye, lightDirN), 0.0f) * lightColor;
	
	//compute the vertex position in eye coordinates
	vec4 vertPosEye = view * model * vec4(vPosition, 1.0f);

	//compute the view (Eye) direction (in eye coordinates, the camera is at the origin)
	vec3 viewDir = normalize(- vertPosEye.xyz);

	//compute the light's reflection (the reflect function requires a direction pointing towards the vertex, not away from it)
	vec3 reflectDir = normalize(reflect(-lightDir, normalEye));

	//compute specular light
	float specCoeff = pow(max(dot(viewDir, reflectDir), 0.0f), shininess);
	specular = specularStrength * specCoeff * lightColor;

	//compute final vertex color
	color = min((ambient + diffuse) * baseColor + specular, 1.0f);

	//transform vertex
	gl_Position = projection * view * model * vec4(vPosition, 1.0f);
}
