
import './index.styl'

export tag CreatePittance < aside
	prop title
	prop placeholder

	def activeteField
		activeteFieldClose @dataset.dom.focus

	def activeteFieldClose
		@active = !@active
		@dataset.value = ''

	def render
		<self .active=@active>
			<label>
				<input@dataset type="text" placeholder=placeholder required=true :blur.activeteFieldClose>
			<button :tap.activeteField> title