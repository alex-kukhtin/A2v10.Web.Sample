
let indexPage;

const template: Template = {
	properties: {
		'TRoot.Done': Boolean,
		'TRoot.Inserted': Number,
		'TRoot.Updated': Number
	},
	events: {
		"Model.load": modelLoad,
	},
	delegates: {
	}
}

export default template;

function modelLoad(root, caller) {
	indexPage = caller;
}
