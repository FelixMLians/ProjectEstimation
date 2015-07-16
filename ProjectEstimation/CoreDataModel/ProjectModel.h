//
//  ProjectModel.h
//  
//
//  Created by apple on 15/7/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DemandModel;

@interface ProjectModel : NSManagedObject

@property (nonatomic, retain) NSString * nameString;
@property (nonatomic, retain) NSString * bgColorString;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * projectIdString;
@property (nonatomic, retain) NSSet *toDemand;
@end

@interface ProjectModel (CoreDataGeneratedAccessors)

- (void)addToDemandObject:(DemandModel *)value;
- (void)removeToDemandObject:(DemandModel *)value;
- (void)addToDemand:(NSSet *)values;
- (void)removeToDemand:(NSSet *)values;

@end
