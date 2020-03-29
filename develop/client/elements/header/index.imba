import './index.styl'

const logoProjectSRC = require '../../images/logo.png'

export tag Header < header
	def render
		<self>
			<a route-to="/">
				<img src=logoProjectSRC:default>
				<span> "GoodlyPRO"
			<section>
			<aside>