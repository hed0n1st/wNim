#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                Copyright (c) Chen Kai-Hung, Ward
#
#====================================================================

import resource/resource
import wNim/[wApp, wFrame, wIcon, wMessageDialog]

let app = App(wSystemDpiAware)
let frame = Frame(title="Hello World", size=(350, 200))
frame.icon = Icon("", 0) # load icon from exe file.

frame.wEvent_Destroy do ():
  MessageDialog(frame, "wMyFrame is about to destroy.",
    "wEvent_Destroy", wOk or wStayOnTop).showModal()

frame.wEvent_Close do (event: wEvent):
  let dlg = MessageDialog(frame, "Do you really want to close this application?",
    "Confirm Exit", wOkCancel or wIconQuestion)

  if dlg.showModal() != wIdOk:
    event.veto()

frame.center()
frame.show()
app.mainLoop()
