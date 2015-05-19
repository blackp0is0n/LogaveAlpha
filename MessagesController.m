//
//  MessagesController.m
//  Logave
//
//  Created by Александр on 02.04.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import "MessagesController.h"
#import "SWRevealViewController.h"

@interface MessagesController ()

@end

@implementation MessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Messages", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleDone target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *newMessageButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = newMessageButtonItem;
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.myTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Find this motherfucker";
    
    self.myTableView.tableHeaderView = _searchBar;
}

-(void)createMessagesConnection:(NSString*)date key:(NSString*)key{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        URLWithString:@"http://api.logave.com/mail/gettask?"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@&date=%@",key,date];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection){
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Connection Error" message:@"Server not available now." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    } else {
        _receivedData = [[NSMutableData data] init];
    }
}


- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTable{
    [_refreshControl endRefreshing];
    [self.myTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
