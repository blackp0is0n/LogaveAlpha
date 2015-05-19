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
    if([self.presentTask.taskIsActive isEqualToString:@"YES"]){
        textForView = [textForView stringByAppendingString:@"This task is active"];
    } else {
        textForView = [textForView stringByAppendingString:@"This task is not active"];
    }
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


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Please, check your Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:nil];
    NSString *myStatus = json[@"data"][@"data"];
    NSLog(@"%@",json);
    if ([myStatus isEqual:@"status changed"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.controller createTasksConnection:self.presentTask.date key:self.presentTask.key];
        [self.controller updateSections];
        
    }

}


- (IBAction)CompletePressed:(UIButton *)sender {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        URLWithString:@"http://api.logave.com/task/changetask?"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@&task=%@&status=1", self.presentTask.key,self.presentTask.taskID];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (connection)
        _receivedData = [[NSMutableData data] init];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
