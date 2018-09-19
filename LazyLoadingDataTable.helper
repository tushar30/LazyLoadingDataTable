({
    
    initData: function (cmp,  event, numberOfRecords) {
       
         var action = cmp.get("c.initRecords");
         action.setParams({
             ObjectName : cmp.get("v.objectName"),
             fieldNamesStr : cmp.get("v.fieldsString"),
             Orderby : cmp.get("v.sortedBy"),
             OrderDir : cmp.get("v.sortedDirection")
         });
		 action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue().ldwList);
                cmp.set("v.columns", response.getReturnValue().ldwList);
                cmp.set("v.data", response.getReturnValue().sobList);
                cmp.set("v.fieldsList", response.getReturnValue().fieldsList);
                cmp.set('v.loadMoreStatus', '');
                event.getSource().set("v.isLoading", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    fetchData: function (cmp,  event, numberOfRecords) {
       
         //var dataPromise;
         var data = cmp.get("v.data");
         var dataSize = cmp.get("v.data").length;
         var lastId = data[dataSize - 1].Id;
        console.log('--lastId----'+lastId);
         var action = cmp.get("c.getsObjectRecords");
         action.setParams({
         	ObjectName : cmp.get("v.objectName"),
            fieldNameSet : cmp.get("v.fieldsList"),
            LimitSize : 50,
            recId : lastId,
            Orderby : cmp.get("v.sortedBy"),
            OrderDir : cmp.set("v.sortedDirection")
         });
		 action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                if (cmp.get('v.data').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.enableInfiniteLoading', false);
                    cmp.set('v.loadMoreStatus', 'No more data to load');
                } else {
                    var currentData = cmp.get('v.data');
                    var newData = currentData.concat(response.getReturnValue());
                    cmp.set('v.data', newData);
                    cmp.set('v.loadMoreStatus', '');
                }
                event.getSource().set("v.isLoading", false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.data", data);
    },
    
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }

  });
