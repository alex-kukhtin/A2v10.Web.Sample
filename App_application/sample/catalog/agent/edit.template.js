define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    const template = {
        validators: {
            'Agent.Name': '@[Error.Empty]',
            'Agent.EMail': { valid: "email", msg: '@[Error.EMail]' },
        },
        commands: {}
    };
    exports.default = template;
});
