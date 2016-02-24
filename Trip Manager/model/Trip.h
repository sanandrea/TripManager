//
//  Trip.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface Trip : LBPersistedModel
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSDate *startdate;
@property (nonatomic, copy) NSDate *enddate;
@property (nonatomic, copy) NSString *comment;
@end

@interface TripRepository : LBPersistedModelRepository
+ (instancetype)repository;
@end