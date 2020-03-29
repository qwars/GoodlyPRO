import '@fortawesome/fontawesome-free/js/all.js'
import './indes.styl'

import 'imba-router'

import Application from './application'

import Header from './elements/header'
import Footer from './elements/footer'
import Congestion, Pittance  from './elements/documents'


tag Main < main
	def render
		<self>
			<Congestion route="/*$">
			<Pittance route="/:id">

Imba.mount <Application>
Imba.mount <Header>
Imba.mount <Main>
Imba.mount <Footer>