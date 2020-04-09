define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const du = require('std:utils').date;
    const template = {
        properties: {
            'TRow.Sum'() { return this.Qty * this.Price; },
            'TDocument.Sum': getDocumentSum
        },
        events: {
            'Model.load': modelLoad
        },
        commands: {}
    };
    exports.default = template;
    function getDocumentSum() {
        return this.Rows.reduce((p, c) => p + c.Sum, 0);
    }
    function modelLoad() {
        this.Document.Date = du.today();
    }
});
