
import './index.styl'

export tag Widget
	@classes = ['loading-page']
	def render
		<self> <i.fas.fa-snowflake>

export tag SummaryString < span
	@classes = ['loading']
	def render
		<self>
			<i.fas.fa-snowflake>
			<span> 'loading...'

export tag SummaryBlock < Widget