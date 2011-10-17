var hackaphoto={
  unique_id_prefix:"hackaphoto-unique-",
  current_unique_id:0
}

hackaphoto.init=function() {
  hackaphoto.content_node = $("div.content");
  hackaphoto.dash();
}

hackaphoto.dash=function() {
  

  var grid_id=hackaphoto.unique_id(), grid_container = $("<div id='"+grid_id+"'><p class='loading'>Loading...</p></div>"),offset=$("li.media-photo").length;

  hackaphoto.content_node.append(grid_container)

  $("p.pagination").remove();

  $.get("/user/dashboard?offset="+offset,function(data) {
    console.log(data);
    grid_container.html("<ul class='media-grid'></ul>");
    
    var grid=grid_container.find("ul.media-grid"),i,n=data.response.posts.length,last_post=0;
    for (i=0;i<n;i++) {
      var post = data.response.posts[i],j,p=post.photos.length;
      for (j=0;j<p;j++) {
        var photo = post.photos[j],n_sizes=photo.alt_sizes.length,s,d;
        for (s=0;s<n_sizes;s++) {
          var alt_photo = photo.alt_sizes[s];
          if (alt_photo.width == 250) {
            var li = $("<li class='media-photo'><a href='"+post.post_url+"' target='_blank'><img src='"+alt_photo.url+"' width='"+alt_photo.width+"' height='"+alt_photo.height+"'/></a></li>");
            li.attr("data-caption",post.caption);
            li.attr("data-url",post.post_url);
            li.attr("data-blogname",post.blog_name);
            li.attr("data-content","<h3><a href='"+post.post_url+"'>"+post.blog_name+"</a>:</h3><div class='caption'>"+post.caption+"</div>")
            grid.append(li);
          }
        }
      }
      last_post = post.id;
    }
    if (n == 20) {
      grid_container.append("<div class='pagination'><ul><li class='next'><a href='javascript:hackaphoto.dash()'>Load More!</a></li></ul></div>")
    }
    hackaphoto.init_popovers(grid_id);
    document.location = "#"+grid_id;
  })
}

hackaphoto.init_popovers=function(id) {

}

hackaphoto.unique_id=function() {
	hackaphoto.current_unique_id++;
	return hackaphoto.unique_id_prefix+hackaphoto.current_unique_id;
}

$(document).ready(function() {
  hackaphoto.init();
})