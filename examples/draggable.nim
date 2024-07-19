#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                Copyright (c) Chen Kai-Hung, Ward
#
#====================================================================

import resource/resource
import wNim/[wApp, wFrame, wIcon, wMenuBar, wMenu, wStatusBar, wSplitter, wButton]

type
  MenuID = enum
    idLayout1 = wIdUser, idLayout2, idEnable, idExit

let app = App(wSystemDpiAware)
let frame = Frame(title="Draggable GUI Demo")
let statusBar = StatusBar(frame)
let menuBar = MenuBar(frame)
frame.margin = 10
frame.icon = Icon("", 0) # load icon from exe file.

let menu = Menu(menuBar, "&Action")
menu.appendRadioItem(idLayout1, "Layout&1", "Switch to layout 1.").check()
menu.appendRadioItem(idLayout2, "Layout&2", "Switch to layout 2.")
menu.appendSeparator()
menu.appendCheckItem(idEnable, "&Enable", "Enable or disable the splitter.").check()
menu.appendSeparator()
menu.append(idExit, "E&xit", "Exit the program.")

let splitter1 = Splitter(frame,
  style=wSpVertical or wClipChildren,
  pos=(100, 0), size=(10, 0))

let splitter2 = Splitter(splitter1.panel1,
  style=wSpHorizontal or wSpButton or wClipChildren,
  pos=(0, 100), size=(0, 10))

let panel1 = splitter2.getPanel1
let panel2 = splitter2.getPanel2
let panel3 = splitter1.getPanel2

panel1.margin = 10
panel2.margin = 10
panel3.margin = 10

panel1.backgroundColor = wWheat
panel2.backgroundColor = wWheat
panel3.backgroundColor = wThistle

# let splitter1 invisible, but can drag by window's margin
splitter1.setInvisible()
splitter1.attachPanel()

let button1 = Button(panel1, label="Button1")
let button2 = Button(panel2, label="Button2")
let button3 = Button(panel3, label="Button3")

# let buttons' size can be changed by user
button1.sizingBorder = (10, 10, 10, 10)
button2.sizingBorder = (10, 10, 10, 10)
button3.sizingBorder = (10, 10, 10, 10)

# let buttons' position can be changed by user
button1.setDraggable(true)
button2.setDraggable(true)
button3.setDraggable(true)

button1.wEvent_Button do (): splitter2.swap
button2.wEvent_Button do (): splitter2.swap
button3.wEvent_Button do (): splitter1.swap

proc layout() =
  button1.setSize((0, 0), panel1.clientSize)
  button2.setSize((0, 0), panel2.clientSize)
  button3.setSize((0, 0), panel3.clientSize)

panel1.wEvent_Size do (): layout()
panel2.wEvent_Size do (): layout()
panel3.wEvent_Size do (): layout()

frame.idExit do ():
  frame.delete()

frame.idLayout1 do ():
  splitter1.setSplitMode(wVertical)
  splitter2.setSplitMode(wHorizontal)
  splitter1.position = (150, 0)
  splitter2.position = (0, 100)

frame.idLayout2 do ():
  splitter1.setSplitMode(wHorizontal)
  splitter2.setSplitMode(wVertical)
  splitter1.position = (0, 150)
  splitter2.position = (100, 0)

frame.idEnable do ():
  splitter1.enable(menuBar.isChecked(idEnable))
  splitter2.enable(menuBar.isChecked(idEnable))

layout()
frame.center()
frame.show()
app.mainLoop()
