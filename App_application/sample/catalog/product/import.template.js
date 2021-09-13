define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    let indexPage;
    const template = {
        properties: {
            'TRoot.Done': Boolean,
            'TRoot.Inserted': Number,
            'TRoot.Updated': Number
        },
        events: {
            "Model.load": modelLoad,
        },
        delegates: {
            uploadFile
        }
    };
    exports.default = template;
    function modelLoad(root, caller) {
        indexPage = caller;
    }
    function uploadFile(result) {
        this.Done = true;
        this.Inserted = result.Result.Inserted;
        this.Updated = result.Result.Updated;
        indexPage === null || indexPage === void 0 ? void 0 : indexPage.$emit('$product.import.done');
    }
});
