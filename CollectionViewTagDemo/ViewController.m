//
//  ViewController.m
//  CollectionViewTagDemo
//
//  Created by linjianguo on 2018/7/4.
//  Copyright © 2018年 com.justsee. All rights reserved.
//

#import "ViewController.h"
#import "ZYFCollectionHeaderLayout.h"
#import "DCFeatureItemCell.h"
#import "DCFeatureList.h"
#import "DCFeatureItem.h"
#import "DCFeatureHeaderView.h"
#import <MJExtension.h>
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HorizontalCollectionLayoutDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray <DCFeatureItem *> *featureAttr;
@end

static NSString *const DCFeatureHeaderViewID = @"DCFeatureHeaderView";

static NSString *const DCFeatureItemCellID = @"DCFeatureItemCell";

@implementation ViewController

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        ZYFCollectionHeaderLayout *layout = [[ZYFCollectionHeaderLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = self.view.bounds;
        //
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = 10.0;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, 10.0, 0, 10.0);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[DCFeatureItemCell class] forCellWithReuseIdentifier:DCFeatureItemCellID];//cell
        [_collectionView registerClass:[DCFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID]; //头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"]; //尾部
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    _featureAttr = [DCFeatureItem mj_objectArrayWithFilename:@"ShopItem.plist"]; //数据
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _featureAttr[section].list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DCFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCFeatureItemCellID forIndexPath:indexPath];
    cell.content = _featureAttr[indexPath.section].list[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind  isEqualToString:UICollectionElementKindSectionHeader]) {
        DCFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCFeatureHeaderViewID forIndexPath:indexPath];
        headerView.headTitle = _featureAttr[indexPath.section].attr;
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor redColor];
        return footerView;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    //限制每组内的Item只能选中一个(加入质数选择)
    if (_featureAttr[indexPath.section].list[indexPath.row].isSelect == NO) {
        for (NSInteger j = 0; j < _featureAttr[indexPath.section].list.count; j++) {
            _featureAttr[indexPath.section].list[j].isSelect = NO;
        }
    }
    _featureAttr[indexPath.section].list[indexPath.row].isSelect = !_featureAttr[indexPath.section].list[indexPath.row].isSelect;


    //section，item 循环讲选中的所有Item加入数组中 ，数组mutableCopy初始化
    _seleArray = [@[] mutableCopy];
    for (NSInteger i = 0; i < _featureAttr.count; i++) {
        for (NSInteger j = 0; j < _featureAttr[i].list.count; j++) {
            if (_featureAttr[i].list[j].isSelect == YES) {
                [_seleArray addObject:_featureAttr[i].list[j].infoname];
            }else{
                [_seleArray removeObject:_featureAttr[i].list[j].infoname];
                //[_lastSeleArray removeAllObjects];
            }
        }
    }
    
    for (NSString *str  in _seleArray) {
        NSLog(@"%@",str);
    }

    //刷新tableView和collectionView
    [self.collectionView reloadData];
}


#pragma mark - <HorizontalCollectionLayoutDelegate>
#pragma mark - 自定义layout必须实现的方法
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    return _featureAttr[indexPath.section].list[indexPath.row].infoname;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
