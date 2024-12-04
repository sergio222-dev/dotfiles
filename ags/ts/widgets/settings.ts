const settings = Widget.Box({
  vertical: true,
  className: "settings window",
  widthRequest: 960,
  heightRequest: 540,
  // homogeneous: false,
  children: [
    Widget.Box({
      children: [
        Widget.Label("Main Settings"),
        Widget.Button({
          label: "Cerrar",
          hpack: "end",
        })
        ]
    }),
    Widget.Box({
      className: "separator",
    })
  ]
})

export const settingWindow = Widget.Window({
  name: "settings",
  monitor: 0,
  child: settings,
})
