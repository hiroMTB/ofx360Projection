#ifndef PI
#define PI 3.141592653589793
#endif

#ifndef TWO_PI
#define TWO_PI 6.283185307179586
#endif

#ifndef HALF_PI
#define HALF_PI 1.5707963267948966
#endif

//
//  return radian between -PI ~ PI
//
float angle(vec3 v1, vec3 v2, vec3 ref){
    vec3 n1 = normalize(v1);
    vec3 n2 = normalize(v2);

    float ang = acos(dot(n1,n2));
    vec3 c = cross(n1, n2);
    float dir = dot(c, ref);
    if(dir<0){
        ang = -ang;
    }
    return ang;
}

//
//  return radian between 0 ~ PI
//
float angle(vec3 v1, vec3 v2){
    vec3 n1 = normalize(v1);
    vec3 n2 = normalize(v2);
    
    float ang = acos(dot(n1,n2));
    return ang;
}

//
//  360 projection
//
vec4 project360(mat4 mv, vec4 inVec){ //, float clipAngle){
    vec4 p = mv * inVec;
    p.xyz = p.xyz/p.w;
    
    vec3 zAxis = vec3(0,0,1);
    vec3 zAxisInv = vec3(0,0,-1);

    vec3 yAxis = vec3(0,-1,0);
    vec3 yAxisInv = vec3(0,-1,0);
    
    vec3 pXZ = vec3(p.x, 0, p.z);
    float theta = angle(zAxisInv, pXZ, yAxis);
    float delta = angle(yAxisInv, p.xyz);
    
    float x = theta/PI;
    float y = -1.0 + 2.0 * delta/PI;
    float z = 0;
    
    float clipAngle = atan(2.15/7.44);
    float rate = clipAngle/HALF_PI;
    
    if(abs(y)<rate){
        y /= rate;
    }else{
        y = 1.1; // put this outside of screen
    }
    return vec4(x,y,z,1);
}
