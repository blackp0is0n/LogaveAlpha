

#import "RearViewController.h"

#import "SWRevealViewController.h"


@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;


-(void)setUserKey:(NSString *)userKey{
    _userKey = userKey;
}
-(NSString*)getUserKey{
    return _userKey;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Rear Controller was loaded" message:[NSString stringWithFormat:@"You are awesome!\nYour key:%@",[self getUserKey]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    self.navigationItem.title = @"Logave";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = YES;
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSInteger row = indexPath.row;
    
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    NSString *text = nil;
	if (row == 0)
	{
		text = @"Map with Tasks Controller";
	}
	else if (row == 1)
	{
        text = @"Tasks Controller";
	}
	else if (row == 2)
	{
		text = @"Messages";
	}
    else if (row == 3){
        text = @"Log Out";
    }
    else if (row == 4){
        text = @"Test row";
    }
    
    cell.textLabel.text = NSLocalizedString( text, nil );
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SWRevealViewController *revealController = self.revealViewController;
    NSInteger row = indexPath.row;

    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }

    UIViewController *newFrontController = nil;
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        URLWithString:@"http://api.logave.com/task/gettask?"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@", [self getUserKey]];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    if (connection) {
        _receivedData = [[NSMutableData data] init];
    }
    
    if (row == 0)
    {
        if (_frontViewController == nil)
            _frontViewController = [[FrontViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:_frontViewController];
    }
    else if (row == 1)
    {
        if(_mapViewController == nil)
            _mapViewController = [[MapViewController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:_mapViewController];
    }
    
    else if ( row == 2 )
    {
        if(_messagesController == nil)
            _messagesController = [[MessagesController alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:_messagesController];
    }
    else if( row == 3){
        _messagesController = nil;
        _mapViewController = nil;
        _frontViewController = nil;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = self.loginViewController;
        
        [self.window makeKeyAndVisible];
    } else if(row == 4){
        //if(_viewController == nil){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Простой alert" message:@"Это простой UIAlertView, он просто показывает сообщение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        //}
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    _presentedRow = row; 
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
    
}

@end