/**
* @File Name : PermissionsDocumentationDAO.cls
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

public class PermissionsDocumentationDAO {
	@AuraEnabled
	public static List<PermissionSetGroup> getPermissionSetGroups(){
		List<PermissionSetGroup> permissionSetGroupRecords = [SELECT Id, MasterLabel, DeveloperName FROM PermissionSetGroup WITH USER_MODE];
		return permissionSetGroupRecords.size() > 0 ? permissionSetGroupRecords : null;
	}

	public static List<PermissionSetGroupComponent> getPermissionSetGroupComponentRecords(List<PermissionSetGroup> permissionSetGroups){
		List<PermissionSetGroupComponent> permissionSetGroupComponents = [SELECT Id, PermissionSetGroupId, PermissionSetGroup.MasterLabel, PermissionSetGroup.DeveloperName, PermissionSet.Id, PermissionSet.Label,
																			PermissionSet.Name, PermissionSet.LicenseId, PermissionSet.License.Name FROM PermissionSetGroupComponent 
																			WHERE PermissionSetGroupId IN :permissionSetGroups AND PermissionSet.Name != null WITH USER_MODE ORDER BY PermissionSetGroupId ];
		return permissionSetGroupComponents.size() > 0 ? permissionSetGroupComponents : null;
	}
}