//
//  TripRepository.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface TripRepository : LBModelRepository
+ (instancetype)repository;
@end
