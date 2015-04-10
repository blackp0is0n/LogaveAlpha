//
//  LoginViewController.h
//  Logave
//
//  Created by Александр on 01.04.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@class SWRevealViewController;

@interface LoginViewController : UIViewController

@property (strong,nonatomic)NSMutableData *receivedData;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (weak, nonatomic) IBOutlet UIButton *loginPressed;
@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
- (IBAction)loginKeyboardHiding:(UITextField *)sender;
- (IBAction)passwordKeyboardHiding:(UITextField *)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

- (IBAction)loginTouchedUp:(UIButton *)sender;


@end
