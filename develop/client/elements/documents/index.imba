import './index.styl'

const moment = require 'moment'

import Figure from '../figure'
import CreatePittance from '../create-pittance'

import Widget as Loading from '../loading'
import SummaryBlock as NoData from '../no-data'

tag ClipImage
	def render
		<self> <svg:svg>
			<svg:defs>
				<svg:linearGradient id="gradient" x1="0" y1="00%" x2 ="0" y2="100%">
					<svg:stop stop-color="black" offset="0">
					<svg:stop stop-color="white" offset="1">
			# <svg:mask id="masking" maskUnits="objectBoundingBox" maskContentUnits="objectBoundingBox">
			# 	<svg:rect y="0.3" width="1" height=".7" fill="url(#gradient)">
			# 	<svg:rect y="0.3" width="1" height=".7" fill="white">

tag ContactItem < address
	def render
		<self>
			<label> <input[ data:name ] .new-element=hasFlag('new-element') type="text" placeholder="Name client" required=true>
			<del> <i.far.fa-trash-alt>
			for item, idx in data:emails
				<span> item
				<del :tap=( do data:emails.splice idx, 1 )> <i.far.fa-trash-alt>
			<label> <input@contactEmail type="email" .new-element=hasFlag('new-element') placeholder="Email client" required=true>
			<kbd.link :tap=( do @contactEmail.value = '' if @contactEmail.dom:validity:valid and data:emails.push @contactEmail.value )>  <i.fas.fa-plus-square>
			for item, idx in data:phones
				<span> item
				<del :tap=( do data:phones.splice idx, 1 )> <i.far.fa-trash-alt>
			<label> <input@contactPhone .new-element=hasFlag('new-element') type="text" placeholder="Phone client" required=true>
			<kbd.link :tap=( do @contactPhone.value = '' if @contactPhone.dom:validity:valid and data:phones.push @contactPhone.value   )> <i.fas.fa-plus-square>

export tag Pittance < article
	prop contact default:
		name: ''
		emails: []
		phones: []

	def updateDocumentName
		condition:document:name = @documentName.dom:innerText.trim.replace /\s+/g, ' '

	def preloadFile e
		let reader = FileReader.new
		reader:onload = do |et| render if condition:document:data = et:target:result
		reader.readAsDataURL e.target.dom:files[0]

	def backupData
		@backup = {} unless @backup
		if condition:document:isText
			@backup:image = condition:document:data
			condition:document:data = @backup:text || ''
		else
			@backup:text = condition:document:data
			condition:document:data = @backup:image || ''

	def updateDocumentData
		condition:document:name = @documentName.dom:innerHtml

	def createComtact
		Object.assign @contact, @_contact:default if  @contact:name and condition:document:contacts.push @contact

	def emptyData
		@backup = {} unless @backup
		@backup:image = condition:document:data
		condition:document:data = ''

	def reloadData
		condition:document:data = @backup:image

	def render
		<self :input.updateDocument :change.updateDocument>
			unless condition and condition:document then <Loading>
			else if condition:document isa String then <blockquote> condition:document
			else
				<fieldset .element-is-text=condition:document:isText>
					<legend> <pre@documentName contenteditable=true data-placeholder="Name for banner" :input.silence.updateDocumentName> condition:document:name
					<em>
						<div>
							<label>
								<input[ condition:document:isText ] type="checkbox" :change.backupData>
								<cite> "This is text? - "
							<label>
								<input[ condition:document:isActive ] type="checkbox">
								<cite> "This is active? - "
						<aside>
							<span>
								<kbd.link> <i.far.fa-object-ungroup>
								<kbd.link> <i.fas.fa-chart-line>
								<span> "Fashion: "
								<b> condition:document:viewers || 0
							<kbd>
					<form@dataElement :submit.prevent>
						<label> <input[ condition:document:title ] type="text" placeholder="Title">
						<label> <input[ condition:document:link ] type="url" placeholder="Link">
						<.params-element>
							<label>
								<legend> "Width banner"
								<input[ condition:document:params:width ] type="number" min=0 placeholder="Auto">
							<label>
								<legend> "Height banner"
								<input[ condition:document:params:height ] type="number" min=0 placeholder="Auto">
							<label>
								<legend> "Position top banner"
								<input[ condition:document:params:top ] type="number" placeholder="Auto">
							<label>
								<legend> "Position left banner"
								<input[ condition:document:params:left ] type="number" placeholder="Auto">
							<label>
								<input[ condition:document:clip ] type="checkbox">
								<cite> "This is clip? - "

						if condition:document:clip then <.params-element>
							<label>
								<legend> "Clip top"
								<input[ condition:document:params:ctop ] type="number" min=0 placeholder="Auto">
							<label>
								<legend> "Clip right"
								<input[ condition:document:params:cright ] type="number" min=0 placeholder="Auto">
							<label>
								<legend> "Clip bottom"
								<input[ condition:document:params:cbottom ] type="number" placeholder="Auto">
							<label>
								<legend> "Clip left"
								<input[ condition:document:params:cleft ] type="number" placeholder="Auto">
							<span>
						<figure>
							if condition:document:isText then <pre @documentData contenteditable=truedata-placeholder="Text for banner" :input.silence.updateDocumentData > condition:document:data
							else
								<label>
									<aside>
										if condition:document:data then <kbd> <i.far.fa-image>
										if condition:document:data then <del :tap.prevent.stop.emptyData> <i.far.fa-trash-alt>
										else if @backup:image then <kbd :tap.prevent.stop.reloadData> <i.fas.fa-sync-alt>
									<input type="file" :change.preloadFile accept="image/*">
								unless condition:document:data then <span> <i.far.fa-image>
								else
									<ClipImage[ condition:document:params ]>
									<var> <img src=condition:document:data .masking=condition:document:clip>
				<fieldset>
					<legend> "Client contact"
					<form@dataClient :submit.prevent>
						<ContactItem[ item ]> for item, index in condition:document:contacts
						<ContactItem.new-element[ @contact ]>
						<button.info :tap.createComtact>
							<i.fas.fa-user-plus>
							<span> "Add new contact"

tag CongestionItem < Figure
	def render
		<self>
			<del :tap.prevent.stop.deleteDocument( data:id )> <i.far.fa-trash-alt>
			<aside>
			<pre> data:description
			<time> "Updated: { moment( data:updatedAt ).format 'MMMM D, YYYY' }"
			<figcaption>
				<span> data:name
				<aside>

export tag Congestion < article
	def createItemFilter
		@search.value = '' if @search.value and not filtrate.includes( @search.value.trim ) and filtrate.create @search.value.trim

	def removeItemFilter idx
		filtrate.remove idx

	def render
		<self>
			<blockquote>
				<h2> "Banners for sites"
				<CreatePittance title="Create new banner" placeholder="Name for new banner" :supply.createNewDocument>
				if condition and condition:collection and condition:collection:length then <dfn>
					<.search-text>
						<label> <input@search type="text" placeholder="Search text" :keyup.enter.createItemFilter>
						<button .info=!!@search.value :tap.createItemFilter >
							<i.fas.fa-search-plus>
							<span> "Add a tag filtering"
					<section> for item, idx in filtrate
						<span>
							<span> item
							<del :tap.removeItemFilter( idx ) html="&#10005;">
			unless condition then <Loading>
			else if condition:collection and condition:collection:length then <ul>
				<li route-to="/{ item:id }"> <CongestionItem[ item ]> for item in condition:collection
			else
				<NoData>