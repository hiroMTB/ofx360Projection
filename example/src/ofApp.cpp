#include "ofApp.h"

using namespace glm;

void ofApp::setup(){
    ofBackground(0);
    ofSetColor(255);
    ofSetCircleResolution(50);
    
    proj.setup();
    proj.getCamera().setPosition(0,0,0);
    proj.getCamera().setNearClip(100);
    proj.getCamera().setFarClip(10000);
    
    normalCam.setNearClip(0.01);
    normalCam.setFarClip(1000);
    normalCam.setDistance(50);
    //normalCam.disableMouseInput();
    
    gui.setup();
    prm.add(bEqui.set("360 Projection", false));
    prm.add(shereAngle.set("shereAngle", 0, -PI, PI));
    prm.add(bDraw2dGuide.set("Draw 2D Guide", true));
    prm.add(bDraw3dGuide.set("Draw 3D Guide", false));
    prm.add(bDrawPoints.set("Draw Points", true));
    prm.add(bDrawLines.set("Draw Lines", false));
    prm.add(bDrawTriangles.set("Draw Triangles", true));

    prm.add(objPos.set("Object Position", vec3(0,0,-3.72), vec3(-20,-20,-20), vec3(20,20,20)));
    prm.add(objScale.set("Object Scale", 1, 0, 10.0));
    gui.add(fps.setup("fps", "0"));
    gui.add(prm);
    gui.add(btnSaveScreen.setup("save screen"));
    btnSaveScreen.addListener(this, &ofApp::saveScreen);
    
    vboPoints.setMode(OF_PRIMITIVE_POINTS);
    for(int i=0; i<1000; i++){
        float deg = ofRandom(0, 360);
        float x = cos(ofDegToRad(deg));
        float z = sin(ofDegToRad(deg));
        vec3 v(x, 0, z);
        vec3 yAxis(0,1,0);
        vec3 axis = glm::cross(v, yAxis);
        float deg2 = ofRandom(-180, 180);
        vec3 v2 = glm::rotate(v, ofDegToRad(deg2), axis);
        float dist = ofRandom(1,11);
        v2 *= dist;
        vboPoints.addVertex(v2);

        float r = ofMap(v2.x, -30, 30, 0, 1);
        float g = ofMap(v2.y, -30, 30, 0, 1);
        float b = ofMap(v2.z, -30, 30, 0, 1);        
        ofFloatColor c(r, g, b);
        vboPoints.addColor(c);
    }
    
//    vboLines.setMode(OF_PRIMITIVE_LINES);
//    for(int i=0; i<100; i++){
//        vboLines.addColor(ofColor(255,255,255));
//        vboLines.addVertex(vec3(ofRandom(-2,2), ofRandom(-2,2), ofRandom(-2,2)));
//    }    
    
    float cd = 7.44;
    float ch = 2.15;
    float clipAngle = atan(cd/ch);
    
    cylinder.setUseVbo(true);
    cylinder.setRadius(3.72);
    cylinder.setHeight(2.15);
    cylinder.setCapped(false);
    cylinder.setResolutionRadius(16);
    cylinder.setResolutionHeight(3);
    cylinder.setResolutionCap(1);
    cylinder.setPosition(0, 0, 0);
    //cylinder.setOrientation(ofVec3f(90,0,0));
    vector<vec3> & vs = cylinder.getMesh().getVertices();
    for(int i=0; i<vs.size(); i++){
        cylinder.getMesh().addColor(ofFloatColor(1,1,1,0.3));
    }
}

void ofApp::update(){
    fps = ofToString(ofGetFrameRate());
}

void ofApp::begin(ShaderType type){
    ofPushMatrix();
    bEqui ? proj.begin(type) : normalCam.begin();
    ofDrawAxis(1);
    //ofTranslate(objPos);
    //ofScale(objScale, objScale, objScale);
}

void ofApp::end(ShaderType type){
    bEqui ? proj.end(type) : normalCam.end();
    ofPopMatrix();
}

void ofApp::draw(){

    ofBackground(150);
        
    if(bDrawPoints){
        glPointSize(3);
        begin(ShaderType::POINT_SHADER);
        ofSetColor(255);
        glColor4f(255,0,0,255);
        vboPoints.draw();
        cylinder.getMesh().setMode(OF_PRIMITIVE_POINTS);
        cylinder.draw(OF_MESH_POINTS);
        end(ShaderType::POINT_SHADER);
    }

    if(bDrawLines){
        begin(ShaderType::LINE_SHADER);
        ofSetColor(255);
        vboLines.draw();
        
        ofDrawBox(objPos, 1);
        if(bDraw3dGuide){
            ofNoFill();
            ofSetColor(0,0,255);
        }
        end(ShaderType::LINE_SHADER);
    }
    
    if(bDrawTriangles){
        begin(ShaderType::TRIANGLE_SHADER);
        ofSetColor(255,0,0);
        cylinder.getMesh().setMode(OF_PRIMITIVE_TRIANGLE_STRIP);
        cylinder.drawWireframe();
        
        float x = 10.0 * cos(shereAngle);
        float z = 10.0 * sin(shereAngle);
        ofPushMatrix();
        ofTranslate(x, 0, z);
        // ofDrawSphere(0, 0, 0.5);
        ofPopMatrix();

        end(ShaderType::TRIANGLE_SHADER);
    }    
    
    if(bDraw2dGuide){
        ofPushMatrix();
        ofSetupScreenOrtho();
        ofTranslate(0,0);
        ofSetColor(0,255,0);
        ofNoFill();
        float w4 = ofGetWidth()/4;
        float h  = ofGetHeight();
        ofDrawLine(w4*1, 0, w4*1, h);
        ofDrawLine(w4*2, 0, w4*2, h);
        ofDrawLine(w4*3, 0, w4*3, h);
        ofPopMatrix();
    }

    ofSetupScreenOrtho();
    ofDisableDepthTest();
    gui.draw();
}

void ofApp::saveScreen(){
    
    ofSaveScreen("screenshot.png");
    
}
