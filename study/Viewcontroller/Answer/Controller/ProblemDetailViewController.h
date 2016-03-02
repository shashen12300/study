//
//  ProblemDetailViewController.h
//  study
//
//  Created by jzkj on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger ,QuestionType) {
    QuestionTypeChat,
    QuestionTypeSubmit,
    QuestionTypeCancel,
    QuestionTypeEnd,
    QuestionTypeReview,
    QuestionTypeAnswer
};
@interface ProblemDetailViewController : BaseViewController
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *chatId;//聊天对象id
@property (nonatomic) QuestionType questionType;//问题状态
@property (nonatomic, copy) NSString * tempGrade;//年级
@property (nonatomic, copy) NSString * tempObject;//课程
@property (nonatomic, copy) NSString * questionId;//问题id;
@property (nonatomic, strong) NSArray * questionData;//问题详情
@property (nonatomic, copy) NSString * teacherId;//老师id
@property (nonatomic, copy) NSString * studyID;//学生id
@property (nonatomic, copy) void(^answerSuccess)();//抢答成功
@end
