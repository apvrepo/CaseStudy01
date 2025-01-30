
# Case Study 

## Assignment Salesforce Developer

## Requirements

- In our Field Service implementation, when a ServiceTerritory is updated to IsActive =
false, the related ServiceTerritoryMembers field EffectiveEndDate should be updated
to yesterday (today’s date - 1).

- Also whenever a ServiceTerritoryMember is created or updated, ensure that if it is a
Secondary Territory Member (TerritoryType = ‘S’) it is created or updated within the
existing Primary Territory Member (TerritoryType = ‘P’). This means that the
Secondary Member EffectiveStartDate and EffectiveEndDate are validated against
the Primary Territory Member.

- If you save time, consider the case where we might have set multiple Primary
ServiceTerritoryMembers, for example, 2 ServiceTerritoryMembers where the
first ends at a certain date and the second one starts the day after and never
ends.
Come up with a solution to the above requirements using Apex (do not use Flows).
Focus mainly on the structure of your code. Make use of design patterns where you find
them useful. Organize your code as you think it is best for maintenance. Add unit tests.
You will receive an email to get access to a Salesforce Org to work on the assignment.

## Assumptions:

### About the First Point: 
- The only ServiceTerritoryMember records that need to be updated are the ones related to the ServiceTerritory record that is being updated (Relationship via lookup field 'ServiceTerritoryId').
- The update of the ServiceTerritoryMember records occurs after the update of the Service Territory record 
- All the ServiceTerritoryMember records related to the ServiceTerritory record need to be updated despite the Territory Type (Primary or Secondary). 
- The EffectiveStartDate of the ServiceTerritoryMember records also needs to be updated to avoid a Salesforce Validation Error: 'Failed Record Error: The Start Date must be earlier than the End Date'. 

### About the Second Point: 
- The validation for the creation or update of the ServiceTerritoryMember records does not look for the Active or Inactive state of the Service Territory related to them. 
- Each Service Territory Member record related to the same Service Territory must have a different Service Resource assigned, otherwise a Salesforce validation is fired 'This service resource is already a member of the service territory at the same date and time. -  DUPLICATE_VALUE'. This assumption also prevents other Salesforce validation from being fired: 'Failed Record Error: This service resource is already assigned to another primary service territory during the same time. Change the territory type to Secondary, or adjust the dates of one of the territory memberships so the periods don't overlap.'
- When the validation states:  'whenever a ServiceTerritoryMember is created or updated, ensure that if it is a Secondary Territory Member (TerritoryType = ‘S’) it is created or updated within the existing Primary Territory Member (TerritoryType = ‘P’)', it was interpreted as that the start and end date of the Secondary Service Territory must be equal or fall within the start and end dates of at least one Primary Service Territory Member related to the same Service Territory. 
- The alternative case is where a second primary Service Territory Member has no End Date, in this case, if a secondary Service Territory Member record has a Start Date equal to or later than the special primary member then the secondary Service Territory Member passed validation.  


## DESIGN PATTERN USED: 

### 1. Facade Pattern:
It is a structural design pattern that provides a simplified interface to a complex system. It essentially offers a high-level view and hides the complex workings of the subsystems.

Advantages of Facade Pattern:

-Facade simplifies a complex system, providing an easy-to-use interface.
-It hides intricate internal details, allowing users to interact at a higher level.
-Users only need to work with a single, clear interface rather than multiple subsystems.
-Developers can focus on their tasks without being overwhelmed by system complexity.
-Changes to the internal subsystems can be managed within the facade, minimizing impact on users.

### 2. Bulk State Transition Pattern:
It’s a behavioral design pattern to efficiently handle the transition of multiple records from one state to another. This pattern is particularly valuable when dealing with a significant number of records and needing to update or modify them collectively based on certain conditions or triggers. Instead of processing records one by one, process them in bulk minimizing the use of database operations and enhancing performance.

Advantages of Bulk State Transition Pattern:

- Reduces database operations by processing records in bulk, improving performance.
- Helps avoid hitting Salesforce's governor limits by minimizing DML and query operations.
- Optimizes resource usage, reducing platform costs associated with excessive database actions.
- Allows the system to handle a large volume of data and transactions efficiently.
- Enhances code organization and readability, making it easier to manage and maintain.

More Information:  https://www.linkedin.com/pulse/salesforce-apex-design-patterns-waqas-ali

## FIELD SERVICE CORE DATA MODEL: 

![image](https://github.com/user-attachments/assets/578b6ea8-945a-4aba-a42e-25ecb02e5253)


More Information:  https://developer.salesforce.com/docs/atlas.en-us.field_service_dev.meta/field_service_dev/fsl_dev_soap_core.htm

## SALESFORCE FRAMEWORK IMPLEMENTATION: 

What Is a Framework?
A framework is a highly optimized, reusable structure that serves as a building block. These building blocks provide common functionality that developers can override or specialize for their own needs. Reusable frameworks increase the speed of development, improve the clarity and efficiency of your code, and simplify code reviews and debugging. 

Benefits of using Frameworks: 
-Scalable, due to built-in bulkification.
-Traceable, clearly showing what logic is executed, and when, for each record.
-Reusable, because functional methods and classes are separated.
-Atomic, allowing you to bypass specific triggers when needed.
-Optimized, making minimal Salesforce Object Query Language (SOQL) calls, preventing recursion, and sharing result sets over the execution cycle. 

Frameworks used in the Assignment: 

1. Trigger Handler Framework: [OK]
More Information: https://github.com/kevinohara80/sfdc-trigger-framework

2. Test Data Factory: [OK]
More Information: https://trailhead.salesforce.com/content/learn/modules/apex_testing/apex_testing_data

3. Apex Unified Logging: [NOT FUNTIONAL]
More Information: https://github.com/rsoesemann/apex-unified-logging


## SALESFORCE BEST PRACTICES: 
More Information: 
https://developer.salesforce.com/ja/wiki/apex_code_best_practices

https://www.apexhours.com/apex-code-best-practices/
