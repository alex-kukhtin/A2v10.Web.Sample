
import { TDocument } from '../document';

const template: Template = {
	properties: {
		'TDocument.Sum': getDocumentSum
	},
	commands: {

	}
}

export default template;

function getDocumentSum(this: TDocument): number {
	return this.Rows.reduce((p, c) => p + c.Sum, 0);
}