

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "DetailTaskController.h"
@implementation MapViewController

int activeTasks = 0;
int nonActiveTaks = 0;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _tasksArray = [[NSMutableArray alloc] init];
	[super viewDidLoad];
	_presentDate = [[NSDate alloc] init];
	self.title = NSLocalizedString(@"Tasks", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleDone target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
    
    UIBarButtonItem * topRightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = topRightButton;
    
    NSDateFormatter *titleFormat = [[NSDateFormatter alloc] init];
    [titleFormat setDateFormat:@"d MMMM, yyyy"];
    NSString *titleDate = [titleFormat stringFromDate:_presentDate];
    
    
    self.title = NSLocalizedString(titleDate, nil);
}


-(void)createTasksConnection:(NSString*)date key:(NSString*)key{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        URLWithString:@"http://api.logave.com/task/gettask?"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@&date=%@",key,date];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection){
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Connection Error" message:@"Server not available now." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    } else {
        _receivedData = [[NSMutableData data] init];
    }
}


-(void)setUserKey:(NSString *)userKey{
    _userKey = userKey;
}
-(NSString*)getUserKey{
    return _userKey;
}


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
    if (_receivedData!=nil) {
        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&e];
        NSLog(@"%@",json);
        NSLog(@"Key is:%@\nBurn MF",[self getUserKey]);
        NSString *answer = json[@"status_message"];
        NSString *task = json[@"data"][@"task"];
        [self setUserKey:json[@"data"][@"key"]];
        if([answer isEqual:@"OK"]){
            [self setUserKey:json[@"data"][@"key"]];
            if (![task isEqual:@"No tasks"]) {
                int i = 0;
                for(i = 0;i<[json[@"data"][@"task"] count];i++){
                    NSString *tID = json[@"data"][@"task"][i][@"id"];
                    NSString *mID = json[@"data"][@"task"][i][@"manager_id"];
                    NSString *courID = json[@"data"][@"task"][i][@"courier_id"];
                    NSString *getName = json[@"data"][@"task"][i][@"name"];
                    NSString *getSName = json[@"data"][@"task"][i][@"sname"];
                    NSString *getPhone = json[@"data"][@"task"][i][@"phone"];
                    NSString *tIsActive = json[@"data"][@"task"][i][@"active"];
                    NSString *address = json[@"data"][@"task"][i][@"address"];
                    NSString *taskDescription = json[@"data"][@"task"][i][@"description"];
                    NSString *taskDate = json[@"data"][@"task"][i][@"date"];
                    Task *myTask = [[Task alloc] init];
                    myTask.taskID = tID;
                    myTask.managerID = mID;
                    myTask.taskDescription = taskDescription;
                    myTask.taskAddress = address;
                    myTask.courierID = courID;
                    myTask.name = getName;
                    myTask.sname = getSName;
                    myTask.phone = getPhone;
                    if([tIsActive isEqualToString:@"1"]){
                        myTask.taskIsActive = @"YES";
                        activeTasks++;
                    } else {
                        myTask.taskIsActive = @"NO";
                        nonActiveTaks++;
                    }
                    myTask.date = taskDate;
                    [_tasksArray addObject:myTask];
                }
            } else {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Congratulations" message:@"You have no tasks to selected day." delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
            }
        }
    }
    
}


-(void)rightButtonPressed:(id) sender{
    RMDateSelectionViewController *myDatePicker = [RMDateSelectionViewController dateSelectionController];
    [myDatePicker setSelectButtonAction:^(RMDateSelectionViewController *controller, NSDate *date) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"d MMMM, yyyy"];
        NSString *selectedDate = [format stringFromDate:date];
        self.title = NSLocalizedString(selectedDate, nil);
        
        NSLog(@"Successfully selected date: %@", date);
        _presentDate  = date;
    }];
    myDatePicker.titleLabel.text = @"Date picker.\n\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    myDatePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    myDatePicker.datePicker.date = _presentDate;
    
    myDatePicker.disableBouncingWhenShowing = true;
    myDatePicker.disableMotionEffects = false;
    myDatePicker.disableBlurEffects = true;
    
    /* [myDatePicker setCancelButtonAction:^(RMDateSelectionViewController *controller) {
     NSLog(@"Date selection was canceled");
     }];*/
    [self presentViewController:myDatePicker animated:YES completion:nil];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    if(section == 0){
        return activeTasks;
    } else {
        return nonActiveTaks;
    }
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;
    if (indexPath.section == 0) {
        stringForCell= [myData objectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 1){
        stringForCell= [myData objectAtIndex:indexPath.row+ [myData count]/2];
        
    }
    [cell.textLabel setText:stringForCell];
    return cell;
}

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section{
    NSString *headerTitle;
    if (section==0) {
        headerTitle = @"Active tasks";
    }
    else{
        headerTitle = @"Non-active Tasks";
        
    }
    return headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section{

    return nil;
}

#pragma mark - TableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Section:%ld Row:%ld selected and its data is %@",
          (long)indexPath.section,(long)indexPath.row,cell.textLabel.text);
    DetailTaskController *stubController = [[DetailTaskController alloc] init];
    stubController.title = @"Task details";
    stubController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:stubController animated:YES];
}
- (IBAction)pushhh:(UIButton *)sender {
    myData = [[NSMutableArray alloc]initWithObjects:
              @"Data 1 in array",@"Data 2 in array",@"Data 3 in array",
              @"Data 4 in array",@"Data 5 in array",@"Data 5 in array",
              @"Data 6 in array",@"Data 7 in array",@"Data 8 in array",
              @"Data 9 in array", nil];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.myTableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.myTableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self.myTableView reloadData];
}
@end