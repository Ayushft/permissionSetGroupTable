/**
* @File Name : PermissionsDocumentationController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : February 20, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | February 20, 2025 |   | Initial Version
**/

public with sharing class PermissionsDocumentationController {
	@AuraEnabled(cacheable=true)
	public static List<PermissionsDocumentationDataRow> getPermissionsDocumentationData(){
		List<PermissionSetGroup> permissionSetGroupRecords = PermissionsDocumentationDAO.getPermissionSetGroups();
		List<PermissionSetGroupComponent> permissionSetGroupComponentRecords = PermissionsDocumentationDAO.getPermissionSetGroupComponentRecords(permissionSetGroupRecords);
		List<PermissionsDocumentationDataRow> allTableRowData = new List<PermissionsDocumentationDataRow>();
		Map<Id, Integer> permissionSetGroupRowCount = new Map<Id, Integer>();
		System.debug(permissionSetGroupComponentRecords);
		if(!permissionSetGroupComponentRecords.isEmpty()){
			for(PermissionSetGroupComponent gc : permissionSetGroupComponentRecords){
				PermissionsDocumentationDataRow newRowData = new PermissionsDocumentationDataRow();
				if(!permissionSetGroupRowCount.containsKey(gc.PermissionSetGroupId)){
					permissionSetGroupRowCount.put(gc.PermissionSetGroupId, 0);
				}
				permissionSetGroupRowCount.put(gc.PermissionSetGroupId, permissionSetGroupRowCount.get(gc.PermissionSetGroupId) + 1);
				newRowData.Id = gc.Id;
				newRowData.permissionSetGroupLabel = gc.PermissionSetGroup.MasterLabel;
				newRowData.permissionSetGroupDevName = gc.PermissionSetGroup.DeveloperName;
				newRowData.permissionSetGroupId = gc.PermissionSetGroupId;
				newRowData.permissionSetId = gc.PermissionSet.Id;
				newRowData.permissionSetName = gc.PermissionSet.Name;
				newRowData.permissionSetLicenseId = gc.PermissionSet.LicenseId != null ? gc.PermissionSet.LicenseId : null;
				newRowData.permissionSetLicenseName = gc.PermissionSet.License.Name != null ? gc.PermissionSet.License.Name : null;
				allTableRowData.add(newRowData);
			}
		}

		for(PermissionsDocumentationDataRow eachRow : allTableRowData){
			eachRow.rowCount = permissionSetGroupRowCount.get(eachRow.permissionSetGroupId);
		}
		//System.debug('allTableRowData -> ' + allTableRowData[2]);
		return allTableRowData.size() > 0 ? allTableRowData : null;
	}

	public class PermissionsDocumentationDataRow{
		@AuraEnabled public String Id {get; set;}
		@AuraEnabled public Integer rowCount {get; set;}
		@AuraEnabled public String permissionSetGroupLabel {get; set;}
		@AuraEnabled public String permissionSetGroupDevName {get; set;}
		@AuraEnabled public String permissionSetGroupId {get; set;}
		@AuraEnabled public String permissionSetId {get; set;}
		@AuraEnabled public String permissionSetName {get; set;}
		@AuraEnabled public String permissionSetLicenseId {get; set;}
		@AuraEnabled public String permissionSetLicenseName {get; set;}
	}
}