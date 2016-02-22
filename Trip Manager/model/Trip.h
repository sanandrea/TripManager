//
//  Trip.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface Trip : LBModel
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) NSString *startdate;
@property (nonatomic, copy) NSString *enddate;
@property (nonatomic, copy) NSString *comment;
@end
