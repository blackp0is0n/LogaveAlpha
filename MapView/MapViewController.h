

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"

@interface MapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *myData;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)pushhh:(UIButton *)sender;
@property (strong,nonatomic) NSDate *presentDate;
@property (strong,nonatomic)NSMutableData *receivedData;
@property(nonatomic,strong)NSString *userKey;
@property(nonatomic,strong)NSMutableArray *activeTasksArray;
@property(nonatomic,strong)NSMutableArray *nonActiveTasksArray;

-(void)setAnnotationsToDate:(NSDate*)date;
@end