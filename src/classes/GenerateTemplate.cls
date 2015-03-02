/**
 * @author  Pratyush Kumar
 * @date    02/03/2015
 *
 * This class generates test class template for each of the class (not part of managed package) through Tooling API if there isn't any test class defined for them
 * It checks for the test classes that starts with 'Test_<classname>'
 * Uses Tooling Rest API to make webservice callouts for retrieving, parsing and creating the apex classes. 
 * 
 */


public class GenerateTemplate {
	
	
	// Retrieve all the classes from the org and create a consistent test class template to be used
    public static void generateTestClassTemplate() {
		// retrieve all the classes which are valid, active and not part of any package
        List<ApexClass> apexClassList = [Select SystemModstamp, Status, NamespacePrefix, Name, LengthWithoutComments, LastModifiedDate, LastModifiedById, 
                                                IsValid, Id, CreatedDate, CreatedById, BodyCrc, Body, ApiVersion 
                                                From ApexClass
                                                Where IsValid = true AND Status = 'Active' AND Namespaceprefix = null];
        // stores the map of unique set of apex class id as the key and apex class as the value
        Map<Id, ApexClass> apexClassIdMap = new Map<Id, ApexClass>();
		// holds the classes where we need to create a test class
        List<ApexClass> existingClassList;
        // form a map to check already existing test classes
        Map<String, ApexClass> apexClassMap = new Map<String, ApexClass>();

  		if(apexClassList != null && !apexClassList.isEmpty()) {
        	
        	for(ApexClass apexClass : apexClassList) {
        		apexClassMap.put(apexClass.Name, apexClass);
        		apexClassIdMap.put(apexClass.id, apexClass);
        	}
        	
        	existingClassList = new List<ApexClass>();// {apexClass};
     	   			
        	for(ApexClass apexClass : apexClassList) {
        		//System.debug('££££apexClass.Name: ' + apexClass.Name);
        		//System.debug('££££apexClass.Name: ' + apexClassMap.keySet());
        		//System.debug('££££check key: ' + apexClassMap.containsKey('Test_'+apexClass.Name));
        		// creates a list of classes where there we need to generate test class template
        		if(apexClassMap.keySet() != null && !apexClassMap.keySet().isEmpty() 
        			&& !apexClassMap.containsKey('Test_'+apexClass.Name)
        			&& apexClass.Body != null 
        			&& !apexClass.Body.contains('@isTest')) {
        			existingClassList.add(apexClass);	
     	   		}
        	}
        	List<RestToolingAPI.ApexClass> insertedClassesList;
        	// creates apex class template for the test classes
        	if(existingClassList != null && !existingClassList.isEmpty())
	        	insertedClassesList = createTestClasses(existingClassList);
	        
	        // adds the positive and negative scenarios method where unavailable for the test classes
	        RestToolingAPI.ContainerAsyncRequest containerAsyncRequest = createApexClassMembers(apexClassMap, apexClassIdMap);
    	
        }
        
		
	}
	
	
    
    // create apex class members by parsing the constructor and the methods for the class and the inner classes
    private static RestToolingAPI.ContainerAsyncRequest createApexClassMembers(Map<String, ApexClass> apexClassMap, Map<Id, ApexClass> apexClassIdMap) {
        
        RestToolingAPI tooling = new RestToolingAPI();
        
        List<RestToolingAPI.ApexClass> retrieveApexClasses =  
            (List<RestToolingAPI.ApexClass>)
                tooling.query( // + contentEntityListString //  where ContentEntityId IN :tempContentEntityListString
                    'SELECT apiVersion, Body, bodyCrc, fullName, isValid, lengthWithoutComments, metadata,'
                    			+ ' name, namespacePrefix, status, symbolTable, Id'
                    			+ ' FROM ApexClass Where isValid = true AND Status = \'Active\' AND Namespaceprefix = null').records;
       
        //System.debug('****retrieveApexClasses: ' + retrieveApexClasses);
        List<RestToolingAPI.SymbolTable> symbolTableList = new List<RestToolingAPI.SymbolTable>();
        
        // Map of Apex Class Name as key and value as object to be used when adding the classbody for the test class
        Map<String, RestToolingAPI.ApexClass> retrievedApexTableMap = new Map<String, RestToolingAPI.ApexClass>();
        Map<Id, RestToolingAPI.ApexClass> retrievedApexIdMap = new Map<Id, RestToolingAPI.ApexClass>();
        for(RestToolingAPI.ApexClass apexClassObj : retrieveApexClasses) {
        	//System.debug('$$$$$$ - symbolTable: ' + apexClassObj.symbolTable);
        	symbolTableList.add(apexClassObj.symbolTable);
        	retrievedApexTableMap.put(apexClassObj.Name, apexClassObj);
        	retrievedApexIdMap.put(apexClassObj.Id, apexClassObj);
        }
        
        
        // System.debug('$$$$$$ - symbolTable: size() ' + symbolTableList.size());
        // Map of Class Id and the body formed from Symbol Table
        Map<Id, String> symbolTableMap;
        
        
        if(symbolTableList != null && !symbolTableList.isEmpty()) {
        	symbolTableMap = createClassBody(symbolTableList, apexClassIdMap);
        }
        
        if(symbolTableMap != null && symbolTableMap.keySet() != null && !symbolTableMap.keySet().isEmpty()) {
        	// Create MetadataContainer
        	Id containerId = createMetadataContainer('CodeGenerate:' + String.valueOf(System.now()), tooling);
	        
        	createApexClassMembers(symbolTableMap, containerId, tooling, retrievedApexTableMap, retrievedApexIdMap);
        	
        	RestToolingAPI.SaveResult asyncRequestSaveResult = createContainerAsyncRequest(containerId, tooling);
        	
	        
	        // The above starts an async background compile, the following needs repeated (polled) to confirm compilation
	        RestToolingAPI.ContainerAsyncRequest containerAsyncRequest = 
	            ((List<RestToolingAPI.ContainerAsyncRequest>)
	                tooling.query(
	                    'SELECT Id, State, MetadataContainerId, CompilerErrors ' + 
	                    'FROM ContainerAsyncRequest ' + 
	                    'WHERE Id = \'' + asyncRequestSaveResult.Id + '\'').records)[0];
	        //System.debug('&&&%%%££££ State is ' + containerAsyncRequest.State); 
	        //System.debug('&&&%%%££££ Id is ' + asyncRequestSaveResult.Id); 
	    	return containerAsyncRequest;
        }
        return null;                             
    }
    
