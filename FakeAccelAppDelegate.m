//
//  FakeAccelAppDelegate.m
//  FakeAccel
//
//  Created by Joachim Bengtsson on 2009-08-11.
//  Copyright 2009 Third Cog Software. All rights reserved.
//

#import "FakeAccelAppDelegate.h"
#import "FAApp.h"

@implementation FakeAccelAppDelegate

@synthesize window, inputMethod;

+(void)initialize;
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:FAInputMethodSMS] forKey:@"inputMethod"]
	];
}
-(void)dealloc;
{
	self.window = nil;
	[super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.inputMethod = [[NSUserDefaults standardUserDefaults] integerForKey:@"inputMethod"];
	[NSTimer scheduledTimerWithTimeInterval:1./10. target:self selector:@selector(pollDirection) userInfo:nil repeats:YES];
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	sockets = [[NSMutableArray alloc] init];
	NSError *err;
	[socket acceptOnPort:24638 error:&err];
	if(err) [NSApp presentError:err];

}

-(IBAction)changeInputMethod:(NSSegmentedControl*)sender;
{
	self.inputMethod = (FAInputMethod)[sender selectedSegment];
}

-(void)pollDirection;
{
	switch (inputMethod) {
		case FAInputMethodSMS:;
			NSTask *smsTask = [[[NSTask alloc] init] autorelease];
			NSPipe *pipe = [NSPipe pipe];
			smsTask.launchPath = [[NSBundle mainBundle] pathForResource:@"AMSTracker" ofType:nil];
			smsTask.standardOutput = pipe;
			[smsTask launch];
			[smsTask waitUntilExit];
			
			NSFileHandle *file = [pipe fileHandleForReading];
			NSData *data = [file readDataToEndOfFile];
			
			NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSArray *lines = [output componentsSeparatedByString:@"\n"];
			NSString *second = [lines objectAtIndex:1];
			NSArray *xyz = [second componentsSeparatedByString:@" "];
			int set = 0;
			for (NSString *s in xyz) {
				if([@"" isEqual:s]) continue;
				if(set == 0)
					self.rx = [s floatValue]/127.;
				else if (set == 1)
					self.ry = [s floatValue]/127.;
				else 
					self.rz = [s floatValue]/127.;
				set++;
			}
			
			break;
		
		case FAInputMethodKeys:;
			Direction dir = [(FAApp*)NSApp dir];
			self.rx = (dir&Left) ? 1 : ((dir&Right) ? -1 : 0);
			self.rz = (dir&Down) ? 1 : ((dir&Up) ? -1 : 0);
			break;
		default:
			break;
	}
	
	for (AsyncSocket *sock in sockets) {
		NSString *xyz2 = [NSString stringWithFormat:@"%f\t%f\t%f\n", self.rx, self.ry, self.rz];
		NSData *xyz2d = [xyz2 dataUsingEncoding:NSUTF8StringEncoding];
		[sock writeData:xyz2d withTimeout:1.0 tag:0];
	}
	
}

-(float)rx;
{
	return [x floatValue];
}
-(float)ry;
{
	return [y floatValue];
}
-(float)rz;
{
	return [z floatValue];
}
-(void)setRx:(float)_;
{
	[x setFloatValue:_];
}
-(void)setRy:(float)_;
{
	[y setFloatValue:_];
}
-(void)setRz:(float)_;
{
	[z setFloatValue:_];
}

#pragma mark 
#pragma mark Socket
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket;
{
	[sockets addObject:newSocket];
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock;
{
	[sockets removeObject: sock];
}

@end
