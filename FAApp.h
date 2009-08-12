//
//  FAApp.h
//  FakeAccel
//
//  Created by Joachim Bengtsson on 2009-08-11.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	Up = 1,
	Down = 2,
	Left = 4,
	Right = 8
} Direction;

@interface FAApp : NSApplication {
	Direction dir;
}
@property Direction dir;
@end
