import { MenuOption } from "../components/menuOption";

const menu = Widget.Box({
  className: "menu_widget_class",
  hpack: "fill",
  vpack: "center",
  children:[ Widget.Box({
    vertical: true,
    homogeneous: false,
    spacing: 12,
    children: [
      MenuOption("Settings"),
      MenuOption("Restart"),
      MenuOption("Shutdown"),
    ]
  }),],
})

export const menuWindow = Widget.Window({
  name: "menu",
  child: menu,
  className: "menu_window debug",
  anchor: ["top", "left", "bottom", "right"],
  monitor: 0,
  // heightRequest: 1080,
  // widthRequest: 1920,
});
