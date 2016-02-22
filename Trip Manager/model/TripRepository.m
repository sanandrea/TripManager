//
//  TripRepository.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "TripRepository.h"

@implementation TripRepository
+ (instancetype)repository {
    return [self repositoryWithClassName:@"trip"];
}
@end
