//
//  DemandModel.h
//  
//
//  Created by apple on 15/7/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectModel;

@interface DemandModel : NSManagedObject

@property (nonatomic, retain) NSString * demandIdString;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * desString;
@property (nonatomic, retain) NSString * personString;
@property (nonatomic, retain) NSString * bgColorString;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * picPathString;
@property (nonatomic, retain) ProjectModel *toProject;

@end
