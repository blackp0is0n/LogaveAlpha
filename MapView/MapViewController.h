

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface MapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *myData;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)pushhh:(UIButton *)sender;
@property (strong,nonatomic) NSDate *presentData;
@end