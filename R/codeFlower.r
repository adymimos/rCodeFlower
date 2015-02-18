codeFlower <- function(data, root,child, tooltip = "", color = "#EEEEEE",
  textColor = "#333333", width = NULL, height = NULL) {
  json <- jsonize(data,root,child)
  # forward options using x
  x = data.frame(
    data = json,
    tooltip = tooltip,
    color = color,
    textColor = textColor
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'codeFlower',
    x,
    width = width,
    height = height,
    package = 'rCodeFlower',
    sizingPolicy = sizingPolicy(
      defaultWidth = 600,
      defaultHeight = 600
    )
  )
}

jsonize <- function ( data, root,child) {
  require(data.table)
  names(data)[names(data) == child] <- 'child'
  dt <- data.table(data)
  new <- dt[,sum(child),by=root]
  d <- data.frame(name = root,size = sum(new$V1))
  to_json(d, orient = 'records')
}


to_json = function(df, orient = "columns", json = T){
  dl = as.list(df)
  dl = switch(orient, 
              columns = dl,
              records = do.call('zip_vectors_', dl),
              values = do.call('zip_vectors_', setNames(dl, NULL))
  )
  if (json){
    dl = rjson::toJSON(dl)
  }
  return(dl)
}

zip_vectors_ = function(..., names = F){
  x = list(...)
  y = lapply(seq_along(x[[1]]), function(i) lapply(x, pluck_(i)))
  if (names) names(y) = seq_along(y)
  return(y)
}

pluck_ = function (element){
  function(x) x[[element]]
}


codeFlowerOutput <- function(outputId, width = '600px', height = '600px'){
  shinyWidgetOutput(outputId, 'codeFlower', width, height, package = 'rCodeFlower')
}

rendercodeFlower <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, codeFlowerOutput, env, quoted = TRUE)
}
