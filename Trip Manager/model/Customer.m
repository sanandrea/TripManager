//
//  Customer.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "Customer.h"

@implementation Customer


-(void) findRole{
#warning TODO
    self.role = kUserRoleDefault;
    
}

@end

@interface CustomerRepository()
@property (nonatomic, readwrite) Customer *cachedCurrentCustomer;

@end

@implementation CustomerRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"customers"];
}
- (SLRESTContract *)contract {
    SLRESTContract *contract = [super contract];
    
    [contract addItem:[SLRESTContractItem itemWithPattern:[NSString stringWithFormat:@"/%@/:id/trips", self.className] verb:@"GET"]
            forMethod:[NSString stringWithFormat:@"%@.trip-list", self.className]];
    
    
    return contract;
}

@end