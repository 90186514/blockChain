//
//  GridCell.m
//  PregnancyHelper
//
//  Created by AaltoChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "GridCell.h"
@interface GridCell()
@property (nonatomic, copy) ActionBlock block;
@end
@implementation GridCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        if(_collectionView)
        {
            [_collectionView removeFromSuperview];
            _collectionView = nil;
        }
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //水平分item，还是竖直分item
        //设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置cell行、列的间距
        [layout setMinimumLineSpacing:0];//row5 -10
        [layout setMinimumInteritemSpacing:0];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, kGridCellHeight) collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gCollectionViewCell"];
        
        [_collectionView setBackgroundColor:kWhiteColor];
        _collectionView.scrollEnabled = NO;
        //如果row = 5
//        _collectionView.scrollEnabled = YES;
//        _collectionView.alwaysBounceHorizontal = YES;
//        _collectionView.showsHorizontalScrollIndicator = YES;
//        _collectionView.contentSize = CGSizeMake(_collectionView.width*5 / 4, 0);
        
        [self.contentView addSubview:_collectionView];
        
    }
    return self;
}

+(CGFloat)cellHeightWithModel{
    return kGridCellHeight;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    GridCell *cell = (GridCell *)[tabelView dequeueReusableCellWithIdentifier:@"GridCell"];
    if (!cell) {
        cell = [[GridCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GridCell"];
    }
    return cell;
}
- (void)richElementsInCellWithModel:(NSArray*)model{
    _data = model;
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    [_collectionView reloadData];
}


#pragma mark --UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _data.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *gCollectionViewCell = @"gCollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:gCollectionViewCell forIndexPath:indexPath];
    
    ////计算图标的中心位置
    float unitCenterWith = collectionView.width  / 3;
    float iconWidth = 44;
    float iconStartPoint = (unitCenterWith - iconWidth) / 2;
    
    if (cell) {
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(iconStartPoint, 15, iconWidth, iconWidth)];
        icon.tag = 7001;
        [icon setBackgroundColor:kClearColor];
        [cell.contentView addSubview:icon];
        
        
        UILabel *title = [[UILabel alloc]initWithFrame :CGRectMake(0, icon.height + icon.origin.y +10, unitCenterWith, 13)];
        title.tag = 7003;
        [title setBackgroundColor:kClearColor];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:kFontSize(13)];
        [title setTextColor:HEXCOLOR(0x202020)];
        [cell.contentView addSubview:title];
    }
    
    NSDictionary *fourPalaceData = [_data objectAtIndex:indexPath.row];
    
    UIImageView *icon=(UIImageView *)[cell.contentView viewWithTag:7001];
    [icon setContentMode:UIViewContentModeScaleAspectFill];
    [icon setClipsToBounds:YES];
//    [icon setImageWithURL:URLFromString(@"icon") placeholderImage:kSQUARE_PLACEDHOLDER_IMG options:SDWebImageRetryFailed];
    [icon setImage:[UIImage imageNamed:fourPalaceData[kImg]]];
    
    
    
    UILabel *title =(UILabel *)[cell.contentView viewWithTag:7003];
    [title setText:fourPalaceData[kArr]];
    return cell;
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *object = [_data objectAtIndex:indexPath.row];
//    if (self.clickGridRowBlock) {
//        self.clickGridRowBlock(object);
//    }
    if (self.block) {
        self.block(object);
    }
}

//返回这个UICollectionViewCell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / 3, kGridCellHeight/2);
}
@end


