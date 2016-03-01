//
//  Trip.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "Trip.h"

@implementation Trip


-(void)test{
    
}
@end

@implementation TripRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"trips"];
}

- (SLRESTContract *)contract {
    SLRESTContract *contract = [super contract];
    
    [contract addItem:[SLRESTContractItem itemWithPattern:[NSString stringWithFormat:@"/%@", self.className] verb:@"GET"]
            forMethod:[NSString stringWithFormat:@"%@.list-all", self.className]];
    
    return contract;
}
@end