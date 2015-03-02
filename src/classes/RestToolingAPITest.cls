/**
 * Copyright (c) 2013, Apex Tooling API
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Apex Tooling API, inc nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * Some initial tests to get things started!
 **/
@IsTest
private class RestToolingAPITest
{
    static testmethod void testQueryCustomObjects(){
        Test.setMock(HttpCalloutMock.class, new RestToolingAPIMock(testObjectResponse, 200));
        RestToolingAPI RestToolingAPI = new RestToolingAPI();
        List<RestToolingAPI.CustomObject> result  = (List<RestToolingAPI.CustomObject>)
            RestToolingAPI.query('Select Id, DeveloperName, NamespacePrefix From CustomObject Where DeveloperName = \'Test\'').records;
        System.assertEquals(result.size(), 1);
        System.assertEquals(result[0].DeveloperName, 'Test');
    }

    static testmethod void testQueryCustomFields(){
        Test.setMock(HttpCalloutMock.class, new RestToolingAPIMock(testFieldResponse, 200));
        RestToolingAPI RestToolingAPI = new RestToolingAPI();
        List<RestToolingAPI.CustomField> result = (List<RestToolingAPI.CustomField>)
            RestToolingAPI.query('Select Id, DeveloperName, NamespacePrefix, TableEnumOrId From CustomField Where TableEnumOrId = \'01IG00000021cXoMAI\'').records;
        System.assertEquals(result.size(), 1);
        System.assertEquals(result[0].DeveloperName, 'A_Number');
    }

    static testmethod void testQueryApexClassMember(){
        Test.setMock(HttpCalloutMock.class, new RestToolingAPIMock(testApexClassMemberQueryResponse, 200));
        RestToolingAPI.QueryResult result = 
                (new RestToolingAPI()).query('Select Id From ApexClassMember');
        System.assertNotEquals(null,result);
    }

    static testmethod void testQueryApexClassMemberError(){
        boolean exceptionEncountered = false;
        Test.setMock(HttpCalloutMock.class, new RestToolingAPIMock(testErrorResponse, 400));
        RestToolingAPI RestToolingAPI = new RestToolingAPI();
        try {
            List<RestToolingAPI.CustomField> result = (List<RestToolingAPI.CustomField>)
                RestToolingAPI.query('Select RandomField From ApexClassMember').records;
        } catch (RestToolingAPI.RestToolingAPIException e){
            exceptionEncountered = true;
        }
        System.assert(exceptionEncountered,'Expected exception');
    }

