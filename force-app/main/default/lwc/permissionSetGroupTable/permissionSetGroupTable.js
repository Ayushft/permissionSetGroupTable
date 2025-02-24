import { LightningElement , wire} from 'lwc';
import getPermissionsDocumentationData from '@salesforce/apex/PermissionsDocumentationController.getPermissionsDocumentationData';

export default class PermissionSetGroupTable extends LightningElement {
    permissionRows = [];
    error;
    
    @wire(getPermissionsDocumentationData)
    wiredRows({ error, data }) {
        if (data) {
            this.permissionRows = data;
            this.error = undefined;
            console.log(this.permissionRows);
            // this.processTableData();
        } else if (error) {
            this.error = error;
            this.permissionRows = undefined;
        }
    }

    get processTableData(){
        let allRowsMap = new Map();
        //let tableData = this.permissionRows;
        this.permissionRows.forEach(row => {
            if (allRowsMap.has(row.permissionSetGroupLabel)) {
                allRowsMap.get(row.permissionSetGroupLabel).rows.push(row);
            } else {
                let newRow = {};
                newRow.permissionSetGroupLabel = row.permissionSetGroupLabel;
                newRow.rows = [row];
                allRowsMap.set(row.permissionSetGroupLabel, newRow);
            }
        });

        let itr = allRowsMap.values();
        console.log(itr);
        let rowsArray = [];
        let result = itr.next();
        console.log(result);
        while (!result.done) {
            result.value.rowspan = result.value.rows.length + 1;
            rowsArray.push(result.value);
            result = itr.next();
        }
        console.log(rowsArray);
        return rowsArray;
    }
}