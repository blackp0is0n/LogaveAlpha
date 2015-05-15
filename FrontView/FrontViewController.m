

#import "FrontViewController.h"
#import "SWRevealViewController.h"


@interface FrontViewController()
@property (strong, nonatomic) UIWindow *window;

- (IBAction)pushExample:(id)sender;


@end

@implementation FrontViewController

#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
    _presentData = [[NSDate alloc] init];
	
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleDone target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem * topRightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButtonPressed:)];
    self.navigationItem.rightBarButtonItem = topRightButton;

    [_mapView removeAnnotations:_mapView.annotations];
    
    [_mapView setDelegate:self];
    OSMTileOverlay *overlay = [[OSMTileOverlay alloc] init];

    [_mapView addOverlay:overlay];
    
    NSDate *presentDate=[[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [format stringFromDate:presentDate];
    
    NSDateFormatter *titleFormat = [[NSDateFormatter alloc] init];
    [titleFormat setDateFormat:@"d MMMM, yyyy"];
    NSString *titleDate = [titleFormat stringFromDate:presentDate];
    
    
    self.title = NSLocalizedString(titleDate, nil);
    NSLog(@"Today is %@\n",today);

    [self createTasksConnection:today key:[self getUserKey]];
    

}

-(void)setAnnotationsToDate:(NSDate*)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *titleFormat = [[NSDateFormatter alloc] init];
    [titleFormat setDateFormat:@"d MMMM, yyyy"];
    NSString *titleDate = [titleFormat stringFromDate:date];
    
    NSString *selectedDate = [format stringFromDate:date];
    self.title = NSLocalizedString(titleDate, nil);
    [self createTasksConnection:selectedDate key:[self getUserKey]];
}

-(void)rightButtonPressed:(id) sender{
    RMDateSelectionViewController *myDatePicker = [RMDateSelectionViewController dateSelectionController];
    [myDatePicker setSelectButtonAction:^(RMDateSelectionViewController *controller, NSDate *date) {
        [self setAnnotationsToDate:date];
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

-(NSString*)fixUnicode:(NSString*)input{
    NSString *convertedString = [input mutableCopy];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [_mapView removeAnnotations:_mapView.annotations];
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
                    NSString *coordinates = json[@"data"][@"task"][i][@"coordinats"];
                    NSString *address = json[@"data"][@"task"][i][@"address"];
                    NSString *taskDescription = json[@"data"][@"task"][i][@"description"];
                    NSString *taskDate = json[@"data"][@"task"][i][@"date"];
                    NSArray *myCoordinates = [coordinates componentsSeparatedByString:@","];
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude =(double) [[myCoordinates objectAtIndex:0] floatValue];
                    coordinate.longitude = (double) [[myCoordinates objectAtIndex:1] floatValue];
                    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                    annotation.coordinate = coordinate;
                    annotation.title = NSLocalizedString(address, @"Title");
                    NSLog(@"%@\n%@\n",taskDate,taskDescription);
                    NSString *mySubtitle = [NSString stringWithFormat:@"%@\nTask date:%@",taskDescription,taskDate];
                    annotation.subtitle = mySubtitle;
                    [self.mapView addAnnotation:annotation];
                }
            } else {
                UIAlertView *errorAlert = [[UIAlertView alloc]
                                           initWithTitle:@"Congratulations" message:@"You have no tasks to selected day." delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
            }
        }
    }
    
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    CustomOverlayView *overlayView = [[CustomOverlayView alloc] initWithOverlay:overlay];
    
    return overlayView;
}



#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
    
}

@end