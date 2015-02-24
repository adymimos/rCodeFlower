codeFlower <- function(data, width = NULL, height = NULL) {
   #json <- jsonize(data,root,child)
  # forward options using x
  x = data.frame(
    data = data
  )
  #x <- list(name='test',size=3)
  # create widget
  htmlwidgets::createWidget(
    name = 'codeFlower',
    data,
    width = width,
    height = height,
    package = 'rCodeFlower',
    sizingPolicy = sizingPolicy(
      defaultWidth = 600,
      defaultHeight = 600
    )
  )
}

nestedize <- function(name,size,root='Root',child=FALSE) {
  header <- sprintf("{\"name\": \"%s\",\"children\": [",root)
  
  footer <- sprintf("],\"size\": %d }",sum(size))
  df <- data.frame(name,size)
  if(child ==FALSE)
  {
    nodes <-paste(mapply(createNode,df$name,df$size),sep='',collapse = ",")
    return(paste0(header,nodes,footer))
  }
  else
  {
    nodes <- paste(name,collapse=',')
    return(paste0(header,nodes,footer))
  }
}

form_flower <- function ( data,root,child,size) {
  df <- data.frame(data,root,child,size)
  t <- plyr::ddply(df, .(root), function(x) {
    child <- nestedize(x$data,x$size,root=x$root[1])
    size <- sum(x$size)
    data.frame(child,size)
  })
  d2 <- nestedize(t$child,t$size,child=TRUE)
  return(d2)
}

codeFlowerOutput <- function(outputId, width = '600px', height = '600px'){
  shinyWidgetOutput(outputId, 'codeFlower', width, height, package = 'rCodeFlower')
}

rendercodeFlower <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, codeFlowerOutput, env, quoted = TRUE)
}
