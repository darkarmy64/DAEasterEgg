//
//  ViewController.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

@import CoreMotion;

#import "ViewController.h"
#import "DAEasterEggViewController.h"

// Present three kinds of controllers (could be six) considering XY, YZ and ZX
typedef NS_ENUM(NSUInteger, EasterEggController) {
	EasterEggControllerX = 1,
	EasterEggControllerY = 2,
	EasterEggControllerZ = 3,
};

typedef struct EasterEggPosition {
	EasterEggController pos1;
	EasterEggController pos2;
	EasterEggController pos3;
} EasterEggPos_t;

@interface ViewController ()

@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) UILabel *informationLabel;

@end

@implementation ViewController {
	EasterEggPos_t eePos;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 1.0/3.0;
	
	// Test only
//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		DAEasterEggViewController *eevc = [[DAEasterEggViewController alloc] init];
//		[self presentViewController:eevc animated:YES completion:nil];
//	});
	
	_informationLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 20)];
	self.informationLabel.textColor = [UIColor whiteColor];
	self.informationLabel.textAlignment = NSTextAlignmentCenter;
	self.informationLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightThin];
	self.informationLabel.numberOfLines = 0;
	self.informationLabel.text = @"Do a two-axes pan.\n\nXY, YZ or ZX.";
	[self.view addSubview:self.informationLabel];
	
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-20-|" options:0 metrics:nil views:@{@"label": self.informationLabel}]];
	[NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label]-20-|" options:0 metrics:nil views:@{@"label": self.informationLabel}]];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// Start listening to motion
	
	// Set initial positions to zero
	eePos.pos1 = 0;
	eePos.pos2 = 0;
	
	[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		
		if (fabs(accelerometerData.acceleration.x) > 3) {

			if (eePos.pos1 == EasterEggControllerZ) {
				eePos.pos2 = EasterEggControllerX;
				[self presentEasterEggController:EasterEggControllerX];
			}
			else
				eePos.pos1 = EasterEggControllerX;
			
		}
		
		if (fabs(accelerometerData.acceleration.y) > 3) {
			
			if (eePos.pos1 == EasterEggControllerZ) {
				eePos.pos2 = EasterEggControllerY;
				[self presentEasterEggController:EasterEggControllerY];
			}
			else
				eePos.pos1 = EasterEggControllerY;
		}
		
		if (fabs(accelerometerData.acceleration.z) > 3) {
			
			if (eePos.pos1 == EasterEggControllerY) {
				eePos.pos2 = EasterEggControllerZ;
				[self presentEasterEggController:EasterEggControllerZ];
			}
			else
				eePos.pos1 = EasterEggControllerZ;
		}
		
	}];

	
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.motionManager stopAccelerometerUpdates];
}

- (void)presentEasterEggController:(EasterEggController)easterEggController {
	
	[self.motionManager stopAccelerometerUpdates];
	
	DAEasterEggViewController *eevc = [[DAEasterEggViewController alloc] init];
	
	if (easterEggController == EasterEggControllerX)
		eevc.ptype = PresentationTypeXY;
	else if (easterEggController == EasterEggControllerY)
		eevc.ptype = PresentationTypeYZ;
	else if (easterEggController == EasterEggControllerZ)
		eevc.ptype = PresentationTypeZX;
	
	[self presentViewController:eevc animated:YES completion:nil];
	
}

@end
