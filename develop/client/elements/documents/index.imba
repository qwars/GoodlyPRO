import './index.styl'

const moment = require 'moment'

import Figure from '../figure'
import CreatePittance from '../create-pittance'

export tag Pittance < article
	def render
		<self>
			<fieldset>
				<legend> <pre contenteditable=true data-placeholder="Name for banner">
				<aside>
					<em>
						<label>
							<input type="checkbox">
							<cite> "This is text? - "
					<kbd>
				<form@dataElement :submit.prevent>
					<label> <input type="text" placeholder="Title">
					<label> <input type="url" placeholder="Link">
					<figure>
						<img>
						<label> <input type="file">
			<fieldset>
				<legend> "Client contact"
				<form@dataClient :submit.prevent>
					<address>
						<label> <input type="text" placeholder="Name client">
						<label> <input type="text" placeholder="Email client">
						<kbd>
						<label> <input type="text" placeholder="Phone client">
						<kbd>
					<button> "Add new contact"

tag CongestionItem < Figure
	def render
		<self>
			<del>
			<aside>
			<pre> "Description"
			<time> "Time: { moment( Date.now ).format 'MMMM D, YYYY' }"
			<figcaption>
				<span> "Name"
				<aside>

export tag Congestion < article
	def render
		<self>
			<blockquote>
				<h2> "Banners for sites"
				<CreatePittance title="Create new banner" placeholder="Name for new banner">
				<dfn>
					<.search-text>
						<label> <input@search type="text" placeholder="Search text">
						<button .active=!!@search.value> "Search"
					<section>
						<span>
			<ul>
				<li> <CongestionItem> for item in Array.new 20