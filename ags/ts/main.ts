import { menuWindow }    from "./widgets/menu";
import { settingWindow } from "./widgets/settings";

const scss = `${App.configDir}/styles/styles.scss`;

const css = `/tmp/ags-styles.css`;

Utils.exec(`sassc ${scss} ${css}`);

Utils.monitorFile(`${App.configDir}/styles`, function () {
  const scss = `${App.configDir}/styles/styles.scss`;

  const css = `/temp/ags-styles.css`;

  Utils.exec(`sass ${scss} ${css}`);
  App.resetCss();
  App.applyCss(css);
})

App.config({
  windows: [settingWindow],
  style: css,
})
