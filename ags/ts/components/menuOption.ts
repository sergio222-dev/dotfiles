export function MenuOption(text: string) {
  return Widget.EventBox({
    className: "menu_option",
    hexpand: true,
    child:     Widget.CenterBox({
      centerWidget: Widget.Button({
        cursor: "pointer",
        child: Widget.Label(text),
      }),
    })
  })
}
