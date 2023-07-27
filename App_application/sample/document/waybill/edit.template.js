define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const du = require('std:utils').date;
    const template = {
        properties: {
            'TRow.Sum'() { return this.Qty * this.Price; },
            'TDocument.Sum': getDocumentSum
        },
        defaults: {
            'Document.Date'() { return du.today(); }
        },
        events: {},
        validators: {
            'Document.Rows[].Qty': 'Введіть кількість',
            'Document.Rows[].Price': 'Введіть ціну',
            'Document.Rows[].Product': 'Оберіть товар',
            'Document.Agent': 'Оберіть контрагента'
        },
        commands: {
            test
        }
    };
    exports.default = template;
    function getDocumentSum() {
        return this.Rows.reduce((p, c) => p + c.Sum, 0);
    }
    function test() {
        let rawErrors = this.$vm.$getErrors();
        console.dir(rawErrors);
        let errs = rawErrors.map(e => { return { msg: e.msg, ix: e.index, path: e.path.x }; });
        console.dir(errs);
        console.dir(this.Document.Rows[2]._errors_);
    }
});
