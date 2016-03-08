//
//  Player.h
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Player : NSObject

- (instancetype)initWithColor:(UIColor *)color;

@property (nonatomic) UIColor *color;
@property (nonatomic) NSInteger score;

@end

NS_ASSUME_NONNULL_END
