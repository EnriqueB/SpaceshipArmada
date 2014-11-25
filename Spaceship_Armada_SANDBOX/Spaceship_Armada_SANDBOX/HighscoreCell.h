//
//  HighscoreCell.h
//  Spaceship_Armada_SANDBOX
//
//  Created by UTVINNOVATEAM20 on 11/24/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoreCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imagen;
@property (strong, nonatomic) IBOutlet UILabel *nombreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
