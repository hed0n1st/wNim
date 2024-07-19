#====================================================================
#
#               wNim - Nim's Windows GUI Framework
#                Copyright (c) Chen Kai-Hung, Ward
#
#====================================================================

import resource/resource

import wNim/[wApp, wFrame, wPanel, wMenuBar, wMenu, wIcon, wBitmap,
  wStaticText, wTextCtrl, wToolBar, wButton, wStatusBar, wMessageDialog]

proc passwordDialog(owner: wWindow): string =
  var password = ""
  let dialog = Frame(owner=owner, size=(320, 200), style=wCaption or wSystemMenu)
  let panel = Panel(dialog)

  let statictext = StaticText(panel, label="Please enter the password:", pos=(10, 10))
  let textctrl = TextCtrl(panel, pos=(20, 50), size=(270, 30),
    style=wBorderSunken or wTePassword)
  let buttonOk = Button(panel, label="&OK", size=(90, 30), pos=(100, 120))
  let buttonCancel = Button(panel, label="&Cancel", size=(90, 30), pos=(200, 120))

  const ok = staticRead(r"images/ok.ico")
  const cancel = staticRead(r"images/cancel.ico")

  # Add a [X] button to delete the text.
  let toolbar = ToolBar(panel)
  toolbar.backgroundColor = wWhite
  toolbar.addTool(wIdDelete, "", Bitmap(Icon("shell32.dll,131", (16, 16))))
  toolbar.undock()
  textctrl.setBuddy(toolbar, wRight, 24)

  buttonOk.setDefault()
  buttonOk.setIcon(Icon(ok))
  buttonCancel.setIcon(Icon(cancel))
  dialog.icon = Icon(ok)

  dialog.wIdDelete do ():
    textctrl.clear()

  dialog.wEvent_Close do ():
    dialog.endModal()

  buttonOk.wEvent_Button do ():
    password = textctrl.value
    dialog.close()

  buttonCancel.wEvent_Button do ():
    dialog.close()

  dialog.shortcut(wAccelNormal, wKey_Esc) do ():
    buttonCancel.click()

  dialog.center()
  dialog.showModal()
  dialog.delete()

  result = password

when isMainModule:
  type
    MenuID = enum
      idOpen = wIdUser
      idExit
      idButton

  let app = App(wSystemDpiAware)
  let frame = Frame(title="wNim PasswordDialog", size=(480, 320))
  frame.icon = Icon("", 0) # load icon from exe file.

  let statusbar = StatusBar(frame)
  let button = Button(frame, label="Open Dialog")
  let menubar = MenuBar(frame)
  let menu = Menu(menubar, "&File")
  menu.append(idOpen, "&Open", "Open the dialog.")
  menu.appendSeparator()
  menu.append(idExit, "E&xit", "Exit the program.")

  button.wEvent_Button do ():
    let password = passwordDialog(frame)
    if password.len != 0:
      MessageDialog(frame, password, "Password", wOk or wIconInformation).display()

  frame.idOpen do ():
    button.click()

  frame.idExit do ():
    frame.close()

  frame.center()
  frame.show()
  app.mainLoop()
