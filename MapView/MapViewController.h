

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *myData;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;


@end