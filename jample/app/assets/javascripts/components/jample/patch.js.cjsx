Patch = React.createClass
  render: ->
    console.log("PATCH RENDER")
    <td className={ if @isCurrent() then "bg-info" else "" }>
      {@props.patch.patch_index}<br/>
      {@props.patch.track.track_name_pretty}<br/>
      <input 
      type="checkbox" name="freeze" value={@props.patch._id.$oid} className="big_checkbox" 
      checked={@props.patch.frozen == "true"}

      onChange={@props.freezePatchCallback}
      />

    </td>

  isCurrent: ->
    @props.patch.patch_index == @props.currentPatch

window.Patch = Patch
