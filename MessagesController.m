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
    
    UIBarButtonItem *newMessageButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    self.navigationItem.rightBarButtonItem = newMessageButtonItem;
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.myTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    _tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:_tap];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Find this motherfucker";
    
    self.myTableView.tableHeaderView = _searchBar;
    
    [self createMessagesConnection:[self getUserKey]];
    //[self.view addSubview:self.noTasksLabel];
    
    if (self.noMessages == nil){
        self.noMessages = [[UILabel alloc] init];
        [self.noMessages setText:@"No tasks for this Day"];
        [self.noMessages setTextColor:[UIColor grayColor]];
        self.noMessages.frame = CGRectMake((float)(self.view.frame.size.width/2-80), 70.0f, 160.0f, 30.0f);
        NSLog(@"Width is:%f",self.view.frame.size.width);
        //[self.view addSubview:self.noMessages];
    }
    _inboxArray = [[NSMutableArray alloc] init];
}

-(void)setUserKey:(NSString *)userKey{
    _userKey = userKey;
}
-(NSString*)getUserKey{
    return _userKey;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Please, check your Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


-(void)createMessagesConnection:(NSString*)key{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        URLWithString:@"http://api.logave.com/mail/getinbox?"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    NSString * param = [NSString stringWithFormat:@"key=%@",key];
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

-(void) updateSections {
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.myTableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.myTableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@",json);
    if (_receivedData!=nil) {

        NSLog(@"Key is:%@\nBurn MF",[self getUserKey]);
        NSString *answer = json[@"status_message"];
        [_inboxArray removeAllObjects];
        NSString *messageName= json[@"data"][@"data"];
        [self setUserKey:json[@"data"][@"key"]];
        
        if([answer isEqual:@"OK"]){
            [self setUserKey:json[@"data"][@"key"]];
            if (![messageName isEqual:@"No messages"]) {
                [self.noMessages setHidden:YES];
                [self.myTableView setHidden:NO];
                for(int i = 0;i<[json[@"data"][@"data"] count];i++){
                    NSString *message = json[@"data"][@"data"][i][@"message"];
                    NSString *topic = json[@"data"][@"data"][i][@"topic"];
                    NSString *sname = json[@"data"][@"data"][i][@"sname"];
                    NSString *ID = json[@"data"][@"data"][i][@"id"];
                    NSString *name = json[@"data"][@"data"][i][@"name"];
                    NSString *date = json[@"data"][@"data"][i][@"date"];
                    Message *myMessage = [[Message alloc] init];
                    myMessage.message = message;
                    myMessage.topic = topic;
                    myMessage.senderID = ID;
                    myMessage.senderName = name;
                    myMessage.senderSName = sname;
                    myMessage.date = date;
                    [_inboxArray addObject:myMessage];
                }
            } else {
                [_inboxArray removeAllObjects];
                [self.myTableView setHidden:YES];
                [self.noMessages setHidden:NO];
            }
            [self updateSections];
        }
    }
    
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
    [self.view removeGestureRecognizer:_tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTable{
    [_refreshControl endRefreshing];
    [self updateSections];
    [self.myTableView reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return _inboxArray.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *stringForCell;
    NSString *detailText;

    if (indexPath.section == 0) {
        stringForCell = @"Show outbox";
        
    } else if (indexPath.section == 1){
        Message *message = [_inboxArray objectAtIndex:indexPath.row];
        stringForCell = message.topic;
        
        detailText = [[message.senderSName stringByAppendingString:@" "] stringByAppendingString:message.senderName];
    }
    
    
    [cell.textLabel setText:stringForCell];
    if(indexPath.section != 0){
        [cell.detailTextLabel setTextColor:[UIColor grayColor]];
        [cell.detailTextLabel setText:detailText];
    }
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section{
    if(section == 0){
        return @"Inbox";
    }else {
        return nil;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {

        Message *myMesssage = [_inboxArray objectAtIndex:indexPath.row];
        NSString *title = [[myMesssage.senderName stringByAppendingString:@" "] stringByAppendingString:myMesssage.senderSName];
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:title message:myMesssage.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
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
