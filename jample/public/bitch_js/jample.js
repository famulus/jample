
var freeze_patch = function(patch_id, checkbox_status){
	$.ajax({
	  url: ("freeze_patch/"+patch_id+"/"+checkbox_status),
	  context: document.body
	}).done(function(data) {
	  console.log("DONE")
	});

console.log("in function")
console.log(patch_id)
}