//
//  Player.m
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Player

-(instancetype)initWithColor:(UIColor *)color {
	self = [super init];

	_color = color;
	return self;
}

@end

NS_ASSUME_NONNULL_END
