//
//  DetailTaskController.m
//  iLoGaVE
//
//  Created by Александр on 02.05.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import "DetailTaskController.h"

@interface DetailTaskController ()
- (IBAction)CompletePressed:(UIButton *)sender;

@end

@implementation DetailTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =[@"Task ID:" stringByAppendingString:self.presentTask.taskID];
    NSString *textForView = [[NSString alloc] init];
    textForView = [[@"Task description:" stringByAppendingString:self.presentTask.taskDescription] stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"Manager ID:"];
    textForView = [textForView stringByAppendingString:self.presentTask.managerID];
    textForView = [textForView stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"Task Address:"];
    textForView = [textForView stringByAppendingString:self.presentTask.taskAddress];
    textForView = [textForView stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"Reciever's name:"];
    textForView = [textForView stringByAppendingString:self.presentTask.name];
    textForView = [textForView stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"Reciever's Surname:"];
    textForView = [textForView stringByAppendingString:self.presentTask.sname];
    textForView = [textForView stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"Reciever's phone:"];
    textForView = [textForView stringByAppendingString:self.presentTask.phone];
    textForView = [textForView stringByAppendingString:@"\n\n"];
    textForView = [textForView stringByAppendingString:@"This task is active"];
    [self.textView setText:textForView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)CompletePressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
