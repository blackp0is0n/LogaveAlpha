

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
    
	self.title = NSLocalizedString(@"Map with Tasks", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStyleDone target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    
    [_mapView setDelegate:self];
    OSMTileOverlay *overlay = [[OSMTileOverlay alloc] init];

    [_mapView addOverlay:overlay];
    
    

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 22.569722;
    coordinate.longitude = 88.369722;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = NSLocalizedString(@"You are here", @"Title");
    annotation.subtitle = @"Hello, motherfucker!";
    [self.mapView addAnnotation:annotation];
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