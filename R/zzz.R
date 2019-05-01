.onAttach <- function(lib, pkg){
  
  welcome <-
"https://alternativ.nu/butik
             __                                           __    
.----.-----.|  |_.----.-----.-----.-----.---.-.----.----.|  |--.
|   _|  -__||   _|   _|  _  |__ --|  -__|  _  |   _|  __||     |
|__| |_____||____|__| |_____|_____|_____|___._|__| |____||__|__|
"

  packageStartupMessage(welcome)
}