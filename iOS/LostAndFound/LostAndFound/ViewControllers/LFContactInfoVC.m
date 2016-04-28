//
//  LFContactInfoVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/30.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFContactInfoVC.h"

@interface LFContactInfoVC ()

@property(nonatomic, strong) LFUser *evUser;

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@end

@implementation LFContactInfoVC

- (instancetype)initWithTitle:(NSString *)title contactInfo:(LFUser *)contactInfo;{
    
    self = [super init];
    if (self) {
        
        [self setTitle:title];
    
        [self setEvUser:contactInfo];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] addSubview:[self evtbvContainer]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 0, 0)];
    
    [self _efReloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (LFUser *)evUser{

    if (!_evUser) {
        
        _evUser = [LFUser model];
    }
    return _evUser;
}

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _evtbvContainer;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)_efReloadData{
    
    NSMutableArray *etSectionModels = [NSMutableArray array];
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = [[XLFNormalCellModel alloc] initWithTitle:[[self evUser] salutation]];
    [etCellModels addObject:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    [etSectionModel setEvHeaderTitle:@"姓名"];
    [etSectionModel setEvHeaderViewHeight:60];
    
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:[[[self evUser] telephone] secretTelephone]];
    [etCellModel setEvblcModelCallBack:[self _efTelephoneCellCallback]];
    [etCellModel setEvAccessoryImage:[UIImage imageNamed:@"icon_dial_phone"]];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDetailButton];
    [etCellModels addObject:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    [etSectionModel setEvHeaderTitle:@"电话"];
    [etSectionModel setEvHeaderViewHeight:60];
    
    [etSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etSectionModels];
}

- (void (^)(XLFNormalCellModel* model))_efTelephoneCellCallback{
    
    return ^(XLFNormalCellModel* model){
        
        [XLFCommonUtils dialPhoneNumber:[[self evUser] telephone] enableBack:YES];
    };
}

@end
