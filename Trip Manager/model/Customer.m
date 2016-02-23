//
//  Customer.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "Customer.h"

@implementation Customer

@end

@interface CustomerRepository()
@property (nonatomic, readwrite) Customer *cachedCurrentCustomer;

@end

@implementation CustomerRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"customers"];
}


@end