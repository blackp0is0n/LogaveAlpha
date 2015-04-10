

#import "RearViewController.h"

#import "SWRevealViewController.h"


@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

- (void)viewDidLoad
{
	[super viewDidLoad];
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Rear Controller was loaded" message:@"You are awesome!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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



@end