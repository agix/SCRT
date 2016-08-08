#= require vendor/smooth-scroll
#= require_tree .

smoothScroll.init()

fixedHeaderPosition = 400
fixedHeaderClass = 'shown'
fixedHeader = document.querySelector '.header--fixed'
isHeaderFixed = ->
  if window.scrollY > fixedHeaderPosition
    fixedHeader.classList.add fixedHeaderClass
  else
    fixedHeader.classList.remove fixedHeaderClass

window.addEventListener 'scroll', (e)->
  isHeaderFixed()

tabToggles = document.querySelectorAll('[data-toggle-tab]')
[].forEach.call tabToggles, (tabToggle)->
  tabToggle.addEventListener 'click', (e)->
    document.querySelector('.section-tabs-link.current')?.classList.remove('current')
    document.querySelector('.section-tab.current')?.classList.remove('current')

    tab = document.querySelector("[data-tab='#{tabToggle.dataset.toggleTab}']")
    tab.classList.add 'current'
    tabToggle.classList.add 'current'
  , false

modalToggles = document.querySelectorAll('[data-toggle-modal]')
[].forEach.call modalToggles, (modalToggle)->
  modalToggle.addEventListener 'click', (e)->
    console.log modalToggle.dataset
    modal = document.querySelector("[data-modal='#{modalToggle.dataset.toggleModal}']")
    return unless modal
    if modal.classList.contains('shown')
      modal.classList.remove('shown')
    else
      modal.classList.add('shown')
      input = modal.querySelector('input')
      setTimeout ->
        input.focus()
      , 200
  , false

form = document.querySelector('form')
form.addEventListener 'submit', (e)->
  e.preventDefault()

  form.classList.add('pending')
  form.querySelector("input[type='submit']").disabled = true

  urlEncodedDataPairs = []
  for field in form.elements
    break if field.type is 'submit'
    urlEncodedDataPairs.push "#{encodeURIComponent(field.name)}=#{encodeURIComponent(field.value)}"
  urlEncodedData = urlEncodedDataPairs.join('&').replace(/%20/g, '+')

  XHR = new XMLHttpRequest()

  XHR.addEventListener 'readystatechange', (e)->
    return unless XHR.readyState is 4
    form.classList.add('done')

  XHR.open 'POST', '//fwd.forwarder.cc/forms/d032b195-6a9c-4ca3-a43c-3c195f93f79e'
  XHR.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'

  XHR.send urlEncodedData

  false
