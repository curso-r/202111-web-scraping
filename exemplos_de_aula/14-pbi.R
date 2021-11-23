
library(RSelenium)
drv <- rsDriver(browser = "firefox")
ses <- drv$client
ses$navigate("https://google.com")
elem <- ses$findElement("xpath", "//input[@name='q']")
elem$sendKeysToElement(list("ibovespa", key = "enter"))
Sys.sleep(2)
ses$screenshot(file = "output/ibovespa.png")

# exemplo power bi --------------------------------------------------------


u_pbi <- "https://app.powerbi.com/view?r=eyJrIjoiNDA1ZmJkOTktYjIxZC00YWIxLTg2ZjgtNDY3NjE1MmE3NTM3IiwidCI6ImFkOTE5MGU2LWM0NWQtNDYwMC1iYzVjLWVjYTU1NGNjZjQ5NyIsImMiOjJ9&pageName=ReportSectiondafa4924ddb5d073a0a0"
ses$navigate(u_pbi)

elem <- ses$findElement("xpath", "//div[contains(@class, 'slicerText') and @title='Estadual']")
elem$clickElement()

checkbox <- ses$findElement("xpath", "//span[@class='slicerText' and text()='TJRR']")
checkbox$clickElement()

# agora vamos para o TST
checkbox <- ses$findElement("xpath", "//span[@class='slicerText' and text()='TST']")
checkbox$clickElement()

# precisa scrollar T_T

scroll <- ses$findElement("xpath", "//div[contains(@class,'scrolly_visible')]")
scroll$executeScript(
  "arguments[0].scrollBy(0,1000)", 
  args = list(scroll)
)

checkbox <- ses$findElement("xpath", "//span[@class='slicerText' and text()='TST']")
checkbox$clickElement()


# desafio! arrastar a bolinha ---------------------------------------------

bolinhas <- ses$findElements("xpath", "//div[@class='noUi-touch-area']")

bolinhas[[1]]$clickElement()
barrinha <- ses$findElements("xpath", "//div[contains(@class,'noUi-connect')]")

barrinha[[1]]$mouseMoveToLocation(x = 10, webElement = barrinha[[1]])
barrinha[[1]]$click()

str_detect()