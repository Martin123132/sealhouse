import http from 'http';
import fs from 'node:fs/promises';
import path from 'node:path';
import Parse from 'parse/node';
import { ParseServer } from 'parse-server';

export const dropDB = async () => {
  await Parse.User.logOut();
  return await Parse.Server.database.deleteEverything(true);
};
let parseServerState = {};

function setTestEnvDefaults() {
  process.env.TESTING = 'true';
  process.env.SERVER_URL = 'http://localhost:30001/test';
  process.env.APP_ID = 'test';
  process.env.MASTER_KEY = 'test';
  process.env.USE_LOCAL = 'true';
  process.env.APP_NAME = 'Sealhouse';
  process.env.FILES_SUBDIRECTORY = 'files/smoke';
}

/**
 * Starts the ParseServer instance
 * @param {Object} parseServerOptions Used for creating the `ParseServer`
 * @return {Promise} Runner state
 */
export async function startParseServer() {
  setTestEnvDefaults();
  const { app, config } = await import('../../index.js');
  delete config.databaseAdapter;
  const parseServerOptions = Object.assign(config, {
    databaseURI: 'mongodb://localhost:27017/parse-test',
    masterKey: 'test',
    javascriptKey: 'test',
    appId: 'test',
    port: 30001,
    mountPath: '/test',
    serverURL: `http://localhost:30001/test`,
    logLevel: 'error',
    silent: true,
  });
  const parseServer = new ParseServer(parseServerOptions);
  await parseServer.start();
  app.use(parseServerOptions.mountPath, parseServer.app);
  const httpServer = http.createServer(app);
  await new Promise(resolve => httpServer.listen(parseServerOptions.port, resolve));
  Object.assign(parseServerState, {
    parseServer,
    httpServer,
    parseServerOptions,
  });
  return parseServerOptions;
}

export async function cleanupTestFiles() {
  if (process.env.FILES_SUBDIRECTORY !== 'files/smoke') return;
  await fs.rm(path.join(process.cwd(), process.env.FILES_SUBDIRECTORY), {
    recursive: true,
    force: true,
  });
}

/**
 * Stops the ParseServer instance
 * @return {Promise}
 */
export async function stopParseServer() {
  await new Promise(resolve => parseServerState.httpServer.close(resolve));
  parseServerState = {};
}
