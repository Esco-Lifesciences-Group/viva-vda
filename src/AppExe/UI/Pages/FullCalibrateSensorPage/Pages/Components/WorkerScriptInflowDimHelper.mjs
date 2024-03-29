WorkerScript.onMessage = function(msg) {

    //    ////console.debug(msg.action === "calculate")

    if (msg.action === "calculate") {

        WorkerScript.sendMessage(
                    {"action": "calculate", "status": "started"}
                    );

        let meaUnit = msg.meaUnit
        let area = msg.area
        let gridItems = msg.grid
        let valueBased = 0;
        let valueFormatBased = 0;
        let valueBasedImp = 0;
        let valueFormatBasedImp = 0;
        let acceptedCount = 0;
        let acceptedAll = 0;

        let gridValue = []

        let i=0;
        for(i; i<gridItems.length; i++) {
            valueBased = gridItems[i]["val"]
            valueFormatBased = Number(valueBased).toFixed()
            valueBasedImp = gridItems[i]["valImp"]
            valueFormatBasedImp = Number(valueBasedImp).toFixed()
            //////console.debug(valueBased)
            if(meaUnit)//Imperial
                gridValue.push(valueBasedImp)
            else
                gridValue.push(valueBased)

            gridItems[i]["valSf"] = valueFormatBased
            gridItems[i]["valImpSf"] = valueFormatBasedImp

            ///check eccepted field
            if (gridItems[i]["acc"] === 1) {
                acceptedCount = acceptedCount + 1
            }
        }

        ///are all field was acc
        acceptedAll = acceptedCount === gridItems.length ? 1 : 0

        ////
        let dataVal = gridValue
        let minVal  = Math.min.apply(Math, dataVal)
        let maxVal  = Math.max.apply(Math, dataVal)
        let sumVal  = Math.round(dataVal.reduce(function(a,b){return a + b}, 0) * 100.0) / 100.0
        let avgVal  = /*Math.round*/((sumVal / dataVal.length) * 100.0) / 100.0

        //        //console.debug("avgVal 1", avgVal)
        avgVal = Math.round(avgVal)
        //        //console.debug("avgVal 2", avgVal)
        sumVal = Math.round(sumVal)

        //        //console.debug("area:", area)

        let velVal  = 0
        if (meaUnit) {
            /// imperial
            velVal  = Math.round(avgVal / area)
        }
        else {
            /// metric
            velVal  = ((avgVal / area) / 1000.0)
            //            //console.debug("velVal:", velVal)
            //            velVal  = /*Math.round*/((((avgVal / area) / 1000.0) * 100.0) / 100.0).toFixed(2)
            //            //console.debug("velVal: "  + velVal)
            const velValStr = Number(velVal).toFixed(2)
            //            //console.debug("velValStr: "  + velValStr)
            //velValStr = velValStr.charAt(0) + velValStr.charAt(1) + velValStr.charAt(2) + velValStr.charAt(3)
            velVal = Number(velValStr)
            //            //console.debug("velVal: "  + velVal)
        }


        //        ////console.debug("area: "    + area)
        //        ////console.debug("minVal: "  + minVal)
        //        ////console.debug("maxVal: "  + maxVal)
        //        ////console.debug("sumVal: "  + sumVal)
        //        ////console.debug("avgVal: "  + avgVal)
        //        ////console.debug("velVal: "  + velVal)
        //        ////console.debug("acceptedCount: "  + acceptedCount)
        //        ////console.debug("acceptedAll: "  + acceptedAll)

        let gridStringify = JSON.stringify(gridItems)
        //        //console.debug("Inflow Dim Helper Calculate")
        //        //console.debug(gridStringify)

        //        ////console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "calculate",
                        "status": "finished",
                        "grid": gridItems,
                        "gridStringify": gridStringify,
                        "minVal": minVal,
                        "maxVal": maxVal,
                        "sumVal": sumVal,
                        "avgVal": avgVal,
                        "velVal": velVal,
                        "acceptedCount": acceptedCount,
                        "acceptedAll": acceptedAll}
                    );
    }//
    else if (msg.action === "init") {

        WorkerScript.sendMessage(
                    {"action": "init", "status": "started"}
                    );

        let count = msg.count

        let gridItems = []

        if (msg.grid !== undefined) {
            gridItems = msg.grid
        }
        else{
            try {
                gridItems = JSON.parse(msg.gridStringify)
            }
            catch (e) {
                //            ////console.debug("JSON.parse failed: " + e)
            }
        }

        /// ensure the grids items from parse result is equal with requirement
        /// if lesser than it, adding
        /// if more than it, substract
        let validateCountNeed = count - gridItems.length
        if(validateCountNeed > 0) {
            let valueBased = 0.0;
            let valueFormatBased = Number(valueBased).toFixed()
            let valueBasedImp = 0.0;
            let valueFormatBasedImp = Number(valueBasedImp).toFixed()

            let i=0;
            for(i; i<validateCountNeed; i++) {
                gridItems.push({"val": valueBased, "valSf": valueFormatBased, "valImp": valueBasedImp, "valImpSf": valueFormatBasedImp, "acc": 0})
            }
        }
        else if(validateCountNeed < 0) {
            let loop = Math.abs(validateCountNeed)
            let i=0;
            for(i; i<validateCountNeed; i++) {
                gridItems.pop()
            }
        }

        let gridStringify = JSON.stringify(gridItems)
        //        //console.debug("Inflow Dim Helper Init")
        //        //console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "init", "status": "finished", "grid": gridItems, "gridStringify": gridStringify}
                    );
    }//
    else if (msg.action === "generate") {

        WorkerScript.sendMessage(
                    {"action": "generate", "status": "started"}
                    );

        let count = msg.count

        let gridItems = []

        //        let valueBased = 0.30;
        let valueBased = 0.0;
        let valueFormatBased = Number(valueBased).toFixed()
        let valueBasedImp = 0.0;
        let valueFormatBasedImp = Number(valueBasedImp).toFixed()

        let i=0;
        for(i; i<count; i++) {
            gridItems.push({"val": valueBased, "valSf": valueFormatBased, "valImp": valueBasedImp, "valImpSf": valueFormatBasedImp, "acc": 0})
        }

        let gridStringify = JSON.stringify(gridItems)
        //        //console.debug("Inflow Dim Helper Generate")
        //        //console.debug(gridStringify)

        WorkerScript.sendMessage(
                    {"action": "generate", "status": "finished", "grid": gridItems, "gridStringify": gridStringify}
                    );
    }//
}//
