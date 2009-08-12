//
//  FakeAccelAppDelegate.h
//  FakeAccel
//
//  Created by Joachim Bengtsson on 2009-08-11.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

typedef enum {
	FAInputMethodSMS,
	FAInputMethodKeys,
	
	FAInputMethodMax
} FAInputMethod;

@interface FakeAccelAppDelegate : NSObject {
    NSWindow *window;
		IBOutlet NSTextField *x, *y, *z;
		FAInputMethod inputMethod;
		AsyncSocket *socket;
		NSMutableArray *sockets;
}

-(IBAction)changeInputMethod:(NSSegmentedControl*)sender;

@property (assign) IBOutlet NSWindow *window;
@property FAInputMethod inputMethod;

@property float rx;
@property float ry;
@property float rz;

@end
