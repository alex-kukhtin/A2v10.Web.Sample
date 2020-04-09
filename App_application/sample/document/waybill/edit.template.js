define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        properties: {
            'TDocument.Sum': getDocumentSum
        },
        commands: {}
    };
    exports.default = template;
    function getDocumentSum() {
        return this.Rows.reduce((p, c) => p + c.Sum, 0);
    }
});
