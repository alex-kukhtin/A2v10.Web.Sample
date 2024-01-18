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
        delegates: {}
    };
    exports.default = template;
    function modelLoad(root, caller) {
        indexPage = caller;
    }
});
