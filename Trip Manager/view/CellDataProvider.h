//
//  CellDataProvider.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@protocol CellDataProvider <NSObject>
- (NSDictionary*) getKeyValueCouple;
- (void) customizeWithData:(Trip*) trip;
@end
