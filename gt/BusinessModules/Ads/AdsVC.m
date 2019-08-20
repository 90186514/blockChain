//
//  AdsVC.m
//  gtp
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AdsVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "PageVC.h"
#import "PostAdsVC.h"
#import "InputPWPopUpView.h"
#import "PageVM.h"
#import "ModifyAdsModel.h"
#import "ModifyAdsVC.h"

#import "LoginModel.h"
#import "IdentityAuthVC.h"
@interface AdsVC ()<UITextFieldDelegate>
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic, strong) PageVM *vm;
@property (nonatomic,strong)NSMutableArray *contents;
@property (nonatomic,strong)UITextField * tf1;
@end

@implementation AdsVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    AdsVC *vc = [[AdsVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //}
    //-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
    //{
    if (textField == self.tf1) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 9)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"我的广告";
    NSArray* titles = @[@{@"全部":@"0"},
                        @{@"上架中":@"1"},
                        @{@"售罄":@"3"},
                        @{@"已下架":@"2"}
                        ];
  
    _tabs=[[NSMutableArray alloc]initWithCapacity:titles.count];
    _contents=[[NSMutableArray alloc]initWithCapacity:titles.count];
    

    for(int i=0;i<titles.count;i++){
        NSDictionary *dic=titles[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = kFontSize(14);
        tab.text = dic.allKeys[0];
        tab.textColor=[UIColor blackColor];
        [_tabs addObject:tab];
        
        PageVC *con=[PageVC new];
        
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag = dic.allValues[0];
        [_contents addObject:con];
        [con actionBlock:^(id data, id data2,UIView* view,UITableView* tableView,NSMutableArray *dataSource,NSIndexPath* indexPath) {
            EnumActionTag sec = [data integerValue];
            ModifyAdsModel* model = data2;
            switch (sec) {
                case EnumActionTag0:
                {
                    [PostAdsVC pushFromVC:self requestParams:model success:^(id data) {
                        
                    }];
                }
                    break;
                case EnumActionTag1:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要上架吗？" message:@"\n重新填写" preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        UITextField * firstKeywordTF = [[UITextField alloc]init];
                        NSArray * textFieldArr = @[firstKeywordTF];
                        textFieldArr = alert.textFields;
                        self.tf1 = alert.textFields[0];
                        self.tf1.delegate =self;
                        if (![NSString isEmpty:self.tf1.text]) {
                            InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                            [popupView showInApplicationKeyWindow];
                            [popupView actionBlock:^(id data) {
                                [self.vm network_onlineAdRequestParams:data withAdID:model.ugOtcAdvertId withNumber:self.tf1.text success:^(id data) {
                                    [con pageListView:(PageListView *)view requestListWithPage:1];
                                } failed:^(id data) {
                                    
                                } error:^(id data) {
                                    
                                }];
                                
                                
                            }];
                        }
                        
                        
                    }]];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"请输入剩余数量";
                        textField.keyboardType = UIKeyboardTypeNumberPad;
                    }];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
                }
                    break;
                case EnumActionTag2:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要下架吗？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                        [popupView showInApplicationKeyWindow];
                        [popupView actionBlock:^(id data) {
                            
                            [self.vm network_outlineAdRequestParams:data withAdID:model.ugOtcAdvertId success:^(id data) {
                                
                                [tableView beginUpdates];
                                [dataSource removeObjectAtIndex:indexPath.section];
                                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationLeft];
                                [con pageListView:(PageListView *)view requestListWithPage:1];
                                [tableView reloadData];
                                [tableView endUpdates];
//                                [YKToastView showToastText:@"下架成功"];
                                
                            } failed:^(id data) {
                                
                            } error:^(id data) {
                                
                            }];
                            
                            
                            
                        }];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
                }
                    break;
                 case EnumActionTag3:
                {
                    [ModifyAdsVC pushFromVC:self
                                   withAdId:model.ugOtcAdvertId success:^(id data) {
                                       
                                   }];
                }
                    break;
                default:
                    break;
            }
        }];
        
    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kTabScrollViewHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    WS(weakSelf);
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:[UIScreen mainScreen].bounds.size.width/titles.count tabHeight:kTabScrollViewHeight index:0 block:^(NSInteger index) {
        
        [weakSelf.tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    _tabContent.userInteractionEnabled = YES;
    [self.view addSubview:_tabContent];
    
    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(weakSelf.tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        [weakSelf.tabScrollView updateTagLine:index];
    }];
    
    _editAdsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _editAdsBtn.tag = IndexSectionFour;
    [_editAdsBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    //    _editAdsBtn.backgroundColor = kGrayColor;
    [_editAdsBtn setImage:[UIImage imageNamed:@"editAds"] forState:UIControlStateNormal];
    _editAdsBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.editAdsBtn];
    [self.editAdsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-11);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.height.equalTo(@54);
    }];
    
    return;
    [_tabContent actionBlock:^(id data) {
        
        CATransition* transition = [CATransition animation];
        transition.duration = .3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:NO];
        
        //            [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
}

- (void)clickItem:(UIButton*)button{
    LoginModel* model = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    LoginData* loginData = model.userinfo;
    IdentityAuthType type = [loginData getIdentityAuthType:loginData.valiidnumber];
    UserType userType = [loginData.userType intValue];
    if (userType == UserTypeSeller) {
        if (type  == IdentityAuthTypeFinished) {
            [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeCreate) success:^(id data) {
                
            }];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲爱的卖家，请先进行实名认证哦～" message:nil preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"稍后验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"现在去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [IdentityAuthVC pushFromVC:self requestParams:@1 success:^(id data) {
                    
                }];
            }]];
            [self presentViewController:alert animated:true completion:nil];
        }
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"买家账号不能卖币哦～" message:nil preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    

}

- (PageVM *)vm {
    if (!_vm) {
        _vm = [PageVM new];
    }
    return _vm;
}
@end
