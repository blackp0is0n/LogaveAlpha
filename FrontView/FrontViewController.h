

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TileOverlay.h"
#import "OSMTileOverlay.h"
#import "CustomOverlayView.h"
#import "RMDateSelectionViewController.h"

@interface FrontViewController : UIViewController<MKMapViewDelegate>{
    
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)NSString *userKey;
@property (strong,nonatomic)NSMutableData *receivedData;
@property (strong,nonatomic) NSDate *presentData;
@property (strong,nonatomic)UIDatePicker *datePicker;
@property(strong,nonatomic)RMDateSelectionViewController *myDatePicker;


-(void)setUserKey:(NSString *)userKey;
-(NSString*)getUserKey;
@end