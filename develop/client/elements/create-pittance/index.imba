
import './index.styl'

export tag CreatePittance < aside
	prop title
	prop placeholder

	def activeteField e
		if @inputdata.value and @inputdata.dom:validity then trigger 'supply', self
		unless @active then @active = not @inputdata.dom.focus()

	def activeteFieldClose
		@active = false

	def render
		<self .active=@active>
			<label> <input@inputdata type="text" placeholder=placeholder required=true :blur.activeteFieldClose>
			<button :tap.activeteField .active=!!@inputdata.value>
				<i.far.fa-share-square>
				<i.far.fa-plus-square>
				<span> title