//
//  TCFakeAccelerometer.h
//  StervoxyTanks
//
//  Created by Joachim Bengtsson on 2009-08-12.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface TCFakeAccelerometer : NSObject {
	id <UIAccelerometerDelegate> delegate;
	AsyncSocket *socket;
	NSTimeInterval updateInterval;
}
+(TCFakeAccelerometer*)sharedAccelerometer;
@property(nonatomic,assign) id<UIAccelerometerDelegate> delegate;
@property NSTimeInterval updateInterval;
@end

/*

You could do this in your app:
#import "TCFakeAccelerometer.h"
#if TARGET_IPHONE_SIMULATOR
#	define AppAccelerometer TCFakeAccelerometer
#else
#	define AppAccelerometer UIAccelerometer
#endif

and then use AppAccelerometer instead of UIAccelerometer in your code.

*/