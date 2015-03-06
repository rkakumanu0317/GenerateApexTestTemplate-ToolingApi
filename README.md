# GenerateApexTestTemplate-ToolingApi

Generates the Apex Class template for all the apex classes where there isn't any test class specified. The test class is recognised by <i>'Test_'</i> prefiix. 



<b>Directions to Use:</b>

To create the templates for all the test classes, please use the following :- 
GenerateTemplate.generateTestClassTemplate(); 

You could call the above method directly from your developer console (as this is a one time process) or from anywhere else wherever you feel like. 

Also, please make sure that the remote site settings are properly set to:
https://<instance_name>.salesforce.com
or
https://c.<instance_name>.visual.force.com (if calling form visualforce page)

