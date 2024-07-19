#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                Copyright (c) Chen Kai-Hung, Ward
#
#====================================================================

import
  strformat,
  resource/resource

import wNim/[wApp, wFrame, wIcon, wStatusBar, wMenuBar, wMenu, wBitmap, wImage,
  wPanel, wMenuBarCtrl]

type
  # A menu ID in wNim is type of wCommandID (distinct int) or any enum type.
  MenuID = enum
    idOpen = wIdUser, idExit
    idIcon1, idIcon2, idIcon3, idIcon4, idIcon5, idIcon6
    idCheck1, idCheck2, idRadio1, idRadio2, idRadio3
    idEnable, idDisable, idAbout

const resources: array[idIcon1..idIcon6, string] = [
  staticRead(r"images/1.png"),
  staticRead(r"images/2.png"),
  staticRead(r"images/3.png"),
  staticRead(r"images/4.png"),
  staticRead(r"images/5.png"),
  staticRead(r"images/6.png") ]

let
  app = App(wSystemDpiAware)
  frame = Frame(title="wNim Menu Demo")
  panel = Panel(frame)
  statusBar = StatusBar(frame)
  menuBar = MenuBar(frame)

frame.icon = Icon("", 0) # load icon from exe file.

let menuFile = Menu(menuBar, "&File")
menuFile.append(idOpen, "&Open", "Open a file.")
menuFile.appendSeparator()
menuFile.append(idExit, "E&xit", "Exit the program.")

let menuIcon = Menu(menuBar, "&Icon")
for id in idIcon1..idIcon6:
  let bmp = Bitmap(Image(resources[id]).scale(36, 36))
  menuIcon.append(id, $id, $id & " Help", bmp)

let menuTest = Menu(menuBar, "&Test")
menuTest.appendCheckItem(idCheck1, "Check 1", "Check 1 Help").check()
menuTest.appendCheckItem(idCheck2, "Check 2", "Check 2 Help")
menuTest.appendSeparator()
menuTest.appendRadioItem(idRadio1, "Radio 1", "Radio 1 help").check()
menuTest.appendRadioItem(idRadio2, "Radio 2", "Radio 2 help")
menuTest.appendRadioItem(idRadio3, "Radio 3", "Radio 3 help")
menuTest.appendSeparator()
menuTest.append(idEnable, "Enable", "Enable the icon menu and about")
menuTest.append(idDisable, "Disable", "Disable the icon menu and about")
menuTest.appendSeparator()
menuTest.appendSubMenu(menuIcon, "&Icon", "Icon menu here.").disable()

let menuAbout = Menu(menuBar, "&About")
let itemAbout = menuAbout.append(idAbout, "About", "About")

let menuBarCtrl = MenuBarCtrl(panel, menuBar=menuBar, statusBar=statusBar)
menuBarCtrl.suit()

frame.wEvent_Size do ():
  frame.autolayout """
    HV:[panel(70%)]|
  """

  panel.autolayout """
    H:|[menuBarCtrl]|
    V:|[menuBarCtrl]
  """

# frame.connect(idExit) is syntax sugar for frame.connect(wEvent_Menu, idExit)
# frame.idExit is syntax sugar for frame.connect(idExit)

frame.idExit do ():
  frame.delete

frame.idEnable do ():
  menuIcon.enable
  itemAbout.enable

frame.idDisable do ():
  menuIcon.disable
  itemAbout.disable

frame.wEvent_Menu do (event: wEvent):
  let item = menuBar.findItem(event.id)
  let help = menuBar.getHelp(event.id)
  var msg: string

  if item != nil and item.isCheck:
    msg = fmt"{item.text} is checked: {item.isChecked}"
  else:
    msg = fmt"{MenuID(event.id)} is selected, help is ""{help}""."

  statusBar.setStatusText(msg)
  event.skip # make sure idExit event pass to next handler

frame.wEvent_ContextMenu do ():
  frame.popupMenu(menuTest)

frame.center()
frame.show()
app.mainLoop()
