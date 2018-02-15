#include "ofApp.h"

int main(){
	
	ofGLWindowSettings settings;
	//settings.setGLVersion(3,2);
    settings.setSize(9600/5, 1080/5); // 3840*5 x 2160
	ofCreateWindow(settings);
    
	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp(new ofApp());
}
