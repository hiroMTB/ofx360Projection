#ifndef OFX_360_PROJECTION_H
#define OFX_360_PROJECTION_H

#include "ofMain.h"

namespace ofx360projection{

    enum class ShaderType{
        POINT_SHADER,
        LINE_SHADER,
        TRIANGLE_SHADER
    };

class ofx360Projection{
    
public:
    
    ofx360Projection(){};
    
    bool setup(){
#ifdef TARGET_OPENGLES
        static_assert(1, "ofx360Projection does not support openGL ES");
#else

        int maxOut = triShader.getGeometryMaxOutputCount();
        
        pointShader.setGeometryInputType(GL_POINTS);
        pointShader.setGeometryOutputType(GL_POINTS);
        pointShader.setGeometryOutputCount(1);

        lineShader.setGeometryInputType(GL_LINES);
        lineShader.setGeometryOutputType(GL_LINE_STRIP);
        lineShader.setGeometryOutputCount(128);

        triShader.setGeometryInputType(GL_TRIANGLES);
        triShader.setGeometryOutputType(GL_TRIANGLES);
        triShader.setGeometryOutputCount(3*4);
        
        filesystem::path path;
        if(ofIsGLProgrammableRenderer()){
            path = filesystem::path("../../../../../addons/ofx360Projection/src/shader/shadersGL3");
        }else{
            path = filesystem::path("../../../../../addons/ofx360Projection/src/shader/shadersGL2");
        }
        
        pointShader.load(path/"pass.vert", path/"pass.frag", path/"point.geom");
        lineShader.load(path/"pass.vert", path/"pass.frag", path/"line.geom");
        triShader.load(path/"pass.vert", path/"pass.frag", path/"tri.geom");
        
        return pointShader.isLoaded() && lineShader.isLoaded() && triShader.isLoaded();
#endif
    }
    
    void begin(ShaderType type){

        // radian
        float clipAngle = atan(ofGetHeight()/ofGetWidth());
        
        
        cam.begin();
        switch(type){
            case ShaderType::POINT_SHADER:
                pointShader.begin();
                pointShader.setUniform1f("clipAngle", clipAngle);
                break;
            
            case ShaderType::LINE_SHADER:
                lineShader.begin();
                lineShader.setUniform1f("clipAngle", clipAngle);
                break;
            
            case ShaderType::TRIANGLE_SHADER:
                triShader.begin();
                triShader.setUniform1f("clipAngle", clipAngle);
                break;

            default:
                static_assert(1, "ofx360Projection : Unsupported GL primitive");
                break;
        }
    }
    
    void end(ShaderType type){
        switch(type){
            case ShaderType::POINT_SHADER:
                pointShader.end();
                break;

            case ShaderType::LINE_SHADER:
                lineShader.end();
                break;

            case ShaderType::TRIANGLE_SHADER:
                triShader.end();
            break;

            default:
                static_assert(1, "ofx360Projection : Unsupported GL primitive");
                break;
        }
        cam.end();
    }

    ofCamera & getCamera(){
        return cam;
    }
    
    void setClipPlane(glm::vec4 p){
        clipPlane = p;
    }
    
    glm::vec4 getClipPlane(){
        return clipPlane;
    }
    
    private:
        ofShader pointShader;
        ofShader lineShader;
        ofShader triShader;
    
        ofCamera cam;
        glm::vec4 clipPlane;
};
} // namespace ofx360projection
#endif /* OFX_360_PROJECTION_H */
