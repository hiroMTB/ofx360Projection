#include "ofApp.h"

int main(){
	
	ofGLWindowSettings settings;
	settings.setGLVersion(3,2);
    float w = 3840*5;
    float h = 2160;
    settings.setSize(w/10, h/10); // 3840*5 x 2160
	ofCreateWindow(settings);
    
	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp(new ofApp());
}
