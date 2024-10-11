const core = require('@actions/core');
const exec = require('@actions/exec');

async function run() {
    try {
        const version = core.getInput('version');
        const src = __dirname;
        await exec.exec(`${src}/git_update.sh -v ${version}`);
    }
    catch (error) {
        core.setFailed(error.message);
    }
}

run();