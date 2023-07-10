
import { TDocument } from '../document';

const du = require('std:utils').date as UtilsDate;

interface TRoot extends IRoot {
	Document: TDocument;
}

const template: Template = {
	properties: {
		'TRow.Sum'() { return this.Qty * this.Price; },
		'TDocument.Sum': getDocumentSum
	},
	events: {
	},
	commands: {

	},
	defaults: {
		'Document.Date'() { return du.today(); }
	}
}

export default template;

function getDocumentSum(this: TDocument): number {
	return this.Rows.reduce((p, c) => p + c.Sum, 0);
}
