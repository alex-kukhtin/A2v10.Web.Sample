
const template: Template = {
	events: {
		'$product.import.done': productImportDone
	}
}

export default template;

function productImportDone(this: IRoot) {
	this.$ctrl.$reload();
}