    private static Map<Id, String> createClassBody(List<RestToolingAPI.SymbolTable> symbolTableList, Map<Id, ApexClass> apexClassIdMap) {
    	
    	Map<Id, String> symbolTableMap = new Map<Id, String>();
    	
    	for(RestToolingAPI.SymbolTable symbolTable : symbolTableList) {
    		//System.debug('%%%%symbolTable: ' + symbolTable);
    		String classBody = '';
    		if(symbolTable.Id != null) {
    			if(apexClassIdMap.containsKey(symbolTable.Id) && apexClassIdMap.get(symbolTable.Id).Name != null) {
    				classBody += '/**'
								 	+'\n * Name: Test_'+ apexClassIdMap.get(symbolTable.Id).Name
								 	+'\n * Created Date: ' + String.valueOf(System.today())
								 	+'\n * Author: ' + userinfo.getName()
								 	+'\n * Description: Test method for '+ apexClassIdMap.get(symbolTable.Id).Name
								 	+'\n * Generated from the test class template'
								 	+'\n */' 
									+'\n\n@isTest\n'
    								+'private class Test_'+apexClassIdMap.get(symbolTable.Id).Name+' {\n';
    				//System.debug('---- check Constructors: ' + symbolTable.constructors);
    				//System.debug('---- check methods: ' + symbolTable.methods);
    				//System.debug('---- check innerClasses: ' + symbolTable.innerClasses);
    				//System.debug('---- check properties: ' + symbolTable.properties);
    								
        			// create constructors if any defined for the symboltable
        			if(((symbolTable.constructors != null && !symbolTable.constructors.isEmpty())
        				|| (symbolTable.methods != null && !symbolTable.methods.isEmpty())
        				|| (symbolTable.innerClasses != null && !symbolTable.innerClasses.isEmpty()))
        				|| (symbolTable.properties != null && !symbolTable.properties.isEmpty())) {
    						
    						classBody += createMethods();
    				}
        			
        			classBody += '\n}';
    			}
    		}
    		//System.debug('$$$$$$ classBody: '+ classBody);
    		if(symbolTableMap == null || symbolTableMap.keySet() == null || symbolTableMap.keySet().isEmpty()
    			|| !symbolTableMap.containsKey(symbolTable.Id)) {
    			symbolTableMap.put(symbolTable.Id, classBody);
    			//System.debug('$$$$$$ symbolTable: ' + symbolTable);
			}
    	}
    	
    	return symbolTableMap;
    }
    
    private static String createMethods() {
    	String classBody = '';
    	classBody += '\n   // Execute Positive Test Cases'
    					+ '\n  static testMethod void runPositiveTestCases() {' 
    					+ '\n\n  }';
    	
    	classBody += '\n\n   // Execute Negative Test Cases'
    					+ '\n  static testMethod void runNegativeTestCases() {' 
    					+ '\n\n  }';
    	
    	return classBody;
    }
    
   
    
