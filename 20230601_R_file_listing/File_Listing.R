options(width = 200)


# P "../" -> "./"
ch = FALSE
sizeReport = function(path,patt=".*",dironly=FALSE,level=Inf){
  pathslashes = lengths(regmatches(path, gregexpr("/", path)))
  if (patt == ".*"){
    patt = ""
  }
  if (endsWith(patt, '$')){
    patt = substr(patt,1,nchar(patt)-1)
  }
  if (path == '../'){
    ch=TRUE
    path = './'
  }
  
  a = data.frame(matrix(ncol = 2, nrow = 0))
  colnames(a) = c("path", "size")
 
    if (level == 0) {
      a[nrow(a) + 1,] = c("../", file.info(".")$size)
    }
    else{
      all_items = list.dirs(path = path, full.names = TRUE, recursive = TRUE)
      for (i in all_items){
        if (ch==TRUE){
          dir1 = paste(".", i,sep="")
          slashcount = lengths(regmatches(dir1, gregexpr("/", dir1)))
          if (!(dir1 %in% a$path) & slashcount <= pathslashes + level & grepl(patt, dir1, fixed = TRUE)) {
            a[nrow(a) + 1,] = c(dir1, file.info(i)$size)
          }
       }
       else {
          si = toString(i)
          slashcount = lengths(regmatches(i, gregexpr("/", i)))
          if (!(i %in% a$path) & slashcount <= pathslashes + level & grepl(patt, i, fixed = TRUE)) {
           a[nrow(a) + 1,] = c(i, file.info(i)$size)
          }
       }
        if (dironly == FALSE){
          for (f in list.files(i)) {
            if (ch==TRUE){
              dir2 = paste(".", i,"/", f, sep="")
              slashcount2 = lengths(regmatches(dir2, gregexpr("/", dir2)))
              if (slashcount2 <= pathslashes + level & grepl(patt, dir2, fixed = TRUE)){
                a[nrow(a) + 1,] = c(dir2, file.info( paste(i, f, sep="/"))$size)
              }
            }
            else {
              slashcount2 = lengths(regmatches(i, gregexpr("/", i)))
              if (slashcount2 < pathslashes +level & grepl(patt, i, fixed = TRUE)){
                a[nrow(a) + 1,] = c(paste(i, f, sep="/"), file.info( paste(i, f, sep="/"))$size)
              }
            }
          }
        }
      }
    }
  a
}