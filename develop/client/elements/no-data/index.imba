
import './index.styl'

export tag Widget
	def render
		<self>
			<i.fas.fa-server>
			<span> data or 'No Data'

export tag SummaryString < Widget
	@classes = ['no-data']

export tag SummaryBlock < Widget
	@classes = ['no-data-page']