    // Create apex class members by using the symboltable map
    private static void createApexClassMembers(Map<Id, String> symbolTableMap, Id containerId, RestToolingAPI tooling, 
    										Map<String, RestToolingAPI.ApexClass> retrievedApexTableMap, Map<Id, RestToolingAPI.ApexClass> retrievedApexIdMap) {
    	// Create ApexClassMembers
        	for(Id classId : symbolTableMap.keySet()) {
        		if(symbolTableMap.get(classId) != null && symbolTableMap.get(classId) != '') {
        			if(retrievedApexTableMap != null && retrievedApexTableMap.keySet() != null && !retrievedApexTableMap.keySet().isEmpty()
        				&& retrievedApexIdMap != null && retrievedApexIdMap.keySet() != null && !retrievedApexIdMap.keySet().isEmpty()
        				&& retrievedApexTableMap.containsKey('Test_' + retrievedApexIdMap.get(classId).Name) && retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name) != null) {
        				
        				if(!retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Body.contains('runPositiveTestCases()') 
        					&& !retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Body.contains('runNegativeTestCases()')) {
        						
        						//System.debug('-----'+ retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Id);
        						//System.debug('-----'+ retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Name);
        						
        						//System.debug('-----'+ retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Body.contains('runPositiveTestCases()'));
        						//System.debug('-----' + retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Body.contains('runNegativeTestCases()'));
        						
			        			RestToolingAPI.ApexClassMember tempClassMember = new RestToolingAPI.ApexClassMember();
			        			tempClassMember.Body = symbolTableMap.get(classId);
			        			//System.debug('-----tempClassMember.Body: ' + tempClassMember.Body);
        						
			        			tempClassMember.ContentEntityId = retrievedApexTableMap.get('Test_' + retrievedApexIdMap.get(classId).Name).Id;
			        			tempClassMember.metadataContainerId = containerId;
			        			RestToolingAPI.SaveResult sr = tooling.createSObject(tempClassMember);
        					}
        				}
        		}
        	}
    }
    
    // Create the test classes for the classes where not available
    private static List<RestToolingAPI.ApexClass> createTestClasses(List<ApexClass> existingClassList) {       
        RestToolingAPI tooling = new RestToolingAPI();
        List<RestToolingAPI.ApexClass> tempClassList = new List<RestToolingAPI.ApexClass>();
        for(ApexClass existingApexClass : existingClassList) {
            if(existingApexClass.Body != null) {
                RestToolingAPI.ApexClass tempClass = new RestToolingAPI.ApexClass();
                //tempClass.Name = 'Test_' + existingApexClass.Name;
                tempClass.Body = '/**'
                					+'\n * Name: Test_'+ existingApexClass.Name
								 	+'\n * Created Date: ' + String.valueOf(System.today())
								 	+'\n * Author: ' + userinfo.getName()
								 	+'\n * Description: Test method for '+ existingApexClass.Name
								 	+'\n * Generated from the test class template'
								 	+'\n */' 
									+'\n\n@isTest\n'
                                    + 'private class Test_' + existingApexClass.Name + ' {'
                                    +' \n\n}';
                tempClassList.add(tempClass);
                                   
            }
        }
        //System.debug('%%%%%tempClassList: ' + tempClassList);
        // Create test classes where there isn't any test class available with the same name - 'Test_<Classname>'
        if(tempClassList != null && !tempClassList.isEmpty()) {
        	for(RestToolingAPI.ApexClass tempClass : tempClassList) {
        		//System.debug('%%%%%tempClass: ' + tempClass);
        		RestToolingAPI.SaveResult sr = tooling.createSObject(tempClass);
        	}
        }
        return tempClassList;
    }
    
    // Insert the metadata container for creating the apex class members
    private static Id createMetadataContainer(String containerName, RestToolingAPI tooling) {
    	
    	RestToolingAPI.MetadataContainer container = new RestToolingAPI.MetadataContainer();
        container.name = containerName;
        RestToolingAPI.SaveResult containerSaveResult = tooling.createSObject(container);
        Id containerId = containerSaveResult.id;
	        
    	return containerId;
    }
    
    // Insert the ContainerAsyncRequest for deploying the changes to the apex class
    private static RestToolingAPI.SaveResult createContainerAsyncRequest(String containerId, RestToolingAPI tooling) {
    	// Create ContainerAysncRequest to deploy the Apex Classes
	        RestToolingAPI.ContainerAsyncRequest asyncRequest = new RestToolingAPI.ContainerAsyncRequest();     
	        asyncRequest.metadataContainerId = containerId;
	        asyncRequest.IsCheckOnly = false;  // Need to change it to false when we get no errors     
	        RestToolingAPI.SaveResult asyncRequestSaveResult = tooling.createSObject(asyncRequest);
	        
	        return asyncRequestSaveResult;
    }
}