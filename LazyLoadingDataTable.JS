({
    init: function (cmp, event, helper) {
        console.log( cmp.get("v.data").length );
        helper.initData(cmp, event, cmp.get("v.data").length);        
    },
    
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    
    resetRows: function (cmp, event, helper) {
        cmp.set('v.data', []);
        helper.initData(cmp, event, cmp.get("v.data").length);
    },
    
    loadMoreData: function (cmp, event, helper) {
        var rowsToLoad = cmp.get('v.rowsToLoad');
        event.getSource().set("v.isLoading", true);
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.fetchData(cmp, event, cmp.get("v.data").length);
    },
    
    updateColumnSorting: function (cmp, event, helper) {
        
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        cmp.set('v.data', []);
        event.getSource().set("v.isLoading", true);
        cmp.set('v.loadMoreStatus', 'Loading');
        helper.initData(cmp, event, cmp.get("v.data").length);
    }

})
