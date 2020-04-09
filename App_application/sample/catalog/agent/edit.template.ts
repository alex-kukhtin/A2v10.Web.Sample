
const template: Template = {
	validators: {
		'Agent.Name': '@[Error.Empty]',
		'Agent.EMail': { valid: StdValidator.email, msg:'@[Error.EMail]' },
	},
	commands: {

	}
}

export default template