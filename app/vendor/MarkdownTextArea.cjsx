## modified from
# https://github.com/KyleAMathews/react-markdown-textarea/blob/master/src/index.cjsx

React = require 'react/addons'
Textarea = require('react-textarea-autosize')
marked = require 'marked'

module.exports = React.createClass
  displayName: 'MarkdownTextarea'

  getDefaultProps: ->
    buttonText: "Save"
    onSave: (value) ->
    onDelete: ->
    onChange: (value) ->
    deleteButton: false
    spinnerOptions: {}

  getInitialState: ->
    state = {
      active: 'preview'
      value: if @props.initialValue? then @props.initialValue else ""
    }

    return state

  render: ->
    # Class names
    cx = React.addons.classSet
    writeTabClasses = cx({
      'react-markdown-textarea__nav__item': true
      'react-markdown-textarea__nav__item--active': @state.active is "write"
    })
    previewTabClasses = cx({
      'react-markdown-textarea__nav__item': true
      'react-markdown-textarea__nav__item--active': @state.active is "preview"
    })

    ulStyles = {
      display: 'inline-block'
    }
    liStyles = {
      listStyle: 'none'
      float: 'left'
      cursor: 'pointer'
    }
    textareaStyles = {
      display: 'block'
      resize: 'none'
      fontSize: '16'
    }

    # Are we writing or previewing?
    #
    # Swap between writing and previewing states.

    if @props.cancelEdit
      # HACK!!
      setTimeout(=>
        @setState active: 'preview'
      , 2)

    if @state.active is 'write' and not @props.cancelEdit
      textarea = @transferPropsTo(<Textarea
        className="react-markdown-textarea__textarea"
        value={@state.value}
        onChange={@handleChange}
        ref="textarea"
        style={textareaStyles}
       />)
    else
      textarea = <div
          onClick={@handleClick}
          className="react-markdown-textarea__preview"
          style={{fontSize: '16'}}
          dangerouslySetInnerHTML={__html: marked(@state.value)}>
      </div>

    tabs = ''

    # Add preview?
    # unless @props.noPreview
    #   tabs =
    #     <ul className="react-markdown-textarea__nav" onMouseDown={@toggleTab} style={ulStyles}>
    #       <li className={writeTabClasses} style={liStyles}>Edit</li>
    #       <li className={previewTabClasses} style={liStyles}>Save</li>
    #     </ul>

    return (
      <div className="react-markdown-textarea">
        {tabs}
        <div className="react-markdown-textarea__textarea-wrapper">
          {textarea}
        </div>
      </div>
    )
          # <button
          #   onClick={@_onSave}
          #   disabled={if @props.saving then "disabled" else false}
          #   className="react-markdown-textarea__save-button">
          #     {@props.buttonText}
          # </button>
          # { if @props.deleteButton
          #   <button
          #     onClick={@_onDelete}
          #     disabled={if @props.saving then "disabled" else false}
          #     className="react-markdown-textarea__delete-button">
          #       Delete
          #   </button>
          # }
          # {if @props.saving and @props.spinner?
          #   @props.spinner(@props.spinnerOptions)
          # }

  toggleTab: (e) ->
    # Ignore clicks not on an li
    unless e.target.tagName is "LI" then return
    # Ignore clicks on the active tab.
    if "react-markdown-textarea__nav__item--active" in e.target.className.split(/\s+/)
      return

    if @state.active is "write"
      @setState active: 'preview'
    else
      @setState active: 'write'

  handleChange: (e) ->
    newValue = @refs.textarea.getDOMNode().value
    @setState value: newValue
    @props.onChange(newValue)

  handleClick: (e) ->
    return @props.onClickLink(e) if (e.target.getAttribute('href'))

    if @state.active is 'write'
      @setState active: 'preview'
    else
      @setState active: 'write'

  _onSave: ->
    @props.onSave(@state.value)

  _onDelete: ->
    @props.onDelete()