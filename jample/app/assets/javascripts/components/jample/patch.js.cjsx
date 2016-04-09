Patch = React.createClass
  render: ->
    <td className={ if @isCurrent() then "bg-info" else "" }>
      PATCH {@props.patch.patch_index}
      {@isCurrent()}
    </td>

  isCurrent: ->
    @props.patch.patch_index == @props.currentPatch

window.Patch = Patch