    static testmethod void testCoverTypes(){
        new RestToolingAPI.AggregateExpressionResultColumnMetadata();
        new RestToolingAPI.AllowedWorkitemAction();
        new RestToolingAPI.ApexClass();
        new RestToolingAPI.ApexClassMetadata();
        new RestToolingAPI.ApexCodeCoverage();
        new RestToolingAPI.ApexCodeCoverageAggregate();
        new RestToolingAPI.ApexComponent();
        new RestToolingAPI.ApexExecutionOverlayAction();
        new RestToolingAPI.ApexLog();
        new RestToolingAPI.ApexOrgWideCoverage();
        new RestToolingAPI.ApexResult();
        new RestToolingAPI.ApexTestResult();
        new RestToolingAPI.ApexTestQueueItem();
        new RestToolingAPI.ApexPage();
        new RestToolingAPI.ApexClassMember();
        new RestToolingAPI.ApexTriggerMember();
        new RestToolingAPI.ApexComponentMember();
        new RestToolingAPI.ApexExecutionOverlayResult();
        new RestToolingAPI.ApexPageMember();
        new RestToolingAPI.ApexTrigger();
        new RestToolingAPI.ApiFault();
        new RestToolingAPI.ApiQueryFault();
        new RestToolingAPI.Attribute();
        new RestToolingAPI.AttributeDefinition();
        new RestToolingAPI.AsyncApexJob();
        new RestToolingAPI.BooleanValue();
        new RestToolingAPI.ChildRelationship();
        new RestToolingAPI.ComplexQueryResultColumnMetadata();
        new RestToolingAPI.ContainerAsyncRequest();
        new RestToolingAPI.Coverage();
        new RestToolingAPI.CustomField();
        new RestToolingAPI.CustomFieldMetadata();
        new RestToolingAPI.CustomObject();
        new RestToolingAPI.DescribeColorResult();
        new RestToolingAPI.DescribeColumn();
        new RestToolingAPI.DescribeGlobalResult();
        new RestToolingAPI.DescribeGlobalSObjectResult();
        new RestToolingAPI.DescribeIconResult();
        new RestToolingAPI.DescribeLayoutButton();
        new RestToolingAPI.DescribeLayoutItem();
        new RestToolingAPI.DescribeLayoutComponent();
        new RestToolingAPI.DescribeLayoutRow();
        new RestToolingAPI.DescribeLayoutSection();
        new RestToolingAPI.DescribeSObjectResult();
        new RestToolingAPI.DescribeWorkitemActionResult();
        new RestToolingAPI.Error();
        new RestToolingAPI.ErrorResponse();
        new RestToolingAPI.ExecuteAnonymousResult();
        new RestToolingAPI.ExternalConstructor();
        new RestToolingAPI.ExternalMethod();
        new RestToolingAPI.ExternalReference();
        new RestToolingAPI.ExternalSymbol();
        new RestToolingAPI.Field();
        new RestToolingAPI.FilterItem();
        new RestToolingAPI.HeapAddress();
        new RestToolingAPI.HeapDump();
        new RestToolingAPI.InvalidateSessionsResult();
        new RestToolingAPI.LogInfo();
        new RestToolingAPI.ListValue();
        new RestToolingAPI.MapEntry();
        new RestToolingAPI.MapValue();
        new RestToolingAPI.Metadata();
        new RestToolingAPI.MetadataContainer();
        new RestToolingAPI.MetadataContainerMember();
        new RestToolingAPI.Method();
        new RestToolingAPI.Name();
        new RestToolingAPI.NumberValue();
        new RestToolingAPI.PackageVersion();
        new RestToolingAPI.Parameter();
        new RestToolingAPI.Picklist();
        new RestToolingAPI.PicklistEntry();
        new RestToolingAPI.Position();
        new RestToolingAPI.PrimitiveQueryResultColumnMetadata();
        new RestToolingAPI.ProcessResult();
        new RestToolingAPI.QueryResult();
        new RestToolingAPI.QueryResultColumnMetadata();
        new RestToolingAPI.QueryResultMetadata();
        new RestToolingAPI.RecordTypeInfo();
        new RestToolingAPI.RecordTypePicklist();
        new RestToolingAPI.SaveResult();
        new RestToolingAPI.SetValue();
        new RestToolingAPI.SOQLResult();
        new RestToolingAPI.StaticResource();
        new RestToolingAPI.StateValue();
        new RestToolingAPI.StringValue();
        new RestToolingAPI.SymbolTable();
        new RestToolingAPI.RestToolingAPIException();
        new RestToolingAPI.TraceFlag();
        new RestToolingAPI.TypeExtent();
        new RestToolingAPI.UpsertResult();
        new RestToolingAPI.UserPreference();
        new RestToolingAPI.User_x();
    }

    public class RestToolingAPIMock implements HttpCalloutMock {
        private String testResponse;
        private Integer testStatusCode;

        public RestToolingAPIMock(String testResponse, Integer testStatusCode){
            this.testResponse = testResponse;
            this.testStatusCode = testStatusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(testResponse);
            res.setStatusCode(testStatusCode);
            return res;
        }
    }

    private static String testObjectResponse =
        '{' +
          '"size" : 1,' +
          '"totalSize" : 1,' +
          '"done" : true,' +
          '"records" : [ {' +
            '"attributes" : {' +
              '"type" : "CustomObject",' +
              '"url" : "/services/data/v29.0/tooling/sobjects/CustomObject/01IG00000021cXoMAI"' +
            '},' +
            '"Id" : "01IG00000021cXoMAI",' +
            '"DeveloperName" : "Test"' +
          '} ],' +
          '"queryLocator" : null,' +
          '"entityTypeName" : "CustomEntityDefinition"' +
        '}';

    private static String testFieldResponse =
        '{' +
          '"size" : 1,' +
          '"totalSize" : 1,' +
          '"done" : true,' +
          '"queryLocator" : null,' +
          '"records" : [ {' +
            '"attributes" : {' +
              '"type" : "CustomField",' +
              '"url" : "/services/data/v29.0/tooling/sobjects/CustomField/00NG0000009Y0I9MAK"' +
            '},' +
            '"DeveloperName" : "A_Number",' +
            '"Id" : "00NG0000009Y0I9MAK",' +
            '"FullName" : "01IG00000021cXo.A_Number__c",' +
            '"TableEnumOrId" : "01IG00000021cXoMAI",' +
            '"NamespacePrefix" : null' +
          '} ],' +
          '"entityTypeName" : "CustomFieldDefinition"' +
        '}';

