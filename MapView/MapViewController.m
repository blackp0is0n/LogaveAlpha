

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "DetailTaskController.h"
@implementation MapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	_presentData = [[NSDate alloc] init];
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
    NSString *titleDate = [titleFormat stringFromDate:_presentData];
    
    
    self.title = NSLocalizedString(titleDate, nil);
}



-(void)rightButtonPressed:(id) sender{
    RMDateSelectionViewController *myDatePicker = [RMDateSelectionViewController dateSelectionController];
    [myDatePicker setSelectButtonAction:^(RMDateSelectionViewController *controller, NSDate *date) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"d MMMM, yyyy"];
        NSString *selectedDate = [format stringFromDate:date];
        self.title = NSLocalizedString(selectedDate, nil);
        
        NSLog(@"Successfully selected date: %@", date);
        _presentData  = date;
    }];
    myDatePicker.titleLabel.text = @"Date picker.\n\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    myDatePicker.datePicker.datePickerMode = UIDatePickerModeDate;
    myDatePicker.datePicker.date = _presentData;
    
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
    return [myData count]/2;
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
        
    }
    else if (indexPath.section == 1){
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
        headerTitle = @"Section 1 Header";
    }
    else{
        headerTitle = @"Section 2 Header";
        
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