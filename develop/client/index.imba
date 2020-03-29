import './indes.styl'

import Application from './application'

import Header from './elements/header'
import Footer from './elements/footer'

tag Main < main
	def render
		<self> "Main"

Imba.mount <Application>
Imba.mount <Header>
Imba.mount <Main>
Imba.mount <Footer>