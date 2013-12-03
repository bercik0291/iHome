//
//  HomeCell.h
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CheckBoxView.h"
@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CheckBoxView *checkbox;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end
