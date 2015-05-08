//
//  Task.h
//  iLoGaVE
//
//  Created by Александр on 08.05.15.
//  Copyright (c) 2015 BSUIR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong,nonatomic)NSString* taskDescription;
@property (strong,nonatomic)NSString* taskID;
@property (strong,nonatomic)NSString* managerID;
@property (strong,nonatomic)NSString* taskAddress;
@property (strong,nonatomic)NSString* taskActive;
@property (strong,nonatomic)NSString* name;
@property (strong,nonatomic)NSString* sname;
@property (strong,nonatomic)NSString* phone;
@property (strong,nonatomic)NSString* date;



@end
