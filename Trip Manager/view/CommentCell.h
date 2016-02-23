//
//  CommentCell.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDataProvider.h"
@interface CommentCell : UITableViewCell<CellDataProvider>
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UITextField *commentValue;
@end
