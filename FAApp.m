//
//  FAApp.m
//  FakeAccel
//
//  Created by Joachim Bengtsson on 2009-08-11.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "FAApp.h"

#define setOrUnset(en) {if(down) dir |= en; else dir &= ~en;}

@implementation FAApp
@synthesize dir;
- (void)sendEvent:(NSEvent *)evt 
{ 
	BOOL forward = NO;
	if(NSKeyDown == [evt type] || NSKeyUp == [evt type])  {
		BOOL down = NSKeyDown == [evt type];
		NSString *chars = [evt charactersIgnoringModifiers];

		for(int i = 0; i < [chars length]; i++) {
			unichar chr = [chars characterAtIndex:i];
			if(NSUpArrowFunctionKey == chr)
				setOrUnset(Up)
			else if(NSDownArrowFunctionKey == chr)
				setOrUnset(Down)
			else if(NSLeftArrowFunctionKey == chr)
				setOrUnset(Left)
			else if(NSRightArrowFunctionKey == chr)
				setOrUnset(Right)
			else
				forward = YES;
		}
		NSLog(@"%d", dir);
	} else
		forward = YES;
	
	if(forward)
		[super sendEvent:evt];
		
} 

@end
