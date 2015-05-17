//
//  DetailTaskController.h
//  iLoGaVE
//
//  Created by Александр on 02.05.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"
#import "MapViewController.h"

@interface DetailTaskController : ViewController
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *completeTaskButton;
@property (strong,nonatomic)Task *presentTask;
@property (strong,nonatomic)MapViewController *controller;
@property (strong,nonatomic)NSMutableData *receivedData;
@end
