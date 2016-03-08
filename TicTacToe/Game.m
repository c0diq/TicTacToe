//
//  Game.m
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/5/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import "Game.h"
#import "Player_Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game ()

@property (nonatomic) NSUInteger numberEmptyPositions;
@property (nonatomic) NSMutableArray<NSMutableArray *> *board;
@property (nonatomic, nullable) NSArray<NSIndexPath *> *winningPositions;
@property (nonatomic, readwrite) Player *curPlayer;

@end

@implementation Game

- (instancetype)init {
	self = [super init];

	_player1 = [[Player alloc] initWithColor:[UIColor blueColor]];
	_player2 = [[Player alloc] initWithColor:[UIColor redColor]];
	_curPlayer = _player1;

	self.boardSize = 3;

	return self;
}

- (void)setBoardSize:(NSUInteger)boardSize {
	NSParameterAssert(boardSize >= 3);

	_boardSize = boardSize;

	// Create a matrix filled with NSNulls
	self.board = [NSMutableArray arrayWithCapacity:boardSize];
	for (int i=0; i<boardSize; i++) {
		NSMutableArray *row = [NSMutableArray arrayWithCapacity:boardSize];
		for (int j=0; j<boardSize; j++) {
			[row addObject:NSNull.null];
		}

		[self.board addObject:row];
	}

	self.numberEmptyPositions = boardSize * boardSize;
	self.winningPositions = nil;
}

- (void)resetScores {
	self.player1.score = 0;
	self.player2.score = 0;
}

- (nullable Player *)playerAtIndexPath:(NSIndexPath *)indexPath {
	NSAssert(indexPath.section >=0 && indexPath.section < self.boardSize, @"Invalid indexPath: %@", indexPath);
	NSAssert(indexPath.item >= 0 && indexPath.item < self.boardSize, @"Invalid indexPath: %@", indexPath);

	id user = self.board[indexPath.item][indexPath.section];
	return [user isKindOfClass:NSNull.class] ? nil : (Player *)user;
}

- (BOOL)playAtIndexPath:(NSIndexPath *)indexPath {
	NSArray<NSIndexPath *> *result = [self setPlayer:self.curPlayer atIndexPath:indexPath];

	// decrement number of empty slots regardless of result
	--self.numberEmptyPositions;

	// swap current player if play is not a win
	if (result != nil) {
		NSLog(@"Winner Player %@!", self.curPlayer == self.player1 ? @"1" : @"2");

		// track winning positions
		self.winningPositions = result;

		// Increment score
		++self.curPlayer.score;
		NSLog(@"Player 1: %ld | Player 2: %ld", (long)self.player1.score, (long)self.player2.score);
	}

	self.curPlayer = (self.curPlayer == self.player1) ? self.player2 : self.player1;

	return (result != nil);
}

- (NSArray<NSIndexPath *> *)setPlayer:(Player *)player atIndexPath:(NSIndexPath *)indexPath {
	// Verify no one is occupying that spot
	NSParameterAssert([self playerAtIndexPath:indexPath] == nil);

	[self.board[indexPath.item] replaceObjectAtIndex:indexPath.section withObject:player];

	return [self isWinnerAtIndexPath:indexPath];
}

- (nullable NSIndexPath *)indexPathForItem:(NSInteger)item inSection:(NSInteger)section {
	if (item < 0 || item >= self.boardSize) return nil;
	if (section < 0 || section >= self.boardSize) return nil;

	return [NSIndexPath indexPathForItem:item inSection:section];
}

- (NSArray<NSIndexPath *> *)isWinnerAtIndexPath:(NSIndexPath *)indexPath {
	Player *player = [self playerAtIndexPath:indexPath];
	NSParameterAssert(player != nil);

	NSMutableArray *winningPositions = [NSMutableArray array];

	// Check horizontally first
	// Check left of current position
	for (NSInteger section = indexPath.section; section >= 0; section--) {
		NSIndexPath *position = [self indexPathForItem:indexPath.item inSection:section];
		if (![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	// Check right of current position
	for (NSInteger section = indexPath.section + 1; section < self.boardSize; section++) {
		NSIndexPath *position = [self indexPathForItem:indexPath.item inSection:section];
		if (![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	if (winningPositions.count == self.boardSize) return winningPositions;


	// Check Vertically
	[winningPositions removeAllObjects];
	// Check up from current position
	for (NSInteger row = indexPath.item; row >= 0; row--) {
		NSIndexPath *position = [self indexPathForItem:row inSection:indexPath.section];
		if (![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	// Check down from current position
	for (NSInteger row = indexPath.item + 1; row < self.boardSize; row++) {
		NSIndexPath *position = [self indexPathForItem:row inSection:indexPath.section];
		if (![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	if (winningPositions.count == self.boardSize) return winningPositions;

	// Check Diagonally
	[winningPositions removeAllObjects];
	// Check diagonally left/up from current position
	for (NSInteger i = indexPath.section; i >= 0; i--) {
		NSIndexPath *position = [self indexPathForItem:i inSection:i];
		if (position == nil || ![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	// Check diagonally bottom/down from current position
	for (NSInteger i = indexPath.section + 1; i < self.boardSize; i++) {
		NSIndexPath *position = [self indexPathForItem:i inSection:i];
		if (position == nil || ![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	if (winningPositions.count == self.boardSize) return winningPositions;

	[winningPositions removeAllObjects];
	// Check diagonally left/down from current position
	for (NSInteger i = 0; indexPath.section+i >= 0 && indexPath.item-i < self.boardSize; i--) {
		NSIndexPath *position = [self indexPathForItem:indexPath.item-i inSection:indexPath.section+i];
		if (position == nil || ![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	// Check diagonally right/up from current position
	for (NSInteger i = 1; indexPath.section+i < self.boardSize && indexPath.item-i >= 0; i++) {
		NSIndexPath *position = [self indexPathForItem:indexPath.item-i inSection:indexPath.section+i];
		if (position == nil || ![player isEqual:[self playerAtIndexPath:position]]) break;
		[winningPositions addObject:position];
	}
	if (winningPositions.count == self.boardSize) return winningPositions;

	return nil;
}

@end

NS_ASSUME_NONNULL_END
