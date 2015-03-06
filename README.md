# GenerateApexTestTemplate-ToolingApi

Generates the Apex Class template to create the test classes for all the apex classes where there isn't any test class specified. The test class is recognised by <i>'Test_'</i> prefix. 

<b>Features:</b>

a) Creates the test class for each of the apex classes where there isn't any test class specified. For e.g. suppose there are two apex classes in our org - 'ApexClass1' and 'ApexClass2' and there is a test class for 'ApexClass2' which is called - 'Test_ApexClass2'. When we execute the call (i.e. GenerateTemplate.generateTestClassTemplate();), it checks for existing test classes and creates one if there isn't any. In this case, it would create 'Test_ApexClass1' for 'ApexClass1'.

b) Add the comments and the class body with two methods - runPositiveTestCases() and runNegativeTestCases(). This may help an org to have proper naming conventions throughout all of the test classes by using a particular template.


<b>Directions to Use:</b>

To create the templates for all the test classes, please use the following :- 
GenerateTemplate.generateTestClassTemplate(); 

You could call the above method directly from your developer console (as this is a one time process) or from anywhere else wherever you feel like. 

Also, please make sure that the remote site settings are properly set to:
https://(instance_name).salesforce.com
or
https://c.(instance_name).visual.force.com (if calling form visualforce page)


<b>Feedback</b>

It would be great if you could provide a feedback on this. Its just a starting point so looking forward to hearing from you and improve the functionality.

