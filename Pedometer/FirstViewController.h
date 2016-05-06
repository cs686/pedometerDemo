//
//  FirstViewController.h
//  Pedometer
//
//  Created by Takeshi Bingo on 2013/08/03.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccelerometerFilter.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FirstViewController : UIViewController<UIAccelerometerDelegate, MFMailComposeViewControllerDelegate>

@end
