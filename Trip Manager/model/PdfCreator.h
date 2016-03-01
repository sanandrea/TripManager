//
//  PdfCreator.h
//  Trip Manager
//
//  Created by Andi Palo on 29/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
@interface PdfCreator : NSObject

- (void) createPdfWithName:(NSString*)name;
- (void) printTrip:(Trip*) trip;
- (void) endFile;

- (void)drawLabelsForTrip:(Trip*)trip;
@end
