#pragma once

#include "ofMain.h"
#include "ofx360Projection.h"
#include "ofxGui.h"

using namespace ofx360projection;
using namespace glm;

class ofApp: public ofBaseApp{
	public:
		void setup();
		void update();
		void draw();
		
        void begin(ShaderType type);
        void end(ShaderType type);
        
        ofx360Projection proj;
    
        ofEasyCam normalCam;
    
        ofxPanel gui;
        ofxLabel fps;
        ofParameterGroup prm;
        ofParameter<bool> bEqui;
        ofParameter<bool> bDraw2dGuide;
        ofParameter<bool> bDraw3dGuide;
        ofParameter<bool> bDrawPoints;
        ofParameter<bool> bDrawLines;
        ofParameter<bool> bDrawTriangles;
        ofParameter<float> shereAngle;
    
        ofParameter<glm::vec3> objPos;
        ofParameter<float> objScale;
        
        ofVboMesh vboPoints;
        ofVboMesh vboLines;

        ofCylinderPrimitive cylinder;
};
