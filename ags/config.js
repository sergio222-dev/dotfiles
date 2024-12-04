const entry =  App.configDir + "/ts/main.ts";
const output = '/tmp/ags-main/js';

console.log(output);

try {
  await Utils.execAsync([
    "bun", 'build', entry,
    '--outdir', output,
    '--external', 'resource://*',
    '--external', 'gi://*',
  ]);
  await import(`file://${output}/main.js`);
} catch (e) {
  console.log(e);
}

export { };