    private static String testErrorResponse =
        '[{' +
          '"errorCode" : "INVALID_FIELD",' +
          '"message" : "message"' +
        '}]';

    private static String testApexClassMemberQueryResponse = '{'
        + '"size": 1,' 
        + '"totalSize": 1,'
        + '"done": true,'
        + '"records": [{'
        + '"attributes": {'
        + '    "type": "ApexClassMember",'
        + '    "url": "/services/data/v28.0/tooling/sobjects/ApexClassMember/400G00000005IaoIAE"'
        + '},'
        + '"Id": "400G00000005IaoIAE",'
        + '"Body": "body",'
        + '"Content": "content",'
        + '"ContentEntityId": "01pG0000003ZjfTIAS",'
        + '"LastSyncDate": "2014-01-28T14:51:03.000+0000",'
        + '"Metadata": {'
        + '    "apiVersion": 28.0,'
        + '    "packageVersions": null,'
        + '    "status": "Active",'
        + '    "module": null,'
        + '    "urls": null,'
        + '    "fullName": null'
        + '},'
        + '"MetadataContainerId": "1drG0000000EKF0IAO",'
        + '"SymbolTable": {'
        + '    "tableDeclaration": {'
        + '        "modifiers": [],'
        + '        "name": "ContactExt",'
        + '        "location": {'
        + '            "column": 27,'
        + '            "line": 1'
        + '        },'
        + '        "type": "ContactExt",'
        + '        "references": []'
        + '    },'
        + '    "variables": [{'
        + '        "modifiers": [],'
        + '        "name": "stdController",'
        + '        "location": {'
        + '            "column": 52,'
        + '            "line": 9'
        + '        },'
        + '        "type": "StandardController",'
        + '        "references": [{'
        + '            "column": 30,'
        + '            "line": 10'
        + '        }, {'
        + '            "column": 35,'
        + '            "line": 11'
        + '        }]'
        + '    }],'
        + '    "externalReferences": [],'
        + '    "innerClasses": [],'
        + '    "name": "ContactExt",'
        + '    "constructors": [{'
        + '        "parameters": [{'
        + '            "name": "stdController",'
        + '            "type": "StandardController"'
        + '        }],'
        + '        "visibility": "PUBLIC",'
        + '        "modifiers": [],'
        + '        "name": "ContactExt",'
        + '        "location": {'
        + '            "column": 12,'
        + '            "line": 9'
        + '        },'
        + '        "type": null,'
        + '        "references": []'
        + '    }],'
        + '    "key": "01pG0000003ZjfT",'
        + '    "methods": [{'
        + '        "returnType": "PageReference",'
        + '        "parameters": [],'
        + '        "visibility": "PUBLIC",'
        + '        "modifiers": [],'
        + '        "name": "saveContact",'
        + '        "location": {'
        + '            "column": 26,'
        + '            "line": 14'
        + '        },'
        + '        "type": null,'
        + '        "references": []'
        + '    }, {'
        + '        "returnType": "PageReference",'
        + '        "parameters": [],'
        + '        "visibility": "PUBLIC",'
        + '        "modifiers": [],'
        + '        "name": "cancelChanges",'
        + '        "location": {'
        + '            "column": 26,'
        + '            "line": 19'
        + '        },'
        + '        "type": null,'
        + '        "references": []'
        + '    }],'
        + '    "properties": [{'
        + '        "visibility": "PRIVATE",'
        + '        "modifiers": [],'
        + '        "name": "myContact",'
        + '        "location": {'
        + '            "column": 18,'
        + '            "line": 3'
        + '        },'
        + '        "type": "Contact",'
        + '        "references": [{'
        + '            "column": 14,'
        + '            "line": 11'
        + '        }, {'
        + '            "column": 16,'
        + '            "line": 15'
        + '        }]'
        + '    }, {'
        + '        "visibility": "PRIVATE",'
        + '        "modifiers": [],'
        + '        "name": "stdController",'
        + '        "location": {'
        + '            "column": 42,'
        + '            "line": 4'
        + '        },'
        + '        "type": "StandardController",'
        + '        "references": [{'
        + '            "column": 14,'
        + '            "line": 10'
        + '        }]'
        + '    }],'
        + '    "id": "01pG0000003ZjfT",'
        + '    "namespace": "timesheet"'
        + '}'
        + '}],'
        + '"queryLocator": null,'
        + '"entityTypeName": "ApexClassMember"'
        + '}';
}