
import './index.styl'

export tag Widget < em
	prop prefix default: 'fas'
	prop icon default: 'fa-quote-right'
	def render
		<self>
			<i.{ prefix }.{ icon }>
			<span> data or ''

export tag SummaryString < Widget
	@classes = ['info-string']

export tag SummaryBlock < Widget
	@classes = ['info-block']
