#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                Copyright (c) Chen Kai-Hung, Ward
#
#====================================================================

import resource/resource
import wNim/[wApp, wFrame, wPanel, wMenu, wIcon, wImage, wBitmap,
  wStatusBar, wToolBar, wListBox]

type
  MenuID = enum
    idTool1 = wIdUser, idTool2, idTool3, idTool4, idTool5, idExit

let app = App(wSystemDpiAware)
let frame = Frame(title="Toolbar")
frame.icon = Icon("", 0) # load icon from exe file.

let statusbar = StatusBar(frame)
let toolbar = ToolBar(frame)
let panel = Panel(frame)
panel.margin = 5

# Toolbar has the transparent look by default.
toolbar.backgroundColor = panel.backgroundColor

let listbox = ListBox(panel, pos=(0, 0), style=wLbNeededScroll or wLbNoSel)

const resource1 = staticRead(r"images/1.png")
const resource2 = staticRead(r"images/2.png")
const resource3 = staticRead(r"images/3.png")
const resource4 = staticRead(r"images/4.png")
const resource5 = staticRead(r"images/5.png")

let img1 = Image(resource1).scale(36, 36)
let img2 = Image(resource2).scale(36, 36)
let img3 = Image(resource3).scale(36, 36)
let img4 = Image(resource4).scale(36, 36)
let img5 = Image(resource5).scale(36, 36)

toolbar.addTool(idTool1, "Tool 1", Bitmap(img1), "Tool1", "This is normal tool.")
toolbar.addCheckTool(idTool2, "Tool 2", Bitmap(img2), "Tool2", "This is check tool.")
toolBar.addSeparator()
toolbar.addRadioTool(idTool3, "Tool 3", Bitmap(img3), "Tool3", "This is radio tool.")
toolbar.addRadioTool(idTool4, "Tool 4", Bitmap(img4), "Tool4", "This is radio tool.")
toolBar.addSeparator()
toolbar.addDropdownTool(idTool5, "Tool 5", Bitmap(img5), "Tool5", "This is dropdown tool.")

var menu = Menu()
menu.append(idExit, "E&xit", "Exit the program.")
toolbar.setDropdownMenu(idTool5, menu)

frame.wEvent_Tool do (event: wEvent):
  listbox.ensureVisible(listbox.append($MenuID(event.id) & " clicked"))
  if event.id == idExit:
    frame.delete()

panel.wEvent_Size do ():
  panel.layout:
    listbox:
      width = panel.width
      height = panel.height

frame.center()
frame.show()
app.mainLoop()
