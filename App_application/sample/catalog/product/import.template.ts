
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
		uploadFile
	}
}

export default template;

function modelLoad(root, caller) {
	indexPage = caller;
}

function uploadFile(result) {
	this.Done = true;
	this.Inserted = result.Result.Inserted;
	this.Updated = result.Result.Updated;
	indexPage?.$emit('$product.import.done');
}

