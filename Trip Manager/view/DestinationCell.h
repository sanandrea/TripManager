//
//  DestinationCell.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataProvider.h"

@interface DestinationCell : UITableViewCell<CellDataProvider>
@property (strong, nonatomic) IBOutlet UILabel *destination;
@property (strong, nonatomic) IBOutlet UITextField *destinationValue;
@end
