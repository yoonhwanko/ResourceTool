//
//  ColorViewController.m
//  TabController_08_1
//
//  Created by Nick on 3/24/10.
//  Copyright 2010 Nick Vellios. All rights reserved.
//
//	http://www.Vellios.com
//	nick@vellios.com
//
//	This code is released under the "Take a kid fishing or hunting license"
//	In order to use any code in your project you must take a kid fishing or
//	hunting and give some sort of credit to the author of the code either
//	on your product's website, about box, or legal agreement.
//

#import "ColorViewController.h"


@implementation ColorViewController

@synthesize color;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	self.view.backgroundColor = self.color;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)setColorFromName:(NSString *)colorName
{
	self.title = [colorName capitalizedString];
	NSString *lowercaseColorName = [colorName lowercaseString];
	NSString *selectorName = [lowercaseColorName stringByAppendingString:@"Color"];
	SEL selector = NSSelectorFromString(selectorName);
	UIColor *myColor = [UIColor blackColor];
	
	if([UIColor respondsToSelector:selector])
	{
		myColor = [UIColor performSelector:selector];
	}
	
	self.color = myColor;
}

- (void)setColor:(UIColor *)aColor
{
	if(color != aColor)
	{
		[color release];
		color = [aColor retain];
		self.view.backgroundColor = color;
		[self.view setNeedsDisplay];
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
