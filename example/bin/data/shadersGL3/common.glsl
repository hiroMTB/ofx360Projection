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

#ifndef PI
#define PI 3.141592653589793
#endif

#ifndef TWO_PI
#define TWO_PI 6.283185307179586
#endif

#ifndef HALF_PI
#define HALF_PI 1.5707963267948966
#endif
