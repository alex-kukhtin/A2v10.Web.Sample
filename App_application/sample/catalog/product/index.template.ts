
const template: Template = {
	events: {
		'$product.import.done': function(this: IRoot) {
			this.$ctrl.$reload();
		}
	}
}

export default template;
