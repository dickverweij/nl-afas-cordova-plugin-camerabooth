/*
The MIT License (MIT)

Copyright (c) 2015 Dick Verweij dickydick1969@hotmail.com, d.verweij@afas.nl

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
#import "CameraBooth.h"
#import <Cordova/CDV.h>


@implementation CameraBooth


- (void) start:(CDVInvokedUrlCommand*)command {
    CameraBoothViewController * vc = [[CameraBoothViewController alloc] init];
    vc.storyboard = [UIStoryboard storyboardWithName:@"CameraBooth" bundle:nil];

	vc.numberOfPicturesToTake = [command.arguments[0] intValue];
	if (vc.numberOfPicturesToTake < 1 || vc.numberOfPicturesToTake > 9) {
		vc.numberOfPicturesToTake = 1;
	}

	vc.completion = ^(NSString * base64Data){
			CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK message:base64Data];
			[pluginResult setKeepCallback: [NSNumber numberWithBool:NO]];
			[self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
		};

	[self.viewController presentViewController: vc  animated:YES completion:nil];
	
	CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
    [pluginResult setKeepCallback: [NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
    
}


@end
