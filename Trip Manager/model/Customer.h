//
//  Customer.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "APConstants.h"

@interface Customer : LBUser

@property (nonatomic, copy) NSArray* trips;

@end


@interface CustomerRepository : LBUserRepository
+ (instancetype)repository;
@end