define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        events: {
            '$product.import.done': function () {
                this.$ctrl.$reload();
            }
        }
    };
    exports.default = template;
});
