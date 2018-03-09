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
    
    return acos(dot(n1,n2));
}

//
//  min1 - max1 : input range
//  min2 - max2 : output range
//
float map(float value, float min1, float max1, float min2, float max2){
    float perc = (value - min1) / (max1 - min1);
    return value = perc * (max2 - min2) + min2;
}

//
//  find intersection of a segment and a plane
//
//  input
//  s0, s1 = segment
//  v, n = plane
//
//  output vec4 ret;
//  ret.w = 0 -> no intersection
//  ret.w = 1 -> found intersection
//  ret.w = 2 -> segment is in plane
//  http://geomalgorithms.com/a05-_intersect-1.html
vec4 intersect_SP(vec3 s0, vec3 s1, vec3 v, vec3 n){
   
    vec4 ret;
    
    vec3 u = s1 - s0;
    vec3 w = s0 - v;
    
    float D = dot(n, u);
    float N = -dot(n, w);
    
    float SMALL_NUM = 0.00001;  // ??
    
    if (abs(D) < SMALL_NUM) {
        // segment is parallel to plane
        if (N == 0){
            // segment lies in plane
            ret.w = 2;
        }else{
            // no intersection
            ret.w = 0;
        }
        return ret;
    }
    
    float sI = N / D;
    if (sI < 0 || sI > 1){
        // no intersection
        ret.w = 0;
        return ret;
    }
    
    // compute segment intersect point
    ret.xyz = s0 + sI * u;
    ret.w = 1;
    return ret;
}


//
//  360 projection
//
vec4 project360(mat4 mv, vec4 inVec){ //, float clipAngle){
    vec4 p = mv * inVec;
    p.xyz = p.xyz/p.w;
    
    vec3 zAxisInv = vec3(0,0,-1);

    vec3 yAxisInv = vec3(0,-1,0);

    // X calc
    vec3 pXZ = vec3(p.x, 0, p.z);
    float theta = angle(zAxisInv, pXZ, yAxisInv);
    float x = theta/PI;

    // Y calc
    float delta = angle(yAxisInv, p.xyz);
    float clipAngle = atan(2.15/7.44);  // TODO This should be passed by uniform
    float y = map(delta-HALF_PI, -clipAngle, clipAngle, -1, 1);
    
    // Z calc
    float farClip = 10000.0;    // TODO This should be passed by uniform
    float nearClip = 3.72;      // TODO This should be passed by uniform
    float z = map(length(p.xz), nearClip, farClip, -1, 1);

    return vec4(x,y,z,1);
}
