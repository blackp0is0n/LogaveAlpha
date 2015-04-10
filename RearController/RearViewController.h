

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "FrontViewController.h"
#import "MapViewController.h"
#import "MessagesController.h"


@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;

@property (nonatomic,strong)MessagesController *messagesController;
@property (nonatomic,strong)MapViewController *mapViewController;
@property (nonatomic,strong)FrontViewController *frontViewController;


@end