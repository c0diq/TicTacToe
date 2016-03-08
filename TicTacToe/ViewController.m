//
//  ViewController.m
//  TicTacToe
//
//  Created by Sylvain Rebaud on 3/3/16.
//  Copyright © 2016 Plutinosoft. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"
#import "Player.h"
#import "UILabel+AutoAdjustFont.h"

NS_ASSUME_NONNULL_BEGIN

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *turnIndicatorPlayer1;
@property (weak, nonatomic) IBOutlet UIView *turnIndicatorPlayer2;

@property (weak, nonatomic) IBOutlet UILabel *scorePlayer1;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayer2;

@property (nonatomic) NSUInteger curBoardSize;
@property (nonatomic) Game *game;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.game = [[Game alloc] init];

	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

	// Inverse Player1 label
	self.scorePlayer1.transform = CGAffineTransformMakeRotation(degreesToRadian(180));
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self updateScores];
	[self updatePlayerTurnIndicator];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.game.boardSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.game.boardSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	CALayer *layer = [cell.contentView.layer.sublayers lastObject];
	if (layer != NULL) [layer removeFromSuperlayer];

	layer = [[CAShapeLayer alloc] init];
	layer.frame = cell.bounds;
	layer.delegate = self;
	[layer setValue:indexPath forKey:@"indexPath"];

	[cell.contentView.layer addSublayer:layer];
	[layer setNeedsDisplay];

	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	CGFloat width = collectionView.frame.size.width / self.game.boardSize;
	return (CGSize){ .width = width, .height = width};
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	return [self.game playerAtIndexPath:indexPath] == nil && self.game.numberEmptyPositions > 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	Player *player = [self.game playerAtIndexPath:indexPath];
	if (player == nil) {
		BOOL result = [self.game playAtIndexPath:indexPath];

		// on win, reset board, incrementing it according to sequence 3, 4, 5, 3, 4, 5
		if (result || self.game.numberEmptyPositions == 0) {
			[self.collectionView reloadData];

			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[self updateScores];

				self.game.boardSize = (((self.game.boardSize - 3) + 1) % 3) + 3;

				[self updatePlayerTurnIndicator];

				[self.collectionView reloadData];
			});
		} else {
			[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
		}

		[self updatePlayerTurnIndicator];
	}
}

- (void)updatePlayerTurnIndicator {
	self.turnIndicatorPlayer1.hidden = self.game.curPlayer == self.game.player2;
	self.turnIndicatorPlayer2.hidden = self.game.curPlayer == self.game.player1;
}

- (void)updateScores {
	self.scorePlayer1.text = [NSString stringWithFormat:@"%ld", (long)self.game.player1.score];
	self.scorePlayer2.text = [NSString stringWithFormat:@"%ld", (long)self.game.player2.score];

	[self adjustTextFontForLabel:self.scorePlayer1];
	[self adjustTextFontForLabel:self.scorePlayer2];
}

- (void)adjustTextFontForLabel:(UILabel *)label {
	NSUInteger optimalFontSize = [label fontSizeWithMinFontSize:5 withMaxFontSize:200];
	if (optimalFontSize > 0) {
		label.font = [UIFont fontWithName:label.font.fontName size:optimalFontSize];
	}
}

#pragma mark - CALayerDelegate

- (void)displayLayer:(CAShapeLayer *)layer {
	NSIndexPath *indexPath = [layer valueForKey:@"indexPath"];
	if (indexPath == NULL) return;

	CGRect circleRect = CGRectInset(layer.frame, 10 ,10);
	layer.path = [[UIBezierPath bezierPathWithOvalInRect:circleRect] CGPath];

	Player *player = [self.game playerAtIndexPath:indexPath];
	UIColor *color = player ? player.color : UIColor.grayColor;
	layer.strokeColor = [color CGColor];

	NSArray<NSIndexPath *> *winningPositions = [self.game winningPositions];
	if (winningPositions && [winningPositions containsObject:indexPath]) {
		layer.fillColor = [color CGColor];
	} else {
		layer.fillColor = [UIColor.clearColor CGColor];
	}
}

#pragma mark - Private

-(void)adjustFontToFitCurrentLabel:(UILabel *)label {

	CGSize iHave = label.frame.size;

	BOOL isContained = NO;
	do {
		CGSize iWant = [label.text sizeWithAttributes:@{ NSFontAttributeName: label.font.fontName }];
		if (iWant.width > iHave.width || iWant.height > iHave.height){
			label.font = [UIFont fontWithName:label.font.fontName size:label.font.pointSize - 0.1];
			isContained = NO;
		}else{
			isContained = YES;
		}

	} while (isContained == NO);
}

@end

NS_ASSUME_NONNULL_END

