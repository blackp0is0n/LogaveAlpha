//
//  MessagesController.h
//  Logave
//
//  Created by Александр on 02.04.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesController : UIViewController<UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic)UIRefreshControl *refreshControl;
@property (strong,nonatomic)UISearchBar *searchBar;

@property (strong,nonatomic)NSMutableData *receivedData;
@property(nonatomic,strong)NSString *userKey;
@property(nonatomic,strong)NSMutableArray *inboxArray;
@property(nonatomic,strong)NSMutableArray *outboxArray;
@end
