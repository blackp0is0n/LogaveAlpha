

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TileOverlay.h"
#import "OSMTileOverlay.h"
#import "CustomOverlayView.h"

@interface FrontViewController : UIViewController<MKMapViewDelegate>
    
@property (strong, nonatomic) IBOutlet MKMapView *mapView;



@end