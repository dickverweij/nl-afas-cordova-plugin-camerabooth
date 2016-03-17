/*
The MIT License (MIT)

Copyright (c) 2016 Dick Verweij dickydick1969@hotmail.com, d.verweij@afas.nl

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

#import "CameraBoothViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>

@implementation CameraBoothViewController

@synthesize label,cameraView,imageView,completion;


- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}

- (void)takePicture:(AVCaptureStillImageOutput *)stillImageOutput {
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         [self->pictures addObject:[imageData base64EncodedStringWithOptions: NSDataBase64Encoding64CharacterLineLength]];
     }];
}

- (void)countDown: (NSString *) labelText completion: (void (^)()) completionCall
{
    label.alpha = 0;
    label.transform = CGAffineTransformMakeScale(0.2, 0.2);
    label.text = labelText;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         label.alpha = 1;
                         label.transform = CGAffineTransformMakeScale(1.0, 1.0);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              label.alpha = 0;}
                          completion:^(BOOL finished) {
                              completionCall();
                          }];
                     
                     }];
}

- (void)viewDidAppear:(BOOL)animated{
         
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.cameraView.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [self frontCamera];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    AVCaptureStillImageOutput * stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
    [session startRunning];
    
	self->pictures = [NSMutableArray arrayWithCapacity: self.numberOfPicturesToTake];

    [self countDown: @"3" completion:^() {
        [self countDown: @"2" completion:^() {
            [self countDown: @"1" completion:^() {
				for (int currentPicture = 0; currentPicture < self.numberOfPicturesToTake; currentPicture++) {
					[self takePicture:stillImageOutput];
				}
                
				[session stopRunning];
				[captureVideoPreviewLayer removeFromSuperlayer];
				self.completion(self->pictures);
            }];
        }];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
