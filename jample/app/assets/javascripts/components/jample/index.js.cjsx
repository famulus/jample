Jample = React.createClass

  getInitialState: ->
    state = 
      currentPatch: @props.current_patch.patch_index
    for key,value of @props
      state[key] = value
    state
  componentDidMount: ->
    @debounce = _.debounce(@set_filter, 500) 
    @set_filter()
    midi = undefined
    data = undefined
    # request MIDI access
    # midi functions
    
    onMIDISuccess = (midiAccess) ->
      # when we get a succesful response, run this code
      midi = midiAccess
      # this is our raw MIDI data, inputs, outputs, and sysex status
      inputs = midi.inputs.values()
      # loop over all available inputs and listen for any MIDI input
      input = inputs.next()
      while input and !input.done
        # each time there is a midi message call the onMIDIMessage function
        input.value.onmidimessage = onMIDIMessage
        input = inputs.next()
      return

    onMIDIFailure = (error) ->
      # when we get a failed response, run this code
      console.log 'No access to MIDI devices or your browser doesn\'t support WebMIDI API. Please use WebMIDIAPIShim ' + error
      return

    onMIDIMessage = (message) =>
      data = message.data
      # this gives us our [command/channel, note, velocity] data.
      if  (data[0] == 144) && (data[1] < 52) # the < 52 ignore the foot pedal
        console.log 'MIDI data', data
        previous_state = @state
        @setState(currentPatch: (data[1] - 36))
        @set_current_patch()
      # MIDI data [144, 63, 73]
      return

    if navigator.requestMIDIAccess
      navigator.requestMIDIAccess(sysex: false).then onMIDISuccess, onMIDIFailure
    else
      alert 'No MIDI support in your browser.'

    # ---
    # generated by js2coffee 2.2.0
  render: ->
    currentPatch = _.find(@state.patch_set.patches, (patch) => return (patch.patch_index == @state.currentPatch ))
    currentTrack = currentPatch.track
    <div className="wrapper">
      <div className="row">
        <div className="col-md-6">  
          <div className="form-group">  
            Filter
            <input type="text" onKeyUp={@debounce} id="filter_input" className="form-control" />
            <button type="button" className="btn btn-info" onClick={@set_filter}>Go</button>
            <button type="button" className="btn btn-info" onClick={@clear_filter}>Clear</button>
            {@state.current_filter_size} Tracks
          </div>
        </div>
      </div>

      <div className="row">
        {@grid()}
        <div className="col-md-6">  
          <p>
            <button type="button" className="btn btn-info" onClick={@init_16_patches}>Random Patches</button>
            <button type="button" className="btn btn-info" onClick={@init_16_patches_as_sequence}>Random Sequence</button>
            <button type="button" className="btn btn-info" onClick={@expand_single_patch_to_sequence}>Patch to Sequence</button>
            <button type="button" className="btn btn-info" onClick={@duplicate_patch_set}>Duplicate</button>
          </p>

          <p>
            <button type="button" className="btn btn-danger" onClick={@shuffle_unfrozen}>Shuffle Unfrozen</button>
          </p>

          <p>
            <button type="button" className="btn btn-info" onClick={@grow_patch_by_one_on_the_end}>Grow Loop</button>
            <button type="button" className="btn btn-info" onClick={@shrink_patch_by_one_on_the_end}>Shrink Loop</button>
            <button type="button" className="btn btn-info" onClick={@shift_sample_backward_one_slice}>Shift Backward</button>
            <button type="button" className="btn btn-info" onClick={@shift_sample_forward_one_slice}>Shift Forward</button>
            <button type="button" className="btn btn-info" onClick={@set_filter_to_current_patch_track}>Patch to Filter</button>
          </p>

          <p>
            {currentPatch.patch_index}
          </p>

          <p>
            {currentTrack.track_name_pretty}
          </p>
          
          <p>
            {currentTrack.path_and_file}
          </p>
          
          <p>
            Onset Index:
            {currentPatch.start_onset_index}
          </p>
          
          <p>
            Onset Times:
            {currentPatch.start_onset_time}
            <br/>
            to<br/>
            {currentPatch.stop_onset_time}

          </p>
          
          <p>
            track_id: {currentTrack._id}
          </p>
          
          mp3: {@mp3_display(@state.mp3_set[@state.currentPatch])}
          
          <p>
            <button type="button"  disabled={!@state.patch_set.next_patch_set} id={@state.patch_set.next_patch_set} className="btn btn-info" onClick={@set_current_patch_set}>Next PatchSet</button>
          </p>
          
          <p>
            <button type="button" disabled={!@state.patch_set.previous_patch_set} id={@state.patch_set.previous_patch_set} className="btn btn-info" onClick={@set_current_patch_set}>Prev PatchSet</button>
          </p>
        
        </div>  
      </div>

      <div className="row">
        <div className="col-md-12">  
        </div>  
      </div>

      <div className="row">
        <div className="col-md-6">  
          <div className="form-group">  
            <label>Patch Set Name
              <input type="text" id="current_patch_set_name" className="form-control" />
            </label>
            <button type="button" className="btn btn-info" onClick={@set_current_patch_set_name}>Go</button>
          </div>

        </div>  
      </div>
      <div className="row">
        <div className="col-md-6">  
          <table className="table">
          { @state.named_patch_sets.map (patch_set) => <tr><td><a href="#"  id={patch_set._id.$oid} onClick={@set_current_patch_set}>{patch_set.patch_set_label}</a></td></tr>}
          </table>
        </div>  
      </div>



    </div>

  mp3_display: (mp3_data) ->
    for key,value of mp3_data
      <div><span>{key}: </span><span>{value}</span></div>


  set_current_patch_set: (e) ->
    console.log("set_current_patch_set")
    $.ajax
      url: 'set_current_patch_set'
      method: "POST"
      data:
        patch_id: e.currentTarget.id
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data) 


  set_current_patch_set_name: ->
    console.log("set_current_patch_set_name")
    $.ajax
      url: 'set_current_patch_set_name'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
        current_patch_set_name: $('#current_patch_set_name').val()
      success: (data) =>
        @setState(data)
        console.log(data) 
        

  set_current_patch: ->
    console.log("set_current_patch")
    $.ajax
      url: 'set_current_patch/' + (@state.currentPatch + 1)
      method: "GET"
 
  set_filter_to_current_patch_track: ->
    console.log("set_filter_to_current_patch_track")
    currentTrack = @state.track_set[@state.currentPatch]
    $('#filter_input').val(currentTrack._id.$oid)
    @set_filter()

  clear_filter: ->
    console.log("clear_filter")
    $('#filter_input').val("")
    @set_filter()

  init_16_patches_as_sequence: ->
    console.log("init_16_patches_as_sequence")
    $.ajax
      url: 'init_16_patches_as_sequence'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  grow_patch_by_one_on_the_end: ->
    console.log("grow_patch_by_one_on_the_end")
    $.ajax
      url: 'grow_patch_by_one_on_the_end'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  shrink_patch_by_one_on_the_end: ->
    console.log("shrink_patch_by_one_on_the_end ")
    $.ajax
      url: 'shrink_patch_by_one_on_the_end  '
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  shift_sample_backward_one_slice: ->
    console.log("shift_sample_backward_one_slice")
    $.ajax
      url: 'shift_sample_backward_one_slice'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  shift_sample_forward_one_slice: ->
    console.log("shift_sample_forward_one_slice")
    $.ajax
      url: 'shift_sample_forward_one_slice'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  set_filter: ->
    console.log("set_filter")
    $.ajax
      url: 'set_filter/'
      method: "POST"
      data:
        filter_text: $('#filter_input').val()
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

  duplicate_patch_set: ->
    console.log("duplicate_patch_set")
    $.ajax
      url: 'duplicate_patch_set/'
      method: "POST"
      data:
        authenticity_token: @props.authenticity_token
      success: (data) =>
        @setState(data)
        console.log(data)

    

  expand_single_patch_to_sequence: ->
    console.log("expand_single_patch_to_sequence")
    $.ajax
      url: 'expand_single_patch_to_sequence'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)


  shuffle_unfrozen: ->
    console.log("shuffle_unfrozen")
    $.ajax
      url: 'shuffle_unfrozen'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)
    
  init_16_patches: ->
    console.log("init_16_patches")
    $.ajax
      url: 'init_16_patches/'
      data:
        authenticity_token: @props.authenticity_token
      method: "POST"
      success: (data) =>
        @setState(data)
        console.log(data)




  freezePatchCallback: (e) ->
    console.log($(e.currentTarget).is(':checked'))
    console.log($(e.currentTarget).val())
    chosen_patch = $(e.currentTarget).val()
    frozen = $(e.currentTarget).is(':checked')
    $.ajax
      url: 'freeze_patch/'+chosen_patch+'/'+frozen+'/'
      method: "GET"
      success: (data) =>
        @setState(data)
        console.log(data)

  grid: ->
    console.log("OKOK")
    reversed_patches = _.sortBy(@state.patch_set.patches, (element) -> return parseInt(element.patch_index))
    console.log(reversed_patches.slice(0,4))
    <div className="col-md-6">  
      <table className="table">
        <tbody>
          <tr>
            { reversed_patches.slice(12,16).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
          </tr>
          <tr>
            { reversed_patches.slice(8,12).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
          </tr>
          <tr>
            { reversed_patches.slice(4,8).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
          </tr>
          <tr>
            { reversed_patches.slice(0,4).map (patch) => <Patch freezePatchCallback={@freezePatchCallback} key={patch._id.$oid} currentPatch={@state.currentPatch } patch={patch}/>}
          </tr>
        </tbody>
      </table>
    </div>

window.Jample = Jample
