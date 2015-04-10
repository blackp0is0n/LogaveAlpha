

#import "MapViewController.h"
#import "SWRevealViewController.h"

@implementation MapViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Tasks", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleDone target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}


@end